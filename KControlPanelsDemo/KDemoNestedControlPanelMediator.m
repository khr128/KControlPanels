//
//  KDemoNestedControlPanelMediator.m
//  KControlPanelsDemo
//
//  Created by khr on 12/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KDemoNestedControlPanelMediator.h"
#import "NestedDemoEntity.h"

@implementation KDemoNestedControlPanelMediator
- (IBAction)showYourFirstNestedControlPanel:(id)sender {
  NestedDemoEntity *nestedEntity = self.objectController.content;
  [self showPanel:sender nibName:@"YourFirstNestedControlPanel" context:nestedEntity];
}

- (IBAction)showYourSecondNestedControlPanel:(id)sender {
  [self showPanel:sender nibName:@"YourSecondNestedControlPanel" context:nil];
}
@end
