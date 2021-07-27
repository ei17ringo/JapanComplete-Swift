//
//  settingColorViewController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2021/07/26.
//  Copyright © 2021 Eriko Ichinohe. All rights reserved.
//

import UIKit

class settingColorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let colorSelection = ["🍊オレンジ","🍀みどり","🌕黄色","💗ピンク","🔵青（デフォルト）"]
    
    @IBOutlet weak var colorTypeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "色タイプ"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = colorSelection[indexPath.row]
        
        return cell
        
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
