//
//  settingViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/26.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class settingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var settingTable: UITableView!
    
    var sectionTitle = [NSLocalizedString("colorDef", comment: "")]
    var color = [["name":"low","desc":NSLocalizedString("low", comment: "")],["name":"middle","desc":NSLocalizedString("middle", comment: "")],["name":"high","desc":NSLocalizedString("high", comment: "")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpperBar(title: "ColorDefinition")

        let nib = UINib(nibName: "editCell", bundle: nil)
        settingTable.register(nib, forCellReuseIdentifier: "Cell")
        
        var myDefault = UserDefaults.standard
        if (myDefault.object(forKey: "colorDef") != nil){
            color = myDefault.object(forKey:"colorDef") as! [[String : String]]
        }
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return color.count
    }
    
    /*
     セクションのタイトルを返す.
     */
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section] as? String
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EditTableViewCell
        
        var bgcolor = "#c6d3db"
        switch indexPath.row {
        case 0:
            bgcolor = lowColorCode
        case 1:
            bgcolor = midColorCode
        case 2:
            bgcolor = highColorCode
        default:
            bgcolor = "#c6d3db"
        }
        
        cell.defColor?.backgroundColor = UIColor.hex(hexStr: bgcolor, alpha: 1)
        
        cell.defText.delegate = self
        
        if tableView.isEditing {
        
            cell.defText?.text =
                color[indexPath.row]["desc"] as! String
            cell.defLabel.isHidden = true
            cell.defText.isHidden = false
        }else{
            cell.defLabel.text =
                color[indexPath.row]["desc"] as! String
            cell.defText.isHidden = true
            cell.defLabel.isHidden = false
        }
        
    
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10 // Bool
    }
    
//    //画面上部のデザイン設定
//    func setUpperBar(){
//
//        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//                self.navigationItem.title = NSLocalizedString("setting", comment: "")
//
//    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        
        if settingTable.isEditing {
            settingTable.isEditing = false
            
//            var indexPathRow = IndexPath
            
            for indexPathRow in settingTable.indexPathsForVisibleRows!{
                
                var cell = settingTable.cellForRow(at: indexPathRow) as! EditTableViewCell
                
                color[indexPathRow.row]["desc"] = cell.defText.text!
            }
            
            
            var myDefault = UserDefaults.standard
            
            //データを書き込んで
            myDefault.set(color, forKey: "colorDef")
            
            //即反映させる
            myDefault.synchronize()
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapEditButton(_:)))
        }else{
            settingTable.isEditing = true
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapEditButton(_:)))
        }
        
        settingTable.reloadData()
        
        
        
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
