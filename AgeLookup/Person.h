//
//  Person.h
//  AgeLookup
//
//  Created by Ryan Witko on 1/10/13.
//  Copyright (c) 2013 Witsacco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong) NSString *name;
@property (strong) NSDate *birthday;

- (id)initWithName:(NSString*)name birthday:(NSDate*) birthday;

- (NSString*)getAge;

@end
