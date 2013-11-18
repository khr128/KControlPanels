//
//  KControlPanelsRadiansToDegreesTransformer.m
//  KControlPanels
//
//  Created by khr on 11/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsRadiansToDegreesTransformer.h"
#import <GLKit/GLKit.h>

@implementation KControlPanelsRadiansToDegreesTransformer

+ (Class)transformedValueClass {
  return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)transformedValue:(id)value {
  if (value == nil) {
    return nil;
  }
  NSNumber *angle = (NSNumber *) value;
  return [NSNumber numberWithFloat:GLKMathRadiansToDegrees([angle floatValue])];
}

- (id)reverseTransformedValue:(id)value {
  NSNumber *angle = (NSNumber *)value;
  return [NSNumber numberWithFloat:GLKMathDegreesToRadians([angle floatValue])];
}

@end
