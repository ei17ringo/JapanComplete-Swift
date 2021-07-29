//
//  AppDelegate.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/25.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GADBannerViewDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        
        if UserDefaults.standard.string(forKey: "colorSelection") == nil {
            UserDefaults.standard.setValue("Blue", forKey: "colorSelection")
        }else{
            settingColorName = UserDefaults.standard.string(forKey: "colorSelection") ?? "Blue"
        }
        
        
        switch settingColorName {
        case "Orange":
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = orangeDefColorCode[index].value
            }
        case "Yellow":
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = yellowDefColorCode[index].value
            }
        case "Green":
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = greenDefColorCode[index].value
            }
        case "Pink":
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = pinkDefColorCode[index].value
            }
        default:
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = blueDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = blueDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = blueDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = blueDefColorCode[index].value
            }
        }
        
        return true
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
    }

    // 広告表示
    func viewAdmob(_ selfcotroller:UIViewController){
        // AdMob広告設定
        var bannerView: GADBannerView = GADBannerView()
        bannerView.backgroundColor = UIColor.gray
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        bannerView.frame.origin = CGPoint(x:0, y:selfcotroller.view.frame.size.height - (bannerView.frame.height + (selfcotroller.tabBarController?.tabBar.frame.size.height)!))
        bannerView.frame.size = CGSize(width:selfcotroller.view.frame.width, height:bannerView.frame.height)
        
        //TODO:この部分はメモからコピペして使用すること
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-2022584086765592/3808017463"
        bannerView.delegate = selfcotroller as! GADBannerViewDelegate
        bannerView.rootViewController = selfcotroller
        let gadRequest:GADRequest = GADRequest()
//        // テスト用の広告を表示する時のみ使用（申請時に削除）
        gadRequest.testDevices = ["6c4aa6ef5598dabd487943fc0d3be29328763771"]
        bannerView.load(gadRequest)
        selfcotroller.view.addSubview(bannerView)
    }


}

