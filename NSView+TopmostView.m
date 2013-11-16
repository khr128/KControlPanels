//
//  NSView+TopmostView.m
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "NSView+TopmostView.h"

@implementation NSView (TopmostView)
- (NSView *) khr_topmostView {
  NSView *v = [self superview];
  if (v) {
    return [v khr_topmostView];
  }
  return self;
}

- (NSRect) khr_convertToScreenViaTopmostView:(NSRect)buttonFrame {
  NSView *topmostView = [self khr_topmostView];
  NSRect topmostViewFrame = [self.superview convertRect:buttonFrame toView:topmostView];
  NSRect screenFrame = [topmostView.window convertRectToScreen:topmostViewFrame];
  return screenFrame;
}
@end
