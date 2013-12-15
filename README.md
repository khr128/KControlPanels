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

Add object to your main XIB and set its class to KDemoControlPanelMediator.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/MediatorObject.png">

Assuming that your project is using CoreData and your main XIB file owner is a document, add Object Controller
object to your XIB and bind its managed object context to your document.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ManagedObjectContextBinding.png">

Connect disclosure triangle actions to your mediator and point mediator object controller to the added Object Controller
object.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/MediatorConnections.png">

Add new empty XIB file YourControlPanel.xib and add NSPanel to it. Set class of the panel to KControlKeyPanel. 
Remove titlebar and make it a regular panel.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelClass.png">
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelNoBar.png">
!!! IMPORTANT !!! Don't forget to connect the panels window and controller to the XIB's file owner.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelWindow.png">

