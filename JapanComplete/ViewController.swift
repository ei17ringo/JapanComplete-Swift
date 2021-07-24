//
//  ViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/25.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import FontAwesome_swift
import GoogleMobileAds
import Accounts


class ViewController: UIViewController,UIWebViewDelegate,GADBannerViewDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var percentageText: UILabel!
    
    var colorArea:NSMutableDictionary = NSMutableDictionary()
    var historyData:NSMutableDictionary = NSMutableDictionary()
    
    var color = [["name":"low","desc":NSLocalizedString("low", comment: "")],["name":"middle","desc":NSLocalizedString("middle", comment: "")],["name":"high","desc":NSLocalizedString("high", comment: "")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面上部のデザイン設定
        setUpperBar()
        
        //初期表示はUserDefaultに値を作成
        //エリアの記録情報を取得
        getAreaLog()
        
        print(colorArea)
        
        var myDefault = UserDefaults.standard
        if (myDefault.object(forKey: "colorDef") != nil){
            color = myDefault.object(forKey:"colorDef") as! [[String : String]]
        }
        //map表示
        viewMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
        
        var myDefault = UserDefaults.standard
        if (myDefault.object(forKey: "colorDef") != nil){
            color = myDefault.object(forKey:"colorDef") as! [[String : String]]
        }
        
        for eachcolor in color{
            
            
            var cmd:String = "setdef('\(eachcolor["name"]!)_text','\(eachcolor["desc"]!)');"
            
            mapWebView.stringByEvaluatingJavaScript(from: cmd)
        }

    }

    // map表示
    func viewMap(){
        //WebViewいっぱいにmap.htmlを表示させる
        mapWebView.scalesPageToFit = true
        mapWebView.contentMode = .scaleAspectFit
        
        mapWebView.center = self.view.center
        
        print(self.view.frame.size.width)
        
        if (self.view.frame.size.width > 414){
            //iPhone 6s Plus以上
            var mapWidth = self.view.frame.size.width * 0.6
            mapWebView.frame.size.width = mapWidth
            mapWebView.frame.origin.x = (self.view.frame.size.width - mapWidth) / 2
            mapWebView.frame.origin.y =  30
            mapWebView.frame.size.height = mapWidth + 40
        }else{
            mapWebView.frame.size.width = self.view.frame.size.width
            mapWebView.frame.origin.x = 0
            mapWebView.frame.origin.y =  30
            mapWebView.frame.size.height = self.view.frame.size.width + 40
            mapWebView.contentMode = .scaleAspectFit
            
        }
        percentageText.frame.size.width = mapWebView.frame.size.width
        percentageText.frame.origin.x = mapWebView.frame.origin.x
        
        
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
    
    //シェアボタンタップ時
    @IBAction func tapShareBtn(_ sender: UIButton) {
        
        //履歴情報として保存
        var now = Date()

        //ファイル名用
        var dfForFile = DateFormatter()
        dfForFile.dateFormat = "yyyyMMdd_HHmmss"
        var strForFile = dfForFile.string(from: now)
        
        //データ保存用キー
        var dfKey = DateFormatter()
        dfKey.dateFormat = "yyyy/MM/dd_HH:mm:ss"
        var strNowKey = dfKey.string(from: now)

        var fileName = "\(strForFile).png"
        
        //現在時刻をキーに指定し、Historyデータに保存
        var retDictionary:NSMutableDictionary = historyData.mutableCopy() as! NSMutableDictionary
        
        retDictionary.setObject(fileName, forKey: strNowKey as NSCopying)
        
        historyData = retDictionary
        
        var historyDefault = UserDefaults.standard
        
        historyDefault.set(historyData, forKey: "historyData")
        historyDefault.synchronize()
        
        
        //共有する項目の設定
        //テキスト
        let shareText = percentageText.text
        //URL
        //let shareWebsite:URL = URL(string: "https://itunes.apple.com/us/app/japancomplete/id842436484?mt=8")!
            
        //地図画像
        let shareImage = screenshotWithView()
        
        //画像をディレクトリに保存
        // DocumentディレクトリのfileURLを取得
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let targetImageFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)
            
            print("書き込むファイルのパス: \(targetImageFilePath)")
            
            do {
                var imageData = shareImage.pngData()
                try imageData?.write(to: targetImageFilePath)
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
        }
        
        
        //共有する項目を配列に指定
        //let activityItems = [shareImage,shareText,shareWebsite] as [Any]
        let activityItems = [shareImage,shareText] as [Any]
        
        
        //ActivityViewの作成、初期化
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities:nil)
        
        self.present(activityVC, animated:true, completion: nil)

    }
    
    
    
    // 地図スクリーンショット作成
    func screenshotWithView()->UIImage{
        let rect = baseView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        baseView.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    // 画面上部のデザイン設定
    func setUpperBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = NSLocalizedString("mapTitle", comment: "")
        
//        helpButton.setFAIcon(icon: FAType.FAQuestionCircleO, forState: .normal)
//        shareButton.setFAIcon(icon: FAType.FAShareSquareO, forState: .normal)
        
        helpButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .regular)
        helpButton.setTitle(String.fontAwesomeIcon(name: .questionCircle), for: .normal)
        
