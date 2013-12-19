//
//  KDemoControlPanelMediator.m
//  KControlPanelsDemo
//
//  Created by khr on 12/14/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KDemoControlPanelMediator.h"

@implementation KDemoControlPanelMediator
- (IBAction)showYourControlPanel:(id)sender {
  [self showPanel:sender nibName:@"YourControlPanel" context:nil];
}

- (IBAction)showCameraControlPanel:(id)sender {
  [self showPanel:sender nibName:@"KCameraUIControlPanel" context:nil];
}
@end
