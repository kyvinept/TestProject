//
//  NotificationManager.swift
//  TestProject
//
//  Created by Silchenko on 16.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class NotificationManager: NSObject {
    
    static let share = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
    }
    
    func checkNotification(window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            (window.rootViewController as? UITabBarController)?.selectedIndex = 2
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("new push notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("open push notification")
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
