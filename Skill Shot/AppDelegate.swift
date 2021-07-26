//
//  AppDelegate.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import UIKit
let baseAPI = "http://list.skill-shot.com/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let globalTintColor = UIColor(red: 247/255.0, green: 174/255.0, blue: 0.0, alpha: 1.0)

    var window: UIWindow?
    
    var launchedShortcutItem: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let icon = UIApplicationShortcutIcon(type: .location)
        let localLocaitons = UIApplicationShortcutItem(type: "show_locations", localizedTitle: "Nearby Pinball", localizedSubtitle: nil, icon: icon, userInfo: nil)
        UIApplication.shared.shortcutItems = [localLocaitons]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let validShortcut = self.launchedShortcutItem {
            if validShortcut.type == "show_locations" {
                showListByDistance()
            }
            self.launchedShortcutItem = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        launchedShortcutItem = shortcutItem
        completionHandler(true)
    }
    
    func showListByDistance() {
        guard let validWindow = window else {
            return
        }
        guard let rootNavigationController = validWindow.rootViewController as? UINavigationController else {
            return
        }
        guard let rootMapAndListViewController = rootNavigationController.viewControllers[0] as? MapAndListContainerViewController  else {
            return
        }
        rootNavigationController.popToRootViewController(animated: false)
        rootMapAndListViewController.initialContainerView = LocationViewControllerType.list
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ApplicationRelaunched"), object: nil)
    }
}
