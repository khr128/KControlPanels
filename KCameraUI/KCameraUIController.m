//
//  KCameraUIController.m
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KCameraUIController.h"
#import "Point3d.h"
#import "Camera.h"

@implementation KCameraUIController

- (void)awakeFromNib {
  self.content = [Camera initWith:self.managedObjectContext
                         location:[Point3d initWith:self.managedObjectContext x:0 y:2 z:-1]
                           lookAt:[Point3d initWith:self.managedObjectContext x:0 y:0 z:0]];

  [self updateLocationTransform];
  [self updateSphericalCoordinates];
  [self updateLocation];
}

- (GLKVector3)location {
  Camera *camera = self.content;
  Point3d *location = camera.location;
  return GLKVector3Make([location.x floatValue], [location.y floatValue], [location.z floatValue]);
}

- (void)setLocation:(GLKVector3)l {
  Camera *camera = self.content;
  Point3d *location = camera.location;
  location.x = [NSNumber numberWithFloat:l.x];
  location.y = [NSNumber numberWithFloat:l.y];
  location.z = [NSNumber numberWithFloat:l.z];
}

- (GLKVector3)center {
  Camera *camera = self.content;
  Point3d *center = camera.lookAt;
  return GLKVector3Make([center.x floatValue], [center.y floatValue], [center.z floatValue]);
}

- (void)setCenter:(GLKVector3)c {
  Camera *camera = self.content;
  Point3d *center = camera.lookAt;
  
  center.x = [NSNumber numberWithFloat:c.x];
  center.y = [NSNumber numberWithFloat:c.y];
  center.z = [NSNumber numberWithFloat:c.z];
}

- (GLKVector3)up {
  Camera *camera = self.content;
  Point3d *up = camera.up;
  return GLKVector3Make([up.x floatValue], [up.y floatValue], [up.z floatValue]);
}

- (void)setUp:(GLKVector3)newUp {
  Camera *camera = self.content;
  Point3d *up = camera.up;
  
  up.x = [NSNumber numberWithFloat:newUp.x];
  up.y = [NSNumber numberWithFloat:newUp.y];
  up.z = [NSNumber numberWithFloat:newUp.z];
}

- (void)controlTextDidEndEditing:(NSNotification *)note {
  NSTextField *textField = [note object];
  if (textField == locationXTextField || textField == locationYTextField || textField == locationZTextField) {
    [self updateSphericalCoordinates];
  }
}

@end
