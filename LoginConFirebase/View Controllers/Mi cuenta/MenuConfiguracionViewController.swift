//
//  MenuConfiguracionViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 31/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class MenuConfiguracionViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements(){
        Utilities.tabBarChange()
    }
    
}
