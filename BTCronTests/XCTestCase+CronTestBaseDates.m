//
//  XCTestCase+CronTestBaseDates.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import "XCTestCase+CronTestBaseDates.h"

@implementation XCTestCase (CronTestBaseDates)

- (NSDate *)bt_baseDateForTests
{
    return [self bt_dateFromIsoString:@"1970-01-01 00:00"];
}

- (NSTimeZone *)bt_timezone
{
    return [NSTimeZone timeZoneForSecondsFromGMT:0];
}

- (NSDate *)bt_dateFromIsoString:(NSString *)iso
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [formatter setTimeZone:[self bt_timezone]];
    return [formatter dateFromString:iso];
}

@end
