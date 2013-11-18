//
//  KControlPanelsBaseAdjustedAngleTransformer.m
//  KControlPanels
//
//  Created by khr on 11/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsBaseAdjustedAngleTransformer.h"

@implementation KControlPanelsBaseAdjustedAngleTransformer

- (double)adjustDegrees:(double)a {
  double adjustedAngle = fmod(a, 360);
  if (adjustedAngle > 180.0) {
    return -180.0 + fmod(adjustedAngle, 180.0);
  } else if (adjustedAngle < -180.0) {
    return 180 + fmod(adjustedAngle, 180.0);
  }
  return adjustedAngle;
}

@end
