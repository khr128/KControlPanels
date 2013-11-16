//
//  KCameraUISphericalCoordsUIController.h
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KCameraUISphericalTransforms.h"

@interface KCameraUISphericalCoordsUIController : NSObjectController <KCameraUISphericalTransforms> {
  GLKVector3 u, r, t;
  GLKVector3 currentDirection;
  GLKVector3 currentUp;
}
@end
