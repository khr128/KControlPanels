//
//  KControlPanelAdjustedRadiansToDegeeStringTransformen.m
//  KControlPanels
//
//  Created by khr on 11/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelAdjustedRadiansToDegreeStringTransformer.h"
#import <GLKit/GLKit.h>

@implementation KControlPanelAdjustedRadiansToDegreeStringTransformer
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
  double degrees = [self adjustDegrees:GLKMathRadiansToDegrees([angle floatValue])];
  return [NSString stringWithFormat:@"%4.0f", degrees];
}
@end
