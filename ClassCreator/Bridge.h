//
//  Bridge.h
//  ClassCreator
//
//  Created by Scott Mehus on 8/29/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dog;

NS_ASSUME_NONNULL_BEGIN

@interface Bridge : NSObject
+ (void)getIvar:(Dog *)dog;
@end

NS_ASSUME_NONNULL_END
