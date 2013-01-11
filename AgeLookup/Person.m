//
//  Person.m
//  AgeLookup
//
//  Created by Ryan Witko on 1/10/13.
//  Copyright (c) 2013 Witsacco. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name = _name;
@synthesize birthday = _birthday;

- (id)initWithName:(NSString*)name birthday:(NSDate*)birthday {
    if ((self = [super init])) {
        self.name = name;
        self.birthday = birthday;
        
        [self getAge];
    }

    return self;
}

- (NSTimeInterval) computeAge {
    return -[self.birthday timeIntervalSinceNow];
}

- (NSString*)getAge {
    
    // Get the system calendar
    NSCalendar *cal =[NSCalendar currentCalendar];
    NSDate *now = [[NSDate alloc] init];
    
    // Request years, months, weeks
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.birthday toDate:now options:0];
    
    NSLog(@"Age is %dyears %dmonths %dweeks", [comps year], [comps month], [comps week]);
    
    NSString *age = [NSString stringWithFormat:@"Age is %dyears %dmonths %dweeks", [comps year], [comps month], [comps week]];
    
    return age;
}


@end
