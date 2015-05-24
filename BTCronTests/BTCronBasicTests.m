//
//  BTCronBasicTests.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/9/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "BTCronParser.h"

@interface BTCronBasicTests : XCTestCase
@property (nonatomic, strong) BTCronParser *parser;
@end

@implementation BTCronBasicTests

- (void)setUp
{
    [super setUp];
    self.parser = [[BTCronParser alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

//- (void)testEveryMinute
//{
//    NSString *line = @"1 2 3 4 5 command to run";
//    NSDate *next = [self.parser nextDateForLine:line];
//    NSDateComponents *components = [self componentsForDate:next];
//    XCTAssertEqual(components.minute, 0);
//}

- (NSDateComponents *)componentsForDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian componentsInTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0] fromDate:date];
}

@end
