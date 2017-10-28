//
//  completeViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2017/10/27.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import Spring
import EasyTipView
import GoogleMobileAds

class completeViewController: UIViewController ,EasyTipViewDelegate,GADBannerViewDelegate{
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("dismiss")
    }
    

    @IBOutlet weak var compGift: UIWebView!
    
    @IBOutlet weak var compLabel: SpringLabel!
    
    weak var tipView: EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        compLabel.animation = "squeezeDown"
        compLabel.animate()
        
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        
        EasyTipView.globalPreferences = preferences
        self.view.backgroundColor = UIColor(hue:0.75, saturation:0.01, brightness:0.96, alpha:1.00)
        
        self.setToolTip()
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
    }

    @IBAction func tapCompLabel(_ sender: UITapGestureRecognizer) {
        compLabel.animation = "shake"
        compLabel.animate()
        
//        var url:URL = URL(string:"https://ja.wikipedia.org/wiki/%E3%82%A8%E3%82%BE%E3%83%A2%E3%83%A2%E3%83%B3%E3%82%AC")!
        
        var url:URL = URL(string:"https://ja.wikipedia.org/wiki/%E3%83%93%E3%83%AF%E3%83%92%E3%82%AC%E3%82%A4")!
        
        var req = URLRequest(url: url)
        self.compGift!.loadRequest(req)
    }
    
    func setToolTip(){
        
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                print("Completion called!")
            })
        } else {
            let text = "Tap this blue label.You can get rare information in Shiga."
            let tip = EasyTipView(text: text, delegate: self)
            tip.show(forView: compLabel)
            tipView = tip
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
