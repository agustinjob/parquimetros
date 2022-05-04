//
//  Colors.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 19/02/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class Colors{
    var gl:CAGradientLayer!

       init() {
           let colorTop = UIColor(red: 11.0 / 255.0, green: 22.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0).cgColor
           let colorBottom = UIColor(red: 14.0 / 255.0, green: 90.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0).cgColor

           self.gl = CAGradientLayer()
           self.gl.colors = [colorTop, colorBottom]
           self.gl.locations = [0.0, 1.0]
       }
}
