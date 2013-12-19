# KControlPanels

## How to add your own control panel

### 1. Add a mediator class

Mediator is a controller that provides actions for your control panel disclosure triangles.

*KDemoControlPanelMediator.h*

    #import <KControlPanels/KControlPanelsMediatorBase.h>
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

### <a name='your_panel'></a> 2. Add your control panel XIB

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

Add new empty XIB file YourControlPanel.xib and set its file owner class to KControlPanelsWindowController.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ControlPanelControlle.png">

Add NSPanel to it. Set class of the panel to KControlKeyPanel. Remove titlebar and make it a regular panel.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelClass.png">
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelNoBar.png">
!!! IMPORTANT !!! Don't forget to connect the panels window and controller to the XIB's file owner.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/PanelWindow.png">

If you build your application now, you should be able to click on the disclosure triangle for Your Control Panel and
see an empty panel animating into view. Clicking the disclosure triangle again (or pressing Esc while the panel is in
focus) should close your panel. You can add controls and hook up actions to your panel now.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/EmptyPanel.png">

### 3. Setting camera UI control panel

Camera UI control panel provides controls for a generic 3D camera in OpenGL applications. You can set camera's look-at 
point and distance , elevation, and azimuth with respect to this point. You also can adjust camera's yaw and pitch angles
and its rotation around the direction of view. There are controls for camera's field of view angle and culling planes too.

To start using the camera UI control panel it is necessary to merge frameworks camera model into your app's managed
object model by
overriding -(id)managedObjectModel() method in your document implementation class.

*KDemoDocument.m*

    - (id)managedObjectModel {
      NSBundle *mainBundle = [NSBundle mainBundle];
      NSString *demoModelPath =
        [mainBundle pathForResource:@"KDemoDocument" ofType:@"momd"];
      NSURL *demoModelUrl = [NSURL fileURLWithPath:demoModelPath];
      NSManagedObjectModel *mainModel =
        [[NSManagedObjectModel alloc] initWithContentsOfURL:demoModelUrl];
      
      NSBundle *kControlPanelBundle =
        [NSBundle bundleWithIdentifier:@"com.khr.KControlPanels"];
      NSString *path = 
        [kControlPanelBundle pathForResource:@"KCameraUI" ofType:@"momd"];
      NSURL *url = [NSURL fileURLWithPath:path];
      NSManagedObjectModel *model =
        [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
      return
        [NSManagedObjectModel modelByMergingModels:
          [NSArray arrayWithObjects: mainModel, model, nil]];
    }

The only variable part in this otherwise boilerplate code is 
`[mainBundle pathForResource:@"KDemoDocument" ofType:@"momd"]`. The `pathForResource` should be the name of your
`xcdatamodeld` file.

Once the camera model is merged, you can register to receive notifications when camera parameters change and use the
camera model to get updated parameters. For example, add camera model instance variable in the interface file

    @class Camera;
    @interface Some3DView {
      Camera *camera;
    }
    @end

and use it in the implementation file

    #import <KControlPanels/Camera.h>
    #import <KControlPanels/Point3d.h>

    @implementation Some3DView

    ...

    - (void)addObservers
    {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self selector:@selector(handleCameraChange:)
        name:KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION object:nil];
    }

    - (void)handleCameraChange:(NSNotification *) note {
      camera = note.object;
      [self defineProjection];
      [scene computeLightsEyeCoordinates];
      [self setNeedsDisplay:YES];
    }

    - (void)defineCamera {
      Point3d *cameraLocation = (Point3d *)camera.location;
      GLKVector3 eye = GLKVector3Make([cameraLocation.x floatValue],
                                      [cameraLocation.y floatValue],
                                      [cameraLocation.z floatValue]);
      
      Point3d *cameraLookAt = (Point3d *)camera.lookAt;
      GLKVector3 center = GLKVector3Make([cameraLookAt.x floatValue],
                                         [cameraLookAt.y floatValue],
                                         [cameraLookAt.z floatValue]);
      Point3d *cameraUp = (Point3d *)camera.up;
      GLKVector3 up = GLKVector3Make([cameraUp.x floatValue],
                                     [cameraUp.y floatValue],
                                     [cameraUp.z floatValue]);
      
      [scene.camera setViewEye:eye center:center up:up];
    }

    - (void)defineProjection {
      [self defineCamera];
      
      [scene.camera setProjectionFov:GLKMathDegreesToRadians(
                                                   [camera.angle floatValue])
                              aspect:(GLfloat)viewWidth / (GLfloat)viewHeight
                               nearZ:[camera.nearZ floatValue]
                                farZ:[camera.farZ floatValue]
       ];
    }

    ...

    @end

### 4. Use Core Data with your panels

Connect your main UI object controller to your document

*KDemoDocument.h*

    #import <Cocoa/Cocoa.h>
    @interface KDemoDocument : NSPersistentDocument {
      IBOutlet NSObjectController *objectController;
    }
    @end
