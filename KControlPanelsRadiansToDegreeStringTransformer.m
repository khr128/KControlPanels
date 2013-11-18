//
//  KControlPanelsRadiansToDegreeStringTransformer.m
//  KControlPanels
//
//  Created by khr on 11/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsRadiansToDegreeStringTransformer.h"
#import <GLKit/GLKit.h>

@implementation KControlPanelsRadiansToDegreeStringTransformer

+ (Class)transformedValueClass {
  return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  if (value == nil) {
    return nil;
  }
  NSNumber *angle = (NSNumber *) value;
  return [NSString stringWithFormat:@"%4.0f", GLKMathRadiansToDegrees([angle floatValue])];
}

@end
