//
//  AddData.m
//  FutureText
//
//  Created by Serguei Vinnitskii on 1/8/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import "AddData.h"

@implementation AddData

// Add data to NSUserDefaults
+(void) addDataUserDefaults: (NSDate *)date phoneNumber: (NSString *)number textMessage: (NSString *)textMessage
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"array"]];
    
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:date, @"date", number, @"number", textMessage, @"message", nil];
    [array addObject:newDictionary];
    
    // Remove old object
    [defaults removeObjectForKey:@"array"];
    
    // Add new updated object with new data
    [defaults setObject:array forKey:@"array"];
    
    [defaults synchronize];
    
}

// calculate number of rows
+(int) calculateNumberOfRows
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    array = [defaults objectForKey:@"array"];
    
    return (int)[array count];
}

// Retreve data from NSUserDefaults
+(NSMutableArray *) retreveDataUserDefaults
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"array"]];
    
    return array;
}

// Delete data from NSUserDefaults
+(void) deleteNotificationWithRowNumber: (int) row
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"array"]];
    NSDate *dateToDelete = [[array objectAtIndex:row] objectForKey:@"date"];

    // remove object at [row]
    [array removeObjectAtIndex:row];
    
    // cancel notification
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // If the date matches to the date we need to delete, this notificaion is cancelled
        if ([notification.fireDate compare:dateToDelete] == NSOrderedSame)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            
        }
    }
    
    // Remove old object from NSUserDefaults
    [defaults removeObjectForKey:@"array"];

    // Add new updated object with new data
    [defaults setObject:array forKey:@"array"];
    
    [defaults synchronize];
    
}

+(void) deleteNotificationWithDate: (NSDate *) date
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"array"]];
    
    // Let's alterate through our NSUserDefaults
    int objectIndex = 0;
    for (NSDictionary *dictionary in array) {
        
        NSDate *tempDate = [dictionary objectForKey:@"date"];
        if ([date compare:tempDate] == NSOrderedSame) break;
        objectIndex ++;
    }
    
    // after we've found our row (objectIndex) let's delete our notification using this info
    [self deleteNotificationWithRowNumber:objectIndex];
}

+(NSInteger) findRowBasedOnDate: (NSDate *)date
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"array"]];
    
    // Let's alterate through our NSUserDefaults
    NSInteger objectIndex = 0;
    for (NSDictionary *dictionary in array) {
        
        NSDate *tempDate = [dictionary objectForKey:@"date"];
        if ([date compare:tempDate] == NSOrderedSame) break;
        objectIndex ++;
    }
    
    return objectIndex;
}
@end
