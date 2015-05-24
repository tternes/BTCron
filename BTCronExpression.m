//
//  BTCronExpression.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import "BTCronExpression.h"
#import "BTCronComponent.h"

@interface BTCronExpression ()
@property (nonatomic, copy) NSString *line;
@end

@implementation BTCronExpression

- (instancetype)initWithCronLine:(NSString *)line
{
    self = [super init];
    if(self)
    {
        _line = line;
    }

    return self;
}

- (NSDate *)nextDate
{
    BTCronComponent *component = [[BTCronComponent alloc] init];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self.line];

    NSNumber *minute = [component nextValueWithScanner:scanner];
    NSNumber *hour = [component nextValueWithScanner:scanner];
    NSNumber *dayOfMonth = [component nextValueWithScanner:scanner];
    NSNumber *month = [component nextValueWithScanner:scanner];
//    NSNumber *dayOfWeek = [component nextValueWithScanner:scanner];
    
    __block NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute = [minute integerValue];
    dateComponents.hour = [hour integerValue];
    dateComponents.day = [dayOfMonth integerValue];
    dateComponents.month = [month integerValue];
//    dateComponents.weekday = [dayOfWeek integerValue];

    __weak typeof(self) weakSelf = self;
    __block NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = self.timezone;
    
    __block NSInteger count = 0;
    __block NSDate *result = nil;
    
    // using nextDateAfterDate:matchingComponents:options: would be really great,
    // except that it returns March 1 when asking for February 29 on a non-leap year.
    [calendar enumerateDatesStartingAfterDate:self.baseDate matchingComponents:dateComponents options:NSCalendarMatchNextTime usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        NSLog(@"date: %@", date);
        
        NSDateComponents *resultComponents = [calendar componentsInTimeZone:weakSelf.timezone fromDate:date];
        if(resultComponents.minute == dateComponents.minute &&
            resultComponents.hour == dateComponents.hour &&
            resultComponents.day == dateComponents.day &&
            resultComponents.month == dateComponents.month)
        {
            result = date;
            *stop = YES;
        }
        
        
        if(++count > 4)
            *stop = YES;
    }];

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
