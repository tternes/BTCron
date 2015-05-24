//
//  BTCronComponent.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/23/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import "BTCronComponent.h"

@implementation BTCronComponent

- (NSNumber *)nextValueWithScanner:(NSScanner *)scanner
{
    NSString *value = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&value];
    
    NSNumber *final = [formatter numberFromString:value];
    NSLog(@"final=%@", final);
    return final;
}

@end