//        helpButton.setTitle(String.fontAwesomeIcon(name: .questionCircle), for: .normal)
        shareButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .regular)
        shareButton.setTitle(String.fontAwesomeIcon(name: .shareSquare), for: .normal)
    }
        
    // エリアの記録情報を取得
    func getAreaLog(){
        var areaDefault = UserDefaults.standard
        let colorAreaTmp = areaDefault.object(forKey: "colorArea") as? NSDictionary
        if colorAreaTmp != nil {
            colorArea = colorAreaTmp!.mutableCopy() as! NSMutableDictionary
            print("success to get data from UserDefault")
            calcPercentage()
            
        }else{
            colorArea = setAreaDictionary("-1",areaID: "")
        }
        
        print(colorArea)
        
    }
    
    // Webview関連
    func webViewDidFinishLoad(_ webView: UIWebView) {

        if colorArea.count == 0 {
            var areaDefault = UserDefaults.standard
            var tmp:NSMutableDictionary! = areaDefault.dictionary(forKey: "colorArea") as! NSMutableDictionary?
            colorArea = tmp

        }

        var keys:NSArray = colorArea.allKeys as NSArray

        for i in 0 ..< (keys.count) {
            var key:String = keys[i] as! String
            var value:String = String(describing: colorArea.object(forKey: key)!)

            var command:String = "setcolor('\(value)','\(key)');"

            mapWebView.stringByEvaluatingJavaScript(from: command)
        }

        for eachcolor in color{


            var cmd:String = "setdef('\(eachcolor["name"]!)_text','\(eachcolor["desc"]!)');"

            mapWebView.stringByEvaluatingJavaScript(from: cmd)
        }


    }
    
    //javascriptから値を受け取りUserDefaultに設定する
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        print(request.url)
        
        var geturl:URL = request.url!
        
        if geturl.scheme == "webview" {
            
            let comp: NSURLComponents? = NSURLComponents(string: geturl.absoluteString)
            
            var colorCode = "0"
            var areaID = ""
            for i in 0 ..< (comp?.queryItems?.count)! {
                let item = (comp?.queryItems?[i])! as URLQueryItem
                print("name=\(item.name), value=\(item.value)")
                
                switch item.name {
                case "color":
                    colorCode = item.value!
                    break
                case "id":
                    areaID = item.value!
                    break
                default:
                    print("unknownname=\(item.name), value=\(item.value)")
                }
            }

            setAreaDictionary(colorCode,areaID: areaID)
            
        }
        
        return true
    }
    
    //Area色ディクショナリー設定
    func setAreaDictionary(_ colorCode:String, areaID:String) -> NSMutableDictionary{
        
        var checkColorCode = colorCode
        let areaDefault = UserDefaults.standard

        //初期設定（全て白）
        if checkColorCode == "-1" {
            
            //json.txtファイルを読み込んで
            let path = Bundle.main.path(forResource: "prefecture", ofType: "json")
            
            let jsondata = try? Data(contentsOf: URL(fileURLWithPath: path!))
            
            //配列データに変換して
            let jsonArray = (try! JSONSerialization.jsonObject(with: jsondata!, options: [])) as! NSArray
            
            //配列の個数だけUserDefaultに保存
            
            for dat in jsonArray{
                var areaTmpDic = dat as! NSDictionary
                colorArea.setValuesForKeys([areaTmpDic["name"] as! String : areaTmpDic["code"]])

            }


        }else{
            print(colorArea)
            colorArea.setValuesForKeys([areaID : colorCode])
        }
        
        print(colorArea)
        areaDefault.set(colorArea, forKey: "colorArea")
        areaDefault.synchronize()

        calcPercentage()
        
        return colorArea
    }
    
    //パーセント計算・表示
    func calcPercentage(){
    
        var keys:NSArray = colorArea.allKeys as NSArray
        var countColored = 0
        
        for i in 0 ..< (keys.count) {
            var key:String = keys[i] as! String
            var value:String = String(describing: colorArea.object(forKey: key)!)
            
            if Int(value)! > 0 {
                countColored += 1
            }
        }
        
        let perfectNumber:Float = 47.00
        var percentage:Float = Float(countColored) / perfectNumber * 100.00
        var percentString:String = NSString(format: "%.2f", percentage) as String
        
        percentageText.text = "Your Complete : \(percentString)%    \(countColored) / 47 areas"

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

