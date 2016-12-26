//
//  ViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/25.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //map表示
        viewMap()
        
        helpButton.setFAIcon(icon: FAType.FAQuestionCircleO, forState: .normal)
        
        shareButton.setFAIcon(icon: FAType.FAShareSquareO, forState: .normal)

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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

