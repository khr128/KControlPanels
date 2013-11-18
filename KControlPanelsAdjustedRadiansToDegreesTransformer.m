//
//  KControlPanelsAdjustedRadiansToDegreesTransformer.m
//  KControlPanels
//
//  Created by khr on 11/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsAdjustedRadiansToDegreesTransformer.h"
#import <GLKit/GLKit.h>

@implementation KControlPanelsAdjustedRadiansToDegreesTransformer
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
  double degrees = [self adjustDegrees:GLKMathRadiansToDegrees([angle floatValue])];
  return [NSNumber numberWithFloat:degrees];
}

- (id)reverseTransformedValue:(id)value {
  NSNumber *angle = (NSNumber *)value;
  return [NSNumber numberWithFloat:GLKMathDegreesToRadians([angle floatValue])];
}
@end
