//
//  KControlPanelsWindowController.m
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KControlPanelsWindowController.h"
#import "NSView+TopmostView.h"
#import <QuartzCore/QuartzCore.h>

@interface KControlPanelsWindowController ()

@end

@implementation KControlPanelsWindowController


-(void)awakeFromNib {
  self.mediator.nestedMediator = self.nestedMediator;
  [self.window setAnimations:[NSDictionary dictionaryWithObjectsAndKeys:self.frameAnimation, @"frame", nil]];
}

-(CABasicAnimation *)frameAnimation {
  CABasicAnimation *a = [CABasicAnimation animation];
  a.delegate = self;
  return a;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (showing == NO) {
    [self.window close];
  }
}

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  self.panelHeight = self.window.frame.size.height;
  self.panelWidth = self.window.frame.size.width;
  [self.window setLevel:NSStatusWindowLevel];
}

- (void)showPanel:(NSButton *)button {
  showing = YES;
  self.button = button;
  NSRect buttonFrame = [button frame];
  NSRect screenFrame = [button khr_convertToScreenViaTopmostView:buttonFrame];
  
  NSRect frame0 = NSMakeRect(screenFrame.origin.x + screenFrame.size.width,
                             screenFrame.origin.y,
                             0,
                             0);
  [self.window setFrame:frame0 display:NO animate:NO];
  [self showWindow:button];
  
  NSRect frame = NSMakeRect(screenFrame.origin.x + screenFrame.size.width,
                            screenFrame.origin.y - self.panelHeight,
                            self.panelWidth,
                            self.panelHeight);
  [[self.window animator] setFrame:frame display:YES];
  [button.window addChildWindow:self.window ordered:NSWindowAbove];
}

- (void)hidePanel{
  showing = NO;
  NSRect buttonFrame = [self.button frame];
  NSRect screenFrame = [self.button khr_convertToScreenViaTopmostView:buttonFrame];
  
  NSRect frame = NSMakeRect(self.window.frame.origin.x,
                            screenFrame.origin.y,
                            0,
                            0);
  [[self.window animator] setFrame:frame display:NO];
}

@end
