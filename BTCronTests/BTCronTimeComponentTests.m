//
//  BTCronTimeComponentTests.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/9/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCronScheduleComponent.h"

@interface BTCronTimeComponentTests : XCTestCase
@property (nonatomic, strong) BTCronScheduleComponent *component;
@end

@implementation BTCronTimeComponentTests

- (void)setUp
{
    [super setUp];
    self.component = [[BTCronScheduleComponent alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNumericValues
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:@"10 2 3 4 5"];

    XCTAssertEqualObjects([self.component nextValueWithScanner:scanner], @(10));
    XCTAssertEqualObjects([self.component nextValueWithScanner:scanner], @(2));
    XCTAssertEqualObjects([self.component nextValueWithScanner:scanner], @(3));
    XCTAssertEqualObjects([self.component nextValueWithScanner:scanner], @(4));
    XCTAssertEqualObjects([self.component nextValueWithScanner:scanner], @(5));
}

- (void)testInvalidNumericValues
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:@"a b"];
    XCTAssertNil([self.component nextValueWithScanner:scanner]);
}

- (void)testEmptyValue
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:@""];
    XCTAssertNil([self.component nextValueWithScanner:scanner]);
}

@end
