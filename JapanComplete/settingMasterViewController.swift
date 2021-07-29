//
//  settingMasterViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2021/05/01.
//  Copyright © 2021 Eriko Ichinohe. All rights reserved.
//

import UIKit

class settingMasterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var settingTableView: UITableView!
    
    let menuArray = [NSLocalizedString("ColorPattern", comment: ""),NSLocalizedString("ColorDefinition", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpperBar()
     
        //広告表示
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.viewAdmob(self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    /*
     セクションのタイトルを返す.
     */
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "色"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = menuArray[indexPath.row]
        
        return cell
        
    }
    
    //セルを選んだとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "SelectColorTypeSegue", sender: nil)
        case 1:
            performSegue(withIdentifier: "EditDefinitionSegue", sender: nil)
        default:
            print("selected:\(indexPath.row)")
        }
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
