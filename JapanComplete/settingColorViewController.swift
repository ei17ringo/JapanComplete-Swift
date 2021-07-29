//
//  settingColorViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2021/07/26.
//  Copyright © 2021 Eriko Ichinohe. All rights reserved.
//

import UIKit

class settingColorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let colorSelection:KeyValuePairs = ["Orange":NSLocalizedString("Orange", comment: ""),"Green":NSLocalizedString("Green", comment: ""),"Yellow":NSLocalizedString("Yellow", comment: ""),"Pink":NSLocalizedString("Pink", comment: ""),"Blue":NSLocalizedString("Blue", comment: "")]
    
    @IBOutlet weak var colorTypeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpperBar(title: "ColorPattern")
        
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorSelection.count
    }
    
    /*
     セクションのタイトルを返す.
     */
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "色タイプ"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = colorSelection[indexPath.row].value
        
        
        if colorSelection[indexPath.row].key == UserDefaults.standard.string(forKey: "colorSelection"){
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            cell.accessoryView?.backgroundColor = .clear
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        
        return cell
        
    }
    
    
    //セルを選んだとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.setValue(colorSelection[indexPath.row].key, forKey: "colorSelection")
        UserDefaults.standard.synchronize()
        settingColorName = colorSelection[indexPath.row].key
        
        switch settingColorName {
        case "Orange":
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = orangeDefColorCode[index].value
            }
            if let index = orangeDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = orangeDefColorCode[index].value
            }
        case "Yellow":
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = yellowDefColorCode[index].value
            }
            if let index = yellowDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = yellowDefColorCode[index].value
            }
        case "Green":
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = greenDefColorCode[index].value
            }
            if let index = greenDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = greenDefColorCode[index].value
            }
        case "Pink":
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = pinkDefColorCode[index].value
            }
            if let index = pinkDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = pinkDefColorCode[index].value
            }
        default:
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "base"}) {
                basecolorCode = blueDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "low"}) {
                lowColorCode = orangeDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "mid"}) {
                midColorCode = orangeDefColorCode[index].value
            }
            if let index = blueDefColorCode.firstIndex(where: { $0.key == "high"}) {
                highColorCode = orangeDefColorCode[index].value
            }
        }

        tableView.reloadData()
        
        setUpperBar(title: "setting")
        setTabBarColor()
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
