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

class completeViewController: UIViewController ,EasyTipViewDelegate,GADBannerViewDelegate,UIWebViewDelegate{
    
    var displayedName = ""
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    

    @IBOutlet weak var compGift: UIWebView!
    
    @IBOutlet weak var compLabel: SpringLabel!
    
    weak var tipView: EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.isHidden = true
        compLabel.animation = "squeezeDown"
        compLabel.animate()
        
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        
        EasyTipView.globalPreferences = preferences
//        self.view.backgroundColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        
        self.setToolTip()
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
    }

    @IBAction func tapCompLabel(_ sender: UITapGestureRecognizer) {
        compLabel.animation = "wobble"
        compLabel.animate()
        
        self.tipView?.dismiss(withCompletion: {
            print("Completion called!")
        })
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        
        var setURL = "https://\(NSLocalizedString("wikidomain", comment: ""))/wiki/\(NSLocalizedString(displayedName + "Gift", comment: ""))"
        
        var encodedURL = setURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        guard let url = NSURL(string: encodedURL!) else {
            encodedURL = "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC"
            return
        }
        //URLを指定
        let myURL = URL(string: encodedURL!)
        var req = URLRequest(url: myURL!)
        self.compGift!.loadRequest(req)
    }
    
    func setToolTip(){
        
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                print("Completion called!")
            })
        } else {
            let text = String.localizedStringWithFormat(NSLocalizedString("giftTooltip", comment: ""),NSLocalizedString(displayedName, comment: ""))
            
            let tip = EasyTipView(text: text, delegate: self)
            tip.show(forView: compLabel)
            tipView = tip
        }
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("dismiss")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // インジケータを非表示にする
        indicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tipView?.isHidden = true
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
