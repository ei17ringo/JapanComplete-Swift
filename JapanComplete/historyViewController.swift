//
//  historyViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/26.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit

class historyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var listTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var selectedName = ""
    var selectedFileName = ""
    
    var tableData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpperBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
//        var historyDefault = UserDefaults.standard
//        var tmp:NSMutableDictionary! = historyDefault.object(forKey: "historyData") as! NSMutableDictionary!
////        tmp["2017/10/26_23:09:15"] = nil
//        tmp.removeObject(forKey: "2017/10/26_23:09:15")
//
//        historyDefault.set(tmp, forKey: "historyData")
//        historyDefault.synchronize()
        
        //データの表示
        setTableData()

        

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
            cell.imageView?.image = UIImage(data: data as! Data)
        }else{
            cell.textLabel?.text = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedName = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
        selectedFileName = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["value"] as! String
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
        
        var segueID:String = segue.identifier!
        
        switch segueID {
        case "toWiki":
            var wikiPage:wikiViewController = segue.destination as! wikiViewController
            wikiPage.displayedName = selectedName
            break
        case "toComplete":
            var compPage:completeViewController = segue.destination as! completeViewController
//            wikiPage.displayedName = selectedName
            break
        case "toDetail":
            var detailPage:detailViewController = segue.destination as! detailViewController
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
        
        switch listTypeSegment.selectedSegmentIndex {
        case 0:
            //Not Completed
            var areaDefault = UserDefaults.standard
            var tmp:NSMutableDictionary! = areaDefault.object(forKey: "colorArea") as! NSMutableDictionary!
            if tmp != nil {
                
                var keys:NSArray = tmp.allKeys as NSArray
                
                for i in 0 ..< (keys.count) {
                    var key:String = keys[i] as! String
                    var value:String = String(describing: tmp.object(forKey: key)!)
                    
                    if value == "0" {
                        tableData.add(["name":key,"value":value])
                    }
                    
                }
                
                
            }
            break
        case 1:
            // Completed
            var areaDefault = UserDefaults.standard
            var tmp:NSMutableDictionary! = areaDefault.object(forKey: "colorArea") as! NSMutableDictionary!
            if tmp != nil {
                
                var keys:NSArray = tmp.allKeys as NSArray
                
                for i in 0 ..< (keys.count) {
                    var key:String = keys[i] as! String
                    var value:String = String(describing: tmp.object(forKey: key)!)
                    
                    if value != "0" {
                        tableData.add(["name":key,"value":value])
                    }
                    
                }
                
                
            }
            break
           
        case 2:
            // Share History
            var historyDefault = UserDefaults.standard
            var tmp:NSMutableDictionary! = historyDefault.object(forKey: "historyData") as! NSMutableDictionary!
            if tmp != nil {
                var keys:NSArray = tmp.allKeys as NSArray
                
                for i in 0 ..< (keys.count) {
                    var key:String = keys[i] as! String
                    var value:String = String(describing: tmp.object(forKey: key)!)
                    
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
    
    //画面上部のデザイン設定
    func setUpperBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        self.navigationItem.title = NSLocalizedString("mapTitle", comment: "")
        
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
