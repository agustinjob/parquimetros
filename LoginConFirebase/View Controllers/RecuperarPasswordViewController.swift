//
//  RecuperarPasswordViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 02/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD


class RecuperarPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var solicitarBTN: UIButton!
    @IBOutlet weak var rePass1: UILabel!
    
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    func setUpElements(){
        
        Utilities.labelColor(rePass1)
        Utilities.styleTextFieldWBorder(emailTF, txt: "Correo electrónico")
        Utilities.styleFilledButton(solicitarBTN)
    }
    
    @IBAction func enviarEmail(_ sender: UIButton) {
        if(emailTF.text == ""){
            let hudViewController = APESuperHUD(style: .textOnly, title: "Información", message: "Inserta los datos solicitados por favor")
            self.present(hudViewController, animated: true)
        }else{
            llamarAPI()
        }
    }
    
    func llamarAPI(){
        self.showSpinner()
        AF.request("\(Utilities.cad)api/Cuentas/ForgotPassword", method: .post, parameters: ["email":emailTF.text!], encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
            if let JSON = response.value{
                let datos = JSON as! NSDictionary
                
                let resultado = datos["token"] as? String ?? ""
                
                var mensaje = ""
                
                if(resultado == "Restablecimiento correcto"){
                    mensaje = "Se ha enviando un correo electronico a la dirección ingresada"
                    self.emailTF.text = ""
                }else{
                    mensaje = "Ha ocurrido un problema, vuelve a intentarlo"
                }
                
                let hudViewController = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
                self.present(hudViewController, animated: true)
                
                
            }
            
            
            
        })
    }
    
    
    @IBAction func regresar(_ sender: UIButton) {
  let ir = self.storyboard?.instantiateViewController(identifier: "Login") as? LoginViewController
  self.view.window?.rootViewController = ir
  self.view.window?.makeKeyAndVisible()

    }
    
    
}
