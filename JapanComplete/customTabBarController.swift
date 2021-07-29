//
//  myTabBarController.swift
//  JapanComplete
//
//  Created by Eriko Ichinohe on 2016/12/26.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import FontAwesome_swift


class customTabBarController: UITabBarController {
    
    //Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        self.tabBar.frame = CGRect(x:0, y:self.view.frame.size.height - 100,width: self.view.frame.size.width,height: 50);
        
//        self.tabBar.barTintColor = UIColor.hex(hexStr: "#618eda", alpha: 1)
        self.tabBar.barTintColor = UIColor.hex(hexStr: basecolorCode, alpha: 1)
        self.tabBar.tintColor = UIColor.white
        
        
        
//        self.tabBar.items?[0].setFAIcon(icon: FAType.FAMapMarker)
//        self.tabBar.items?[0].setTitleTextAttributes([NSAttributedString.Key.font:UIFont.fontAwesome(ofSize: 26, style: .solid)], for: .normal)
        self.tabBar.items?[0].image = UIImage.fontAwesomeIcon(name: .mapMarkerAlt, style: .solid, textColor: .black, size: CGSize(width: 30.0, height: 30.0))
        self.tabBar.items?[0].title = "Map"

        //        self.tabBar.items?[0].title = String.fontAwesomeIcon(name: .mapMarkerAlt)

        self.tabBar.items?[1].image = UIImage.fontAwesomeIcon(name: .history, style: .solid, textColor: .black, size: CGSize(width: 30.0, height: 30.0))
        self.tabBar.items?[1].title = "History"

//        self.tabBar.items?[2].setFAIcon(icon: FAType.FACog)
//        self.tabBar.items?[2].setTitleTextAttributes([NSAttributedString.Key.font:UIFont.fontAwesome(ofSize: 26, style: .solid)], for: .normal)
//        self.tabBar.items?[2].title = String.fontAwesomeIcon(name: .cog)
        
        self.tabBar.items?[2].image = UIImage.fontAwesomeIcon(name: .cog , style: .solid, textColor: .black, size: CGSize(width: 30.0, height: 28.0))
        self.tabBar.items?[2].title = "Setting"
        
//        firstViewController?.tabBarItem.setFAIcon(icon: FAType.FAMapMarker)
   
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("tab")
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
