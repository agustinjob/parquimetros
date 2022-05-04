//
//  Utilities.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 23/12/19.
//  Copyright © 2019 Agustin Job Hernandez Montes. All rights reserved.
//

import Foundation
import UIKit
import APESuperHUD

class Utilities {
    static let cad = "https://easy-ver.rj.r.appspot.com/"
    
    static func styleTextField(_ textField:UITextField, txt:String){
        // Create a bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)

        textField.borderStyle = .none
        textField.textColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: txt, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        // Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleTextFieldCuadreado(_ textField:UITextField, txt:String){
        let bottomLine = CALayer()
        
             textField.borderStyle = .none
              textField.textColor = .white
              textField.layer.borderWidth = 2
              textField.layer.borderColor = UIColor.clear.cgColor
              textField.layer.cornerRadius = 10.0
              textField.backgroundColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
              textField.attributedPlaceholder = NSAttributedString(string: txt, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
              // Add the line to the text field
              textField.layer.addSublayer(bottomLine)
    }
    
    static func styleTextFieldWBorder(_ textField:UITextField, txt:String){
        // Create a bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)

        textField.borderStyle = .none
        textField.textColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: txt, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        // Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    static func styleTextFieldWBorder2(_ textField:UITextField, txt:String){
           // Create a bottom line
           let bottomLine = CALayer()
           bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)

           textField.borderStyle = .none
           textField.textColor = .white
           textField.layer.borderWidth = 2
           textField.layer.borderColor = UIColor.white.cgColor
           textField.layer.cornerRadius = 10.0
           textField.backgroundColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
           textField.attributedPlaceholder = NSAttributedString(string: txt, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
           // Add the line to the text field
           textField.layer.addSublayer(bottomLine)
       }
    
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 75/255, green: 144/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 10.0
        
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton){
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
    }
    
    static func labelColor(_ label: UILabel){
        label.textColor = UIColor.white
    }
    
    static func navigationBarChange(){
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    static func tabBarChange(){
        let tabBarAppearance = UITabBar.appearance()
        
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor.init(red: 50/255, green: 103/255, blue: 147/255, alpha: 1)
    }
    
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func addLeftImageTo(txtField:UITextField, andImage img:UIImage){
        // Forma de consumir el metodo aqui abajo
        //  let passwordImage = UIImage(named: "candado")
        //  addRigthImageTo(txtField: txtPassword, andImage: passwordImage!)
           let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 1, height: 1))
           leftImageView.image = img
           txtField.leftView = leftImageView
           txtField.leftViewMode = .always
         }
       
     static func addRigthImageTo(txtField:UITextField, andImage img:UIImage){
        // let emailImage = UIImage(named: "carnet-de-identidad")
        // addRigthImageTo(txtField: txtEmail, andImage: emailImage!)
           let rigthImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 1, height: 1))
           rigthImageView.image = img
        txtField.rightView = rigthImageView
              txtField.rightViewMode = .always
            }
    
    static func mensajeCargando(){
        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")

                       DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                           APESuperHUD.dismissAll(animated: true)
                       })
    }
    
   
}
