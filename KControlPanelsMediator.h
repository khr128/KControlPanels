//
//  KControlPanelsMediator.h
//  KControlPanels
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KControlPanelsMediator <NSObject>

@property (strong) id<KControlPanelsMediator> nestedMediator;

- (void)showPanel:(id)sender nibName:(NSString *)nibName context:(id)context;
- (void)hideCurrentPanel;

@end
