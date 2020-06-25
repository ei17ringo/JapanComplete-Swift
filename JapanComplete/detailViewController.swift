//
//  detailViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2017/10/27.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import GoogleMobileAds
class detailViewController: UIViewController,GADBannerViewDelegate {

    @IBOutlet weak var detailImage: UIImageView!
    var displayFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        var fullPath = "\(documentDirectoryFileURL!)\(displayFileName)".replacingOccurrences(of: "file://", with: "")
        var data = NSData(contentsOfFile: fullPath)
        detailImage.image = UIImage(data: data as! Data)
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapDelButton(_:)))
        
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
    
    }

    @IBAction func tapDelButton(_ sender: UIBarButtonItem) {
        
        //部品となるアラートを作成
        let alert = UIAlertController(title: "履歴を削除", message: "こちらの履歴を削除してもよろしいですか？", preferredStyle: .alert)
        
        //アラートにOKボタンを追加
        //handler : OKボタンが押された時に行いたい処理を指定する場所
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {action in
            
            // 削除処理
            do {
                let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
                var fullPath = "\(documentDirectoryFileURL!)\(self.displayFileName)".replacingOccurrences(of: "file://", with: "")
                try FileManager.default.removeItem(atPath: fullPath)
                
                var historyDefault = UserDefaults.standard
                var tmp:NSMutableDictionary! = (historyDefault.object(forKey: "historyData") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                for (key,data) in tmp{
                    if (data as! String) == self.displayFileName{
                        tmp.removeObject(forKey: (key as! String))
                    }
                }
                
                historyDefault.set(tmp, forKey: "historyData")
                historyDefault.synchronize()
            self.navigationController?.popViewController(animated: true)
                
            } catch {
                // 削除に失敗
            }
            
            }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        present(alert, animated: true, completion: nil)
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
