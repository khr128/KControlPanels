//
//  KControlPanelsMediatorBase.h
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KControlPanelsMediator.h"

@class KControlPanelsWindowController;

@interface KControlPanelsMediatorBase : NSObject<KControlPanelsMediator>{
  KControlPanelsWindowController *currentController;
  IBOutlet NSPanel *parentPanel;
}

@property (strong) IBOutlet NSObjectController *objectController;
@end
