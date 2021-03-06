#import "AppDelegate.h"
#import <DStack.h>
#import "GeneratedPluginRegistrant.h"
#import "ThirdViewController.h"
#import "FourViewController.h"

@DStackInject(AppDelegate);

@interface AppDelegate () <DStackDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[DStack sharedInstance] startWithDelegate:self];
    [GeneratedPluginRegistrant registerWithRegistry:[DStack sharedInstance].engine];
    [[DStack sharedInstance] logEnable:YES];

  return YES;
}

+ (FlutterEngine *)dStackForFlutterEngine
{
    FlutterEngine *engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [engine run];
    return engine;
}

- (nonnull UINavigationController *)dStack:(nonnull DStack *)stack navigationControllerForNode:(nonnull DStackNode *)node
{
    return self.currentController.navigationController;
}

- (void)dStack:(nonnull DStack *)stack presentWithNode:(nonnull DStackNode *)node
{
    UINavigationController *navi = [self dStack:stack navigationControllerForNode:node];
    if ([node.route isEqualToString:@"NativePage2"]) {
        [navi.topViewController presentViewController:[[FourViewController alloc] init] animated:YES completion:nil];
    }
}

- (void)dStack:(nonnull DStack *)stack pushWithNode:(nonnull DStackNode *)node
{
    UINavigationController *navi = [self dStack:stack navigationControllerForNode:node];
    if ([node.route isEqualToString:@"NativePage"]) {
        [navi pushViewController:[[ThirdViewController alloc] init] animated:YES];
    }
}

-(UIViewController *)currentController
{
    return [self currentControllerFromController:self.rootController];
}

- (UIViewController *)currentControllerFromController:(UIViewController *)controller
{
    if (!controller) { return nil;}
    UIViewController *presented = controller.presentedViewController;
    if (presented) { return [self currentControllerFromController:presented];}
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)controller;
        if (!navi.viewControllers.count) { return navi;}
        return [self currentControllerFromController:navi.topViewController];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)controller;
        if (!tab.viewControllers.count) { return tab;}
        return [self currentControllerFromController:tab.selectedViewController];
    } else {
        return controller;
    }
}

- (UIViewController *)rootController
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootVC) {
        rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    return rootVC;
}


@end


