//
//  KControlPanelsMediatorBase.m
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsMediatorBase.h"
#import "KControlPanelsWindowController.h"


@implementation KControlPanelsMediatorBase
@synthesize nestedMediator;

- (void)hideCurrentPanel {
  if (currentController) {
    [currentController hidePanel];
    currentController.button.state = NSOffState;
    [self.nestedMediator hideCurrentPanel];
    [parentPanel makeKeyAndOrderFront:self];
    currentController = nil;
  }
}

- (void)showPanel:(id)sender nibName:(NSString *)nibName context:(id)context {
  [self hideCurrentPanel];
  
  NSButton *button = (NSButton *)sender;
  if (button.state == NSOnState) {
    currentController = [[KControlPanelsWindowController alloc] initWithWindowNibName:nibName];
    currentController.button = button;
    currentController.objectController = _objectController;
    currentController.context = context;
    currentController.mediator = self;
    [currentController showPanel:button];
  }
}

@end
