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

To start using the camera UI control panel it is necessary to merge frameworks camera model into your apps managed 
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


