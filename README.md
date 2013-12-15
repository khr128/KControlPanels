# KControlPanels

## How to add your own control panel

### 1. Add a mediator class

Mediator is a controller that provides actions for your control panel disclosure triangles.

*KDemoControlPanelMediator.h*

    #import <KControlPanels/KControlPanelsMediatorBase.h
    @interface KDemoControlPanelMediator : KControlPanelsMediatorBase
    - (IBAction)showYourControlPanel:(id)sender;
    - (IBAction)showCameraControlPanel:(id)sender;
    @end

*KDemoControlPanelMediator.m*

    #import "KDemoControlPanelMediator.h"
    @implementation KDemoControlPanelMediator
    - (IBAction)showYourControlPanel:(id)sender {
      [self showPanel:sender nibName:@"YourControlPanel" context:nil];
    }

    - (IBAction)showCameraControlPanel:(id)sender {
      [self showPanel:sender nibName:@"KCameraUIControlPanel" context:nil];
    }
    @end

KCameraUIControlPanel.xib is provided by the KControlPanels.framework, but you have to create your own YourControlPanel.xib.

### 2. Add your control panel XIB

Add labels and disclosure triangles to your main XIB.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ControlPanelUI.png">
