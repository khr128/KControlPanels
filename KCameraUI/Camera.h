//
//  Camera.h
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION;

@class Point3d;

@interface Camera : NSManagedObject

@property (nonatomic, retain) NSNumber * angle;
@property (nonatomic, retain) NSNumber * nearZ;
@property (nonatomic, retain) NSNumber * farZ;
@property (nonatomic, retain) Point3d *location;
@property (nonatomic, retain) Point3d *lookAt;
@property (nonatomic, retain) Point3d *up;

+ (Camera *)initWith:(NSManagedObjectContext *)moc location:(Point3d *)location lookAt:(Point3d *)lookAtPt;
- (void)addObservers;
@end
