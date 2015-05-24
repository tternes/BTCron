//
//  BTCronExpression.h
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCronExpression : NSObject

@property (nonatomic, strong) NSDate *baseDate;
@property (nonatomic, strong) NSTimeZone *timezone;

- (instancetype)initWithCronLine:(NSString *)line;
- (NSDate *)nextDate;

@end
