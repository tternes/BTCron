//
//  BTCronParser.h
//  BTCron
//
//  Created by Thaddeus Ternes on 5/9/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCronParser : NSObject

@property (nonatomic, strong) NSDate *baseDate;
@property (nonatomic, strong) NSTimeZone *timezone;

- (NSDate *)nextDateForLine:(NSString *)line;

@end
