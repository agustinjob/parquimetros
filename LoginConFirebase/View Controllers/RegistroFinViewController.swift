//
//  RegistroFinViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 02/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class RegistroFinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var paisPV: UIPickerView!
    @IBOutlet weak var registrarseBTN: UIButton!
    
    let paises=["Mexíco", "Estados Unidos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fondoImagen()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return paises.count
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paises[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // lbltxt = paises[row]
    }
    
    func setUpElements(){
           
              Utilities.styleTextField(passwordTF, txt: "Correo electrónico")
              Utilities.styleFilledButton(registrarseBTN)
          }
    
    func fondoImagen(){
                 let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
                               backgroundImageView.frame = view.frame
                               backgroundImageView.contentMode = .scaleAspectFill
                               view.addSubview(backgroundImageView)
                               view.sendSubviewToBack(backgroundImageView)
             }
    

}
