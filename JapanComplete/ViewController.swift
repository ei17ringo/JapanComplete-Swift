//
//  ViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/25.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import GoogleMobileAds

class ViewController: UIViewController,UIWebViewDelegate,GADBannerViewDelegate {

    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //広告表示
        viewAdmob()
        
        //画面上部のデザイン設定
        setUpperBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //map表示
        viewMap()
    }

    // map表示
    func viewMap(){
        //WebViewいっぱいにmap.htmlを表示させる
        mapWebView.scalesPageToFit = true
        
        //event.jsをWebViewにセット
        var filePathJS = Bundle.main.path(forResource: "event", ofType: "js")
        var script = try! String(contentsOfFile: filePathJS!, encoding:String.Encoding.utf8)
        mapWebView.stringByEvaluatingJavaScript(from: script)
        
        //map.htmlをWebViewにセット
        var filePath = Bundle.main.path(forResource: "map", ofType: "html")
        var request = URLRequest(url: URL(fileURLWithPath: filePath!))
        mapWebView.loadRequest(request)
        
        mapWebView.delegate = self
    }
    
    //画面上部のデザイン設定
    func setUpperBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = NSLocalizedString("mapTitle", comment: "")
        
        helpButton.setFAIcon(icon: FAType.FAQuestionCircleO, forState: .normal)
        shareButton.setFAIcon(icon: FAType.FAShareSquareO, forState: .normal)
    }
    
    // 広告表示
    func viewAdmob(){
        // AdMob広告設定
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        bannerView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width:self.view.frame.width, height:bannerView.frame.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        gadRequest.testDevices = ["12345678abcdefgh"]
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