Make sure that this `objectController` is connected to the Object Controller object in your main UI XIB.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ObjectControllerHookup.png">

Fetch or create an entity when awaking from NIB. I assume that a DemoEntity has been added to your `xcdatamodeld` file.

*KDemoDocument.m"*

    (DemoEntity *)fetchOrCreateDemoEntity {
      NSFetchRequest *request = [[NSFetchRequest alloc] init];
      [request setEntity:[NSEntityDescription entityForName:@"DemoEntity" inManagedObjectContext:self.managedObjectContext]];
      request.includesSubentities = YES;
      NSError *error = nil;
      NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
      
      DemoEntity *demoEntity;
      if (results.count > 0) {
        demoEntity = [results objectAtIndex:0];
      } else {
        demoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"DemoEntity"
                                               inManagedObjectContext:self.managedObjectContext];
        demoEntity.demoValue = [NSNumber numberWithDouble:12.345];
      }
      return demoEntity;
    }

    - (void)windowControllerDidLoadNib:(NSWindowController *)aController
      {
        [super windowControllerDidLoadNib:aController];
        objectController.content = [self fetchOrCreateDemoEntity];
      }

Add controls to your control panel XIB, and bind values of the slider and the text field to 
`objectController.content.demoValue`.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ControlDataBinding.png">

### 5. Adding nested control panels

Create a new Mediator class that will be controlling your nested panels.

*KDemoNestedControlPanelMediator.h*

    #import <KControlPanels/KControlPanelsMediatorBase.h>
    @interface KDemoNestedControlPanelMediator : KControlPanelsMediatorBase
    - (IBAction)showYourFirstNestedControlPanel:(id)sender;
    - (IBAction)showYourSecondNestedControlPanel:(id)sender;
    @end

*KDemoNestedControlPanelMediator.m*

    #import "KDemoNestedControlPanelMediator.h"
    @implementation KDemoNestedControlPanelMediator
    - (IBAction)showYourFirstNestedControlPanel:(id)sender {
      [self showPanel:sender nibName:@"YourFirstNestedControlPanel" context:nil];
    }

    - (IBAction)showYourSecondNestedControlPanel:(id)sender {
      [self showPanel:sender nibName:@"YourSecondNestedControlPanel" context:nil];
    }
    @end


Assuming that you added your control panel as described above (YourControlPanel.xib), add
Object to YourControPanel.xib and set its class to `KDemoNestedControlPanelMediator`
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/NestedMediator.png">
and attach your panel as a `parentPanel` of this new mediator.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ParentPanel.png">
Also attach File Owner outlet `nestedMediator` to the XIB objet representing the `KDemoNestedControlPanelMediator`
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/NestedMediatorHookup.png">

Now add YourFirstNestedControlPanel.xib and YourSecondNestedControlPanel.xib and set up empty panels as described 
[above](#your_panel). When you build and run your app, you should be able to open nested panels.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/OpenNestedPanel.png">
Notice that closing outer panel will close all open nested panels automagically.

### 6. Use context with nested panels

Nested panels usually make sense in the context of some entity described by the parent panel. To demonstrate nested panels
with context, let us add NestedDemoEntity to our data model.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/NestedDemoEntity.png">
On this NestedDemoEntity we define one attribute `nestedDemoValue` of type `Double`.

We also add an Object Controller object to YourControlPanel.xib, and bind its `content` to the
File Owner's `objectController.content.nestedDemoEntity`.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/BindNestedDemoEntity.png">
Finally we need to attach this new Object Controller object to the Demo Nested Control Panel Mediator's `objectController`
outlet.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/AttachNestedObjectController.png">

Pass NestedDemoEntity as a `context` argument of the `showPanel` method in KDemoNestedControlPanelMediator.m

    @implementation KDemoNestedControlPanelMediator
    - (IBAction)showYourFirstNestedControlPanel:(id)sender {
      NestedDemoEntity *nestedEntity = self.objectController.content;
      [self showPanel:sender nibName:@"YourFirstNestedControlPanel" context:nestedEntity];
    }

Add some controls to the panel in the YourFirstNestedControlPanel.xib, and bind slider's and text field's values to
`nestedDemoValue` via `context`
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/BindNestedDemoValue.png">
Insert NestedDemoEntity into DemoEntity when creating entities

    demoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"DemoEntity"
                                               inManagedObjectContext:self.managedObjectContext];
    demoEntity.demoValue = [NSNumber numberWithDouble:12.345];
    demoEntity.nestedDemoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"NestedDemoEntity" inManagedObjectContext:self.managedObjectContext];
    demoEntity.nestedDemoEntity.nestedDemoValue = [NSNumber numberWithDouble:54.321];
and build and run the application. You should see the nested demo value in the first nested control panel.
<img src="https://raw.github.com/khr128/KControlPanels/gh-pages/README.assets/ShowNestedControlPanelWithContext.png">

