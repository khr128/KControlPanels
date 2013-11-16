//
//  Point3d.m
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "Point3d.h"
#import "Camera.h"


@implementation Point3d

@dynamic x;
@dynamic y;
@dynamic z;

+ (Point3d *)initWith:(NSManagedObjectContext *)moc x:(float)x y:(float)y z:(float)z {
  Point3d *p = [NSEntityDescription insertNewObjectForEntityForName:@"Point3d" inManagedObjectContext:moc];
  p.x = [NSNumber numberWithFloat:x];
  p.y = [NSNumber numberWithFloat:y];
  p.z = [NSNumber numberWithFloat:z];
  
  return p;
}

@end
