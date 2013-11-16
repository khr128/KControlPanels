//
//  NSView+TopmostView.h
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (TopmostView)
- (NSView *)khr_topmostView;
- (NSRect) khr_convertToScreenViaTopmostView:(NSRect)buttonFrame;
@end
