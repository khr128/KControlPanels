//
//  KControlKeyPanel.h
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KControlPanelsWindowController;

@interface KControlKeyPanel : NSPanel {
  IBOutlet KControlPanelsWindowController *controller;
}

@end
