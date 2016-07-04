//
//  TabBarController.swift
//  Security Home
//
//  Created by Macintosh on 3/29/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print(item.tag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
