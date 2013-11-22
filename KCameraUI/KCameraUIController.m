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

- (Camera *)fetchOrCreateCamera {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Camera" inManagedObjectContext:self.managedObjectContext]];
  request.includesSubentities = YES;
  NSError *error = nil;
  NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  Camera *camera;
  if (results.count > 0) {
    camera = [results objectAtIndex:0];
  } else {
    camera = [NSEntityDescription insertNewObjectForEntityForName:@"Camera"
                                           inManagedObjectContext:self.managedObjectContext];
    camera.location = [Point3d initWith:self.managedObjectContext x:0 y:-5 z:-22.58];
    camera.lookAt = [Point3d initWith:self.managedObjectContext x:0 y:-5 z:-3];
    camera.up = [Point3d initWith:self.managedObjectContext x:0 y:1 z:0];
    camera.nearZ = [NSNumber numberWithFloat:0.1];
    camera.farZ = [NSNumber numberWithFloat:120.0];
    camera.angle = [NSNumber numberWithFloat:50.0];
    
    [camera addObservers];
  }
  return camera;
}


- (void)updateTransforms {
  [self updateLocationTransform];
  [self updateSphericalCoordinates];
}

- (void)awakeFromNib {
  self.content = [self fetchOrCreateCamera];
  [self updateTransforms];
  [self updateLocation];
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(handleCameraChange:) name:KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION object:nil];
}

- (void)handleCameraChange:(NSNotification *) note {
  [self updateTransforms];
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
