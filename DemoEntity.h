//
//  DemoEntity.h
//  KControlPanelsDemo
//
//  Created by khr on 12/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NestedDemoEntity;

@interface DemoEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * demoValue;
@property (nonatomic, retain) NestedDemoEntity *nestedDemoEntity;

@end
