//
//  BTCronExpression.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import "BTCronSchedule.h"
#import "BTCronScheduleComponent.h"

@interface BTCronSchedule ()
@property (nonatomic, copy) NSString *line;
@end

@implementation BTCronSchedule

- (instancetype)initWithSchedule:(NSString *)schedule
{
    self = [super init];
    if(self)
    {
        _line = [[self class] scheduleByReplacingPredefinedScheduleInString:schedule];
    }

    return self;
}

- (NSDate *)nextDate
{
    BTCronScheduleComponent *component = [[BTCronScheduleComponent alloc] init];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self.line];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = self.timezone;

    __block NSNumber *minute = [component nextValueWithScanner:scanner];
    __block NSNumber *hour = [component nextValueWithScanner:scanner];
    __block NSNumber *dayOfMonth = [component nextValueWithScanner:scanner];
    __block NSNumber *month = [component nextValueWithScanner:scanner];
    __block NSNumber *dayOfWeek = [component nextValueWithScanner:scanner];
    __block NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    // if none of the components are specified (* * * * *), then use the next
    // minute as the minute component
    if(!minute &&
       !hour &&
       !dayOfMonth &&
       !month)
    {
        NSDate *futureDate = [self.baseDate dateByAddingTimeInterval:60];
        NSDateComponents *nextMinute = [calendar components:NSCalendarUnitMinute fromDate:futureDate];
        minute = @([nextMinute minute]);
    }
    
    if(minute)
        dateComponents.minute = [minute integerValue];
    
    if(hour)
        dateComponents.hour = [hour integerValue];
    
    if(dayOfMonth)
        dateComponents.day = [dayOfMonth integerValue];
    
    if(month)
        dateComponents.month = [month integerValue];
    
    if(dayOfWeek)
    {
        // Sunday = 0 in cron, but
        // Sunday = 1 in the NSCalendarComponents Gregorian calendar 
        dateComponents.weekday = [dayOfWeek integerValue] + 1;
    }

    __block NSInteger count = 0;
    __block NSDate *result = nil;
    __weak typeof(self) weakSelf = self;
    
    // using nextDateAfterDate:matchingComponents:options: would be really great,
    // except that it returns March 1 when asking for February 29 on a non-leap year.
    [calendar enumerateDatesStartingAfterDate:self.baseDate matchingComponents:dateComponents options:NSCalendarMatchNextTime usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {

        NSDateComponents *resultComponents = [calendar componentsInTimeZone:weakSelf.timezone fromDate:date];
        if( (!minute     || (resultComponents.minute == dateComponents.minute)) &&
            (!hour       || (resultComponents.hour == dateComponents.hour)) &&
            (!dayOfMonth || (resultComponents.day == dateComponents.day)) &&
            (!month      || (resultComponents.month == dateComponents.month)))
        {
            result = date;
            *stop = YES;
        }
        
        
        if(++count > 4)
            *stop = YES;
    }];

    return result;
}

#pragma mark - Class Methods

+ (NSString *)scheduleByReplacingPredefinedScheduleInString:(NSString *)schedule
{
    id map = @{
        @"@daily" : @"0 0 * * *"
    };
    
    NSString *result = schedule;
    for(NSString *predefined in [map allKeys])
    {
        result = [result stringByReplacingOccurrencesOfString:predefined withString:map[predefined]];
    }
    
    return result;
}

#pragma mark - Lazy

- (NSDate *)baseDate
{
    if(_baseDate == nil)
        _baseDate = [NSDate date];
    return _baseDate;
}

- (NSTimeZone *)timezone
{
    if(_timezone == nil)
        _timezone = [NSTimeZone systemTimeZone];
    return _timezone;
}

@end
