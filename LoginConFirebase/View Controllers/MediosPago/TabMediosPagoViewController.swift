//
//  TabMediosPagoViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 29/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class TabMediosPagoViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.tabBarChange()
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
