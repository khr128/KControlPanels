//
//  KControlKeyPanel.m
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlKeyPanel.h"
#import "KControlPanelsWindowController.h"

@implementation KControlKeyPanel

- (BOOL)canBecomeKeyWindow {
  return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
  [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)cancelOperation:(id)sender {
  [controller.mediator hideCurrentPanel];
}

- (void)awakeFromNib {
  [self setOpaque:NO];
  [self setBackgroundColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.75]];
}

@end
