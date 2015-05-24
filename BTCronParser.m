//
//  BTCronParser.m
//  BTCron
//
//  Created by Thaddeus Ternes on 5/9/15.
//  Copyright (c) 2015 Bluetoo Ventures. All rights reserved.
//

#import "BTCronParser.h"
#import "BTCronSchedule.h"

@implementation BTCronParser

/*
    --------------------------------------------------------------------------------------------------
    Source: http://en.wikipedia.org/wiki/Cron
    --------------------------------------------------------------------------------------------------

    # * * * * *  command to execute
    # │ │ │ │ │
    # │ │ │ │ │
    # │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
    # │ │ │ └────────── month (1 - 12)
    # │ │ └─────────────── day of month (1 - 31)
    # │ └──────────────────── hour (0 - 23)
    # └───────────────────────── min (0 - 59)



    Nonstandard predefined scheduling definitions:
    Entry                   Description                                                 Equivalent to
    --------------------------------------------------------------------------------------------------
    @yearly (or @annually)	Run once a year at midnight of January 1                    0 0 1 1 *
    @monthly                Run once a month at midnight of the first day of the month	0 0 1 * *
    @weekly                 Run once a week at midnight on Sunday morning               0 0 * * 0
    @daily                  Run once a day at midnight                                  0 0 * * *
    @hourly                 Run once an hour at the beginning of the hour               0 * * * *
    @reboot                 Run at startup

 
    CRON expression
    Field name      Mandatory?	Allowed values      Allowed special characters
    --------------------------------------------------------------------------------------------------
    Minutes         Yes         0-59                * , -
    Hours           Yes         0-23                * , -
    Day of month	Yes         1-31                * , - ? L W
    Month           Yes         1-12 or JAN-DEC     * , -
    Day of week     Yes         0-6 or SUN-SAT      * , - ? L #
 
*/

- (NSDate *)nextDateForLine:(NSString *)line
{
    BTCronSchedule *expression = [[BTCronSchedule alloc] initWithSchedule:line];
    expression.baseDate = self.baseDate;
    expression.timezone = self.timezone;

    return [expression nextDate];
}

@end
