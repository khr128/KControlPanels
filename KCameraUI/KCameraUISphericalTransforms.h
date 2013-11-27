//
//  KCameraUISphericalTransforms.h
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@protocol KCameraUISphericalTransforms <NSObject>

@property (nonatomic, retain) NSNumber *theta;
@property (nonatomic, retain) NSNumber *phi;
@property (nonatomic, assign) float distanceFromCenter;
@property (assign) float maxDistanceFromCenter;
@property (nonatomic, retain) NSNumber *yaw;
@property (nonatomic, retain) NSNumber *pitch;
@property (nonatomic, retain) NSNumber *roll;

- (void)updateSphericalCoordinates;
- (void)updateLocationTransform;
- (void)updateLocation;
- (void)updateMaxDistance;

@optional

@property (nonatomic, readwrite) GLKVector3 location;
@property (nonatomic, readwrite) GLKVector3 center;
@property (nonatomic, readwrite) GLKVector3 up;

@end
