//
//  AppDelegate.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
// FACEBOOK TETXT SHARE  https://stackoverflow.com/questions/33148544/facebook-share-content-only-shares-url-in-ios-9
//MVVM PATTERN-->  https://www.toptal.com/ios/swift-tutorial-introduction-to-mvvm
//  Apple ID: mhill@mypractice9.com
//  Password: $$Chadney99

// recnx1@gmail.com password $$RecNX9999

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import TwitterKit
import GooglePlaces
import GoogleMaps

import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

var GlobalLoginUSerDetail : UserLoginDetail?
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Thread.sleep(forTimeInterval: 1.0)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().canGoNext
        
      
        //TWTRTwitter.sharedInstance().start(withConsumerKey: "0UOHcGU3I4rEvmSTaEEClGIlT", consumerSecret: "p1WewOudFLAoBHzcd312iqiZ98pR8m9unc2r3FzmagVWw1SaO3")
          TWTRTwitter.sharedInstance().start(withConsumerKey: "iYujYEfuwJ1LQbBnlsMaKEmBF", consumerSecret: "3YEBJrqwTEP2O7Dc6maMqyqaDVSU6XS8328APVrgLcj9WbB5yg") //developer.macrew2 Account
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().isAutoInitEnabled = true
            Messaging.messaging().delegate = self//remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(GlobalConstants.GooglePLACEAPi.googlePlaceAPIKey)
        GMSServices.provideAPIKey(GlobalConstants.GooglePLACEAPi.googlePlaceAPIKey)
        
       let defaults = UserDefaults.standard
        if(defaults.object(forKey: "loginUserDetail") != nil)
        {
            
            let loginDetail = defaults.object(forKey: "loginUserDetail")
             guard let loginUserDetail = try? JSONDecoder().decode(UserLoginDetail.self, from: loginDetail as! Data) else {
             print("Error: Couldn't decode data into Blog")
              return false
             }
            GlobalLoginUSerDetail = loginUserDetail
            print("loginUSSSSSSdetail==\(GlobalLoginUSerDetail)")
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dashBoardNav = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
           let navController = UINavigationController(rootViewController: dashBoardNav)
            navController.navigationBar.isHidden = true
            self.window?.rootViewController = navController
            
        }
    
        AppEventsLogger.activate(application)
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("deviceToken====\(deviceToken)")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken====\(fcmToken)")
        AuthToken.FCMToken = fcmToken
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserUpdateToken"), object: nil)
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("Received the NOTIFICATION")
        print("userINfoNotification=\(userInfo)")
       
       /* let defaults = UserDefaults.standard
        if(defaults.object(forKey: "NotificationCount") != nil)
        {
            let badgeCount = defaults.object(forKey: "NotificationCount") as? String
            defaults.set( String(Int(badgeCount!)! + 1), forKey: "NotificationCount")
            defaults.synchronize()
            application.applicationIconBadgeNumber = Int(badgeCount!)! + 1
        }
        else
        {
            application.applicationIconBadgeNumber = 1
            defaults.set("1", forKey: "NotificationCount")
            defaults.synchronize()
        }*/
        
        let application = UIApplication.shared
        if let dic = userInfo["aps"] as? [String : Any]
        {
            if let badge = dic["badge"] as? String
            {
                application.applicationIconBadgeNumber = Int(badge)!
            }
        }
        
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =
        if state == .active
        {
           // if let visibleViewCtrl = UIApplication.shared.keyWindow?.currentViewController()
           // {
                //if !(visibleViewCtrl is SuggestedRecommendationViewController)
               // {
                    
                    let alertController = UIAlertController(title: "RecNX", message: "New Business Recommendation received for your Survey.", preferredStyle: .alert)
                    let btn1 = UIAlertAction(title: "Go", style: .default) { (action:UIAlertAction) in
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BusinessNotification"), object: nil, userInfo: userInfo)
                    }
                    let btn2 = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                        
                    }
                    alertController.addAction(btn1)
                    alertController.addAction(btn2)
            
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1
                    alertWindow.makeKeyAndVisible()
                    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
            
                //}
           // }
        }
        
        else{  // InActive State
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BusinessNotification"), object: nil, userInfo: userInfo)
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }
  /*  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let stringURL = url.absoluteString
        if stringURL.contains("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
       return  true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
    }*/
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
    }


}

