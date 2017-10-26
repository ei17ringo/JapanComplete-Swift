//
//  wikiViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2017/08/28.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit

class wikiViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var wikiPage: UIWebView!
    var displayedName = ""
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // インジケータを表示する
        indicator.startAnimating()
        //日本語の場合
//        var setURL = "https://ja.wikipedia.org/wiki/\(displayedName)"
        
        var setURL = "https://en.wikipedia.org/wiki/\(displayedName)_Prefecture"
        
        if (displayedName == "Tokyo") || (displayedName == "Kyoto") || (displayedName == "Osaka") || (displayedName == "Hokkaido") {
            setURL = "https://en.wikipedia.org/wiki/\(displayedName)"
        }
        
        var encodedURL = setURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        guard let url = NSURL(string: encodedURL!) else {
            encodedURL = "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC"
            return
        }
        
        
        //URLを指定
        let myURL = URL(string: encodedURL!)
        
        //URLリクエストを作って
        let myURLReq = URLRequest(url: myURL!)
        
        //WebViewに表示
        wikiPage.loadRequest(myURLReq)

        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // インジケータを非表示にする
        indicator.stopAnimating()
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
