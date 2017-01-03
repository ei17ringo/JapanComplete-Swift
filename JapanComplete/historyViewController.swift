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
    
    var tableData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpperBar()
        
        //NotCompletedの表示
        setTableData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = (tableData[(indexPath as! NSIndexPath).row] as! NSDictionary)["name"] as! String
        return cell
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
            
            break

            
        default:
            break
        }
        
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
