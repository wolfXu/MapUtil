//
//  AppDelegate.m
//  gongan
//
//  Created by xuzehan on 2016/12/5.
//  Copyright © 2016年 zhxu. All rights reserved.
//


//736612178f527f417d5a27f430741ca2
#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ViewController.h"
#import "SQLiteManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey=@"a6a8af627eb0ad957e018c118a11948b";
    [self createDirectionFirstly];
    [[SQLiteManager sharedInstance]init];
    [[SQLiteManager sharedInstance]createTable];
    
    ViewController* viewController=[ViewController new];
    UINavigationController* rootViewController=[[UINavigationController alloc]initWithRootViewController:viewController];
    [self.window setRootViewController:rootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


-(void)createDirectionFirstly{
    NSError *error;
    if(![[NSFileManager defaultManager] fileExistsAtPath:ROOTPATH]){
        [[NSFileManager defaultManager] createDirectoryAtPath:ROOTPATH withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
