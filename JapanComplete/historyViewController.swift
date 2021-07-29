//
//  historyViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/26.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class historyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var listTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var selectedName = ""
    var selectedFileName = ""
    
    var tableData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
        
        //データの表示
        setTableData()

        setUpperBar()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        
        
        if listTypeSegment.selectedSegmentIndex == 2 {
            
            cell.textLabel?.text = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
            
            //サムネイルの画像名を取得
            var fileName = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["value"] as! String
            let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            var fullPath = "\(documentDirectoryFileURL!)\(fileName)".replacingOccurrences(of: "file://", with: "")
            var data = NSData(contentsOfFile: fullPath)
            
            if data != nil {
                cell.imageView?.image = UIImage(data: data as! Data)
            }
        }else{
            var areaName = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
            cell.textLabel?.text = NSLocalizedString(areaName, comment: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedName = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
        selectedFileName = (tableData[(indexPath as NSIndexPath).row] as! NSDictionary)["value"] as! String
        switch listTypeSegment.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "toWiki", sender: nil)
            break
        case 1:
            performSegue(withIdentifier: "toComplete", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "toDetail", sender: nil)
        default:
            break
        }
  
    }
    
    //画面遷移時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueID:String = segue.identifier!
        
        switch segueID {
        case "toWiki":
            let wikiPage:wikiViewController = segue.destination as! wikiViewController
            wikiPage.displayedName = selectedName
            break
        case "toComplete":
            let compPage:completeViewController = segue.destination as! completeViewController
            compPage.displayedName = selectedName
            break
        case "toDetail":
            let detailPage:detailViewController = segue.destination as! detailViewController
            detailPage.displayFileName = selectedFileName
            break
        default:
            break
        }
        
    }

    @IBAction func selectChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        
        setTableData()
        historyTableView.reloadData()
    }
    
    //各リストの設定
    func setTableData(){
        
        tableData = NSMutableArray()
        
        let areaDefault = UserDefaults.standard
        switch listTypeSegment.selectedSegmentIndex {
        case 0:
            //Not Completed
           
            
            let colorAreaTmp = areaDefault.object(forKey: "colorArea") as? NSDictionary
            
            if colorAreaTmp != nil {
                
                let keys:NSArray = colorAreaTmp!.allKeys as NSArray
                
                for i in 0 ..< (keys.count) {
                    let key:String = keys[i] as! String
                    let value:String = String(describing: colorAreaTmp!.object(forKey: key)!)
                    
                    if value == "0" {
                        tableData.add(["name":key,"value":value])
                    }
                    
                }
                
                
            }
            break
        case 1:
            // Completed
            
            let colorAreaTmp = areaDefault.object(forKey: "colorArea") as? NSDictionary
            
            if colorAreaTmp != nil {
                
                let keys:NSArray = colorAreaTmp!.allKeys as NSArray
                
                for i in 0 ..< (keys.count) {
                    let key:String = keys[i] as! String
                    let value:String = String(describing: colorAreaTmp!.object(forKey: key)!)
                    
                    if value != "0" {
                        tableData.add(["name":key,"value":value])
                    }
                    
                }
                
                
            }
            break
           
        case 2:
            // Share History
            var historyDefault = UserDefaults.standard
            
            let historyDataTmp = historyDefault.object(forKey: "historyData") as? NSDictionary
                        
            if historyDataTmp != nil {
                
                var tmp:[String : AnyObject] = (historyDataTmp!.mutableCopy() as! NSMutableDictionary) as! [String : AnyObject]
//                var keys:NSArray = tmp.keys as NSArray
                var keys:Array = [String](tmp.keys)
                
                for i in 0 ..< (keys.count) {
                    var key:String = keys[i] as! String
//                    var value:String = String(describing: tmp.object(forKey: key)!)
                    var value:String = String(describing: tmp[key]!)

                    if value != "0" {
                        tableData.add(["name":key,"value":value])
                    }
                    
                }
                
                
                var descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
                var sortedResults: NSArray = tableData.sortedArray(using: [descriptor]) as! NSArray
                tableData = sortedResults.mutableCopy() as! NSMutableArray
                
                print(tableData)
                
            }
            
            break
            
        default:
            break
        }
        
        historyTableView.reloadData()
        
    }
    
//    //画面上部のデザイン設定
//    func setUpperBar(){
//
//        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
//        self.navigationController?.navigationBar.tintColor = UIColor.white
////        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
////        self.navigationItem.title = NSLocalizedString("mapTitle", comment: "")
//
//    }
    

    
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
