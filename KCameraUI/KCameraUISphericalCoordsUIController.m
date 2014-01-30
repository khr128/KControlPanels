//
//  KCameraUISphericalCoordsUIController.m
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KCameraUISphericalCoordsUIController.h"

@implementation KCameraUISphericalCoordsUIController
@synthesize distanceFromCenter = _distanceFromCenter, maxDistanceFromCenter;
@synthesize theta = _theta, phi = _phi, yaw = _yaw, pitch = _pitch, roll = _roll;

- (void)updateLocationTransform {
  u = GLKVector3Normalize(self.up);
  float rho = sqrtf(u.x*u.x + u.y*u.y);
  
  if (fabsf(rho) > 1.e-4) {
    r = GLKVector3Make(u.y/rho, -u.x/rho, 0);
    t = GLKVector3Make(-u.z*u.x/rho, -u.z*u.y/rho, rho);
  } else {
    r = GLKVector3Make(1, 0, 0);
    t = GLKVector3Make(0, 1, 0);
  }
  
  currentUp = u;
}

- (void)updateSphericalCoordinates {
  GLKVector3 c = self.center;
  GLKVector3 l = self.location;
  
  float R = GLKVector3Distance(c, l);
  currentDirection = GLKVector3Subtract(c, l);
  
  [self willChangeValueForKey:@"theta"];
  _theta = [NSNumber numberWithFloat:acosf(GLKVector3DotProduct(currentDirection, u)/R)];
  [self didChangeValueForKey:@"theta"];
  
  [self willChangeValueForKey:@"phi"];
  _phi = [NSNumber numberWithFloat:atan2f(GLKVector3DotProduct(currentDirection, r), GLKVector3DotProduct(currentDirection, t))];
  [self didChangeValueForKey:@"phi"];
  
  [self willChangeValueForKey:@"distanceFromCenter"];
  _distanceFromCenter = R;
  [self didChangeValueForKey:@"distanceFromCenter"];
}

- (void)updateMaxDistance {
  self.maxDistanceFromCenter = 2*_distanceFromCenter;
}

- (void)updateLocation {
  float th = [self.theta floatValue];
  float ph = [self.phi floatValue];
  float uc = self.distanceFromCenter*cosf(th);
  float tc = self.distanceFromCenter*sinf(th)*cosf(ph);
  float rc = self.distanceFromCenter*sinf(th)*sinf(ph);
  
  GLKVector3 l = GLKVector3Subtract(self.center, GLKVector3MultiplyScalar(u, uc));
  l = GLKVector3Subtract(l, GLKVector3MultiplyScalar(t, tc));
  l = GLKVector3Subtract(l, GLKVector3MultiplyScalar(r, rc));
  
  self.location = l;
  
  currentDirection = GLKVector3Subtract(self.center, l);
}

- (void)setDistanceFromCenter:(float)d {
  _distanceFromCenter = d;
  [self updateLocation];
}

- (void)setTheta:(NSNumber *)th {
  _theta = th;
  [self updateLocation];
}

- (void)setPhi:(NSNumber *)ph {
  _phi = ph;
  [self updateLocation];
}

- (void)setPitch:(NSNumber *)pitch {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetPitch:) object:nil];
  
  GLKVector3 b = GLKVector3Normalize(self.up);
  GLKVector3 a = GLKVector3Normalize(currentDirection);
  float ab = GLKVector3DotProduct(a, b);
  
  GLKVector3 c = GLKVector3Subtract(b, GLKVector3MultiplyScalar(a, ab));
  c = GLKVector3DivideScalar(c, sqrtf(1.0-ab*ab)/self.distanceFromCenter);
  
  float th = [pitch floatValue] - [prevPitch floatValue];
  prevPitch = pitch;
  _pitch = _distanceFromCenter > 1.0 ? [NSNumber numberWithFloat:th/_distanceFromCenter] : [NSNumber numberWithFloat:th];
  th = [_pitch floatValue];
  GLKVector3 newDirection = GLKVector3Subtract(GLKVector3MultiplyScalar(currentDirection, cosf(th)), GLKVector3MultiplyScalar(c, sinf(th)));
  self.center = GLKVector3Add(newDirection, self.location);
  
  [self performSelector:@selector(resetPitch:) withObject:nil afterDelay:0.1];
}

- (void)resetPitch:(id)obj {
  [self updateSphericalCoordinates];
  [self willChangeValueForKey:@"pitch"];
  _pitch = [NSNumber numberWithFloat:0];
  prevPitch = [NSNumber numberWithFloat:0];
  [self didChangeValueForKey:@"pitch"];
}

- (void)setYaw:(NSNumber *)yaw {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetYaw:) object:nil];
  
  GLKVector3 b = GLKVector3Normalize(self.up);
  GLKVector3 a = GLKVector3Normalize(currentDirection);
  float ab = GLKVector3DotProduct(a, b);
  
  GLKVector3 c = GLKVector3Subtract(b, GLKVector3MultiplyScalar(a, ab));
  c = GLKVector3DivideScalar(c, sqrtf(1.0-ab*ab));
  
  GLKVector3 w = GLKVector3CrossProduct(c, currentDirection);
  
  float th = [yaw floatValue] - [prevYaw floatValue];
  prevYaw = yaw;

  _yaw = _distanceFromCenter > 1.0 ? [NSNumber numberWithFloat:th/_distanceFromCenter] : [NSNumber numberWithFloat:th];
  th = [_yaw floatValue];
  GLKVector3 newDirection = GLKVector3Subtract(GLKVector3MultiplyScalar(currentDirection, cosf(th)), GLKVector3MultiplyScalar(w, sinf(th)));
  
  self.center = GLKVector3Add(newDirection, self.location);
  
  [self performSelector:@selector(resetYaw:) withObject:nil afterDelay:0.1];
}

- (void)resetYaw:(id)obj {
  [self updateSphericalCoordinates];
  [self willChangeValueForKey:@"yaw"];
  _yaw = [NSNumber numberWithFloat:0];
  prevYaw = [NSNumber numberWithFloat:0];
  [self didChangeValueForKey:@"yaw"];
}

- (void)resetRoll:(id)obj {
  [self updateLocationTransform];
  [self updateSphericalCoordinates];
  [self willChangeValueForKey:@"roll"];
  _roll = [NSNumber numberWithFloat:0];
  prevRoll = [NSNumber numberWithFloat:0];
  [self didChangeValueForKey:@"roll"];
}

- (void)setRoll:(NSNumber *)roll {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetRoll:) object:nil];
  _roll = roll;
  float th = [roll floatValue] - [prevRoll floatValue];
  prevRoll = roll;
  float costh = cosf(th);
  float sinth = -sinf(th);
  
  GLKVector3 n = GLKVector3Normalize(currentDirection);
  
  float ndr = GLKVector3DotProduct(currentUp, n);
  GLKVector3 ncr = GLKVector3CrossProduct(n, currentUp);
  
  GLKVector3 newUp = GLKVector3MultiplyScalar(currentUp, costh);
  newUp = GLKVector3Add(newUp, GLKVector3MultiplyScalar(n, (1-costh)*ndr));
  newUp = GLKVector3Add(newUp, GLKVector3MultiplyScalar(ncr, sinth));
  
  self.up = newUp;
  
  [self performSelector:@selector(resetRoll:) withObject:nil afterDelay:0.1];
}

@end
