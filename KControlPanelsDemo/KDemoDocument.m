//
//  KDemoDocument.m
//  KControlPanelsDemo
//
//  Created by khr on 12/14/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KDemoDocument.h"
#import "DemoEntity.h"
#import "NestedDemoEntity.h"

@implementation KDemoDocument

- (id)init
{
    self = [super init];
    if (self) {
    // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
  // Override returning the nib file name of the document
  // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
  return @"KDemoDocument";
}

-(DemoEntity *)fetchOrCreateDemoEntity {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"DemoEntity" inManagedObjectContext:self.managedObjectContext]];
  request.includesSubentities = YES;
  NSError *error = nil;
  NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  DemoEntity *demoEntity;
  if (results.count > 0) {
    demoEntity = [results objectAtIndex:0];
  } else {
    demoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"DemoEntity"
                                               inManagedObjectContext:self.managedObjectContext];
    demoEntity.demoValue = [NSNumber numberWithDouble:12.345];
    demoEntity.nestedDemoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"NestedDemoEntity" inManagedObjectContext:self.managedObjectContext];
    demoEntity.nestedDemoEntity.nestedDemoValue = [NSNumber numberWithDouble:54.321];
  }
  return demoEntity;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
  [super windowControllerDidLoadNib:aController];
  objectController.content = [self fetchOrCreateDemoEntity];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (id)managedObjectModel {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *mechModelPath = [mainBundle pathForResource:@"KDemoDocument" ofType:@"momd"];
  NSURL *mechModelUrl = [NSURL fileURLWithPath:mechModelPath];
  NSManagedObjectModel *mainModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:mechModelUrl];
  
  NSBundle *kControlPanelBundle = [NSBundle bundleWithIdentifier:@"com.khr.KControlPanels"];
  NSString *path = [kControlPanelBundle pathForResource:@"KCameraUI" ofType:@"momd"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
  return [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects: mainModel, model, nil]];
}

@end
