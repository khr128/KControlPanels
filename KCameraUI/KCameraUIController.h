//
//  KCameraUIController.h
//  KCameraUI
//
//  Created by khr on 11/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KCameraUISphericalCoordsUIController.h"

@interface KCameraUIController : KCameraUISphericalCoordsUIController {
  IBOutlet NSTextField *locationXTextField;
  IBOutlet NSTextField *locationYTextField;
  IBOutlet NSTextField *locationZTextField;
}

@end
