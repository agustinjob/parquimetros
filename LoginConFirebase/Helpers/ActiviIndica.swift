//
//  ActiviIndica.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 21/07/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController{
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { (T) in
            self.removeSpinner()
        }
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
