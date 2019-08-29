//
//  Bridge.m
//  ClassCreator
//
//  Created by Scott Mehus on 8/29/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

#import "Bridge.h"
#import "ClassCreator-Swift.h"

@implementation Bridge

+ (void)getIvar:(Dog *)dog {

    Ivar ivar = class_getInstanceVariable([dog class], "species");
    id value = object_getIvar(dog, ivar);

    NSLog(@"WHHATTT");
    NSLog(@"WHHATTT");
    NSLog(@"WHHATTT");
}

@end
