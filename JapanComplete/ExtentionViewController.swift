//
//  etentionSettingViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2021/07/27.
//  Copyright © 2021 Eriko Ichinohe. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension UIViewController:GADBannerViewDelegate {
    //画面上部のデザイン設定
    func setUpperBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self.navigationItem.title = NSLocalizedString("setting", comment: "")
        
    }
}
