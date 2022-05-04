//
//  RegistroInicioViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 02/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire


class RegistroInicioViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var continuarBTN: UIButton!
    @IBOutlet weak var usuarioTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var switchterycond: UISwitch!
    @IBOutlet weak var regresar: UIButton!
    
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
        
        Utilities.styleTextField(emailTF, txt: "Ingresa tu correo electrónico")
        Utilities.styleTextField(usuarioTF, txt: "Ingresa el nombre de usuario")
        Utilities.styleTextField(passwordTF, txt: "Ingresa la contraseña")
        Utilities.styleFilledButton(continuarBTN)
        Utilities.styleFilledButton(regresar)
    }
    
    func fondoImagen(){
        let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    
    @IBAction func registrarUsuario(_ sender: UIButton) {
        
        self.showSpinner()
           
        let email = emailTF.text!
        let usuario = usuarioTF.text!
        let password = passwordTF.text!
       
        
        if(switchterycond.isOn == false){
            let alerta = UIAlertController(title: "Información", message: "Debes de aceptar los terminos y condiciones", preferredStyle: .actionSheet)
            let salir = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
            alerta.addAction(salir)
            self.present(alerta, animated: true, completion: nil)
            
        }else{
            if(email == "" && usuario == "" && password == ""){
                let alerta = UIAlertController(title: "Información", message: "Debes de insertar todos los datos solicitados", preferredStyle: .actionSheet)
                let salir = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
                alerta.addAction(salir)
                self.present(alerta, animated: true, completion: nil)
            }else{
              let x =  Utilities.isPasswordValid(password)
                if(x==false){
                    let alerta = UIAlertController(title: "Información", message: "La contraseña no cumple con el formato solicitado", preferredStyle: .actionSheet)
                    let salir = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
                    alerta.addAction(salir)
                    self.present(alerta, animated: true, completion: nil)
                }else{
                AF.request("\(Utilities.cad)api/Cuentas/Crear", method: .post ,  parameters: [
                      "UserName": usuario,
                      "Email": email,
                      "created_by": "IOS",
                      "last_modified_by": "IOS",
                      "strNombre": "",
                      "strApellidos": "",
                      "password" : password,
                      "PhoneNumber": "",
                      "Rol": "MOVIL"
                    ], encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
                        
                        if (response.response?.statusCode == 200) {
                            self.removeSpinner()
                                                let alerta = UIAlertController(title: "Registro", message: "La información ha sido registrada exitosamente", preferredStyle: .actionSheet)
                                                
                                                let salir =  UIAlertAction(title: "Salir", style: .default) { (action) in
                                                    let ir = self.storyboard?.instantiateViewController(identifier: "Login") as? LoginViewController
                                                    self.view.window?.rootViewController = ir
                                                    self.view.window?.makeKeyAndVisible()
                                                }
                                                alerta.addAction(salir)
                                                self.present(alerta,animated: true, completion: nil)
                        }else{
                        
                    if let JSON = response.value{
                      
                        let datos = JSON as! NSDictionary
                        self.removeSpinner()
                       
                        let resultado = datos["token"] as! String
                        print("Este es el token =  \(resultado)")
                        if resultado == "Username or password invalid" {
                            let alerta = UIAlertController(title: "Información", message: "El nombre de usuario o email ya han sido registrados anteriormente, intenta con otro.", preferredStyle: .actionSheet)
                            let salir = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
                            alerta.addAction(salir)
                            self.present(alerta, animated: true, completion: nil)
                            
                        }
                            }
                            
                        }
                        
                    
                })
 
            }
            }
                
        }
    }
}

