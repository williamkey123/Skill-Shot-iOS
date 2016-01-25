//
//  AppDelegate.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit
let baseAPI = "http://list.skill-shot.com/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var launchedShortcutItem: UIApplicationShortcutItem?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let icon = UIApplicationShortcutIcon(type: .Location)
        let localLocaitons = UIApplicationShortcutItem(type: "show_locations", localizedTitle: "Nearby Pinball", localizedSubtitle: nil, icon: icon, userInfo: nil)
        UIApplication.sharedApplication().shortcutItems = [localLocaitons]
        print(launchOptions)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "show_locations" {
            showListByDistance()
        }
        completionHandler(true)
    }
    
    func showListByDistance() {
        guard let rootNavigationController = window!.rootViewController as? UINavigationController else {
            return
        }
        guard let rootMapAndListViewController = rootNavigationController.viewControllers[0] as? MapAndListContainerViewController  else {
            return
        }
        rootNavigationController.popToRootViewControllerAnimated(false)
        rootMapAndListViewController.showListByDistance()
    }
}
