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
import Accounts

class ViewController: UIViewController,UIWebViewDelegate,GADBannerViewDelegate {

    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var percentageText: UILabel!
    
    var colorArea:NSMutableDictionary = NSMutableDictionary()
    var historyData:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                //画面上部のデザイン設定
        setUpperBar()
        
        //初期表示はUserDefaultに値を作成
        var areaDefault = UserDefaults.standard
        var tmp:NSMutableDictionary! = areaDefault.object(forKey: "colorArea") as! NSMutableDictionary!
        if tmp != nil {
            colorArea = tmp!.mutableCopy() as! NSMutableDictionary
            print("success to get data from UserDefault")
            calcPercentage()
            
        }else{
            colorArea = setAreaDictionary("-1",areaID: "")
        }
        
        print(colorArea)
        
        var tmph:NSMutableDictionary! = areaDefault.object(forKey: "historyData") as! NSMutableDictionary!
        if tmph != nil {
            historyData = tmph!.mutableCopy() as! NSMutableDictionary
            print("success to get data from UserDefault")
            
        }else{
            
        }
        
        print(colorArea)
        
        //map表示
        viewMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //広告表示
        viewAdmob()
        

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
                var imageData = UIImagePNGRepresentation(shareImage)
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
        let rect = mapWebView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        mapWebView.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
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
    
    //UserDefaultに保存している値を地図に反映する
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if colorArea.count == 0 {
            var areaDefault = UserDefaults.standard
            var tmp:NSMutableDictionary! = areaDefault.dictionary(forKey: "colorArea") as! NSMutableDictionary!
            colorArea = tmp

        }
        
        var keys:NSArray = colorArea.allKeys as NSArray
        
        for i in 0 ..< (keys.count) {
            var key:String = keys[i] as! String
            var value:String = String(describing: colorArea.object(forKey: key)!)
            
            var command:String = "setcolor('\(value)','\(key)');"
            
            mapWebView.stringByEvaluatingJavaScript(from: command)
        }
        

    }
    
    //javascriptから値を受け取りUserDefaultに設定する
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
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
        
        var areaDefault = UserDefaults.standard

        //初期設定（全て白）
        if colorCode == "-1" {
            
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
        
        percentageText.text = "Your Score : \(percentage)% \(countColored) / 47 areas"

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

