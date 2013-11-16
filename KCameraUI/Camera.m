//
//  Camera.m
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "Camera.h"
#import "Point3d.h"
#import <GLKit/GLKit.h>

NSString * const KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION = @"khrCameraAngleChanged";

@implementation Camera

@dynamic angle;
@dynamic nearZ;
@dynamic farZ;
@dynamic location;
@dynamic lookAt;
@dynamic up;

+ (Camera *)initWith:(NSManagedObjectContext *)moc location:(Point3d *)location lookAt:(Point3d *)lookAtPt {
  Camera *camera = [NSEntityDescription insertNewObjectForEntityForName:@"Camera" inManagedObjectContext:moc];
  camera.location = location;
  camera.lookAt = lookAtPt;
  camera.up = [Point3d initWith:moc x:0 y:1 z:0];
  camera.angle = [NSNumber numberWithFloat:60];
  camera.nearZ = [NSNumber numberWithFloat:0.5];
  camera.farZ = [NSNumber numberWithFloat:10];
  
  [camera addObservers];
  
  return camera;
}

- (void)addObservers {
  [self addObserver:self forKeyPath:@"angle" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"nearZ" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"farZ" options:NSKeyValueObservingOptionNew context:nil];
  
  [self addObserver:self forKeyPath:@"lookAt.x" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"lookAt.y" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"lookAt.z" options:NSKeyValueObservingOptionNew context:nil];
  
  [self addObserver:self forKeyPath:@"location.x" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"location.y" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"location.z" options:NSKeyValueObservingOptionNew context:nil];
  
  [self addObserver:self forKeyPath:@"up.x" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"up.y" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"up.z" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION object:self];
}

- (void)awakeFromFetch {
  [self addObservers];
}

- (float)distanceFromCenter {
  return GLKVector3Length([self direction]);
}

- (GLKVector3)direction {
  Point3d *l = self.location;
  Point3d *c = self.lookAt;
  float dx = [c.x floatValue] - [l.x floatValue];
  float dy = [c.y floatValue] - [l.y floatValue];
  float dz = [c.z floatValue] - [l.z floatValue];
  return GLKVector3Make(dx, dy, dz);
}

@end
