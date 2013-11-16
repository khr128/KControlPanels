//
//  KControlPanelsWindowController.h
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KControlPanelsMediator.h"

@interface KControlPanelsWindowController : NSWindowController {
  BOOL showing;
}

@property (weak) IBOutlet id<KControlPanelsMediator> mediator;
@property (strong) IBOutlet id<KControlPanelsMediator> nestedMediator;

@property (assign) CGFloat panelHeight;
@property (assign) CGFloat panelWidth;

@property (weak) NSButton *button;
@property (weak) NSObjectController *objectController;

@property (weak) id context;

- (void)showPanel:(NSButton *)button;
- (void)hidePanel;

@end
