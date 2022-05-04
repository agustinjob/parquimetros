//
//  LoginViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 23/12/19.
//  Copyright © 2019 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Alamofire



class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var recordar: UISwitch!
   
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        setUpElements()
       let email =  UserDefaults.standard.object(forKey: "email") as? String ?? "vacio"
       let password = UserDefaults.standard.object(forKey: "password") as? String ?? "vacio"
       if(email != "vacio" && password != "vacio"){
            bajarDatos(email: email, password: password)
        }
    }
    
    @objc func fireTimer() {
         let roll = arc4random_uniform(6) + 1
        print("Se esta imprimiendo cada \(roll) segundos!")
    }
    
    
    
    func horaLocal(){
        print(Date().localDate())
          }
        
    
  
         
    func setUpElements(){
        errorLabel.alpha = 0
        let passwordImage = UIImage(named: "candadox24")
        let loginImage = UIImage(named: "userx24")
        Utilities.styleTextField(emailTextFiled, txt: "Email")
        Utilities.styleTextField(passwordTextField, txt: "Contraseña")
        Utilities.addLeftImageTo(txtField: emailTextFiled, andImage: loginImage!)
        Utilities.addLeftImageTo(txtField: passwordTextField, andImage: passwordImage!)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    func obtenerSaldo(idUsuario:String, tokenaizer:String){
        //
        let headers: HTTPHeaders = [
                               "Authorization": "Bearer \(tokenaizer)",
                               "Accept": "application/json"
                           ]
        
        AF.request("\(Utilities.cad)api/Saldos/mtdConsultarSaldoXIdUsuario?intIdUsuario=\(idUsuario)",method: .get,encoding: JSONEncoding.default, headers: headers ).responseJSON(completionHandler: { response in
            if let JSON = response.value{
                let datos = JSON as! NSDictionary
                let idSaldo = datos["id"] as! String
                let montoSaldo = datos["dbl_saldo_actual"] as! Double
                        
                        UserDefaults.standard.set(idSaldo, forKey: "idSaldo")
                        UserDefaults.standard.set(montoSaldo, forKey: "montoSaldo")
               
            }
        })
    }
    
    @IBAction func loginTapped(_ sender: Any) {
      
        // validate Text fields
        let email = emailTextFiled.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        bajarDatos(email: email, password: password)
        
    }
    
    func irAMenuPrincipal(){
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func fondoImagen(){
        let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func bajarDatos(email:String, password:String){
    //  self.showSpinner()
        AF.request("\(Utilities.cad)api/Cuentas/Login?strCliente=IOS",method: .post, parameters: ["UserName":email, "password":password], encoding: JSONEncoding.default ).responseJSON(completionHandler: { response in
            
           
            if let JSON = response.value{
                let datos = JSON as! NSDictionary
                let resultado = datos["token"] as! String
             //   print(resultado)
                if resultado == "Invalid login attempt." {
                  //  print(resultado)
                    let alerta = UIAlertController(title: "Información", message: "Datos incorrectos", preferredStyle: .actionSheet)
                    let salir = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
                    alerta.addAction(salir)
                    self.present(alerta, animated: true, completion: nil)
                    
                }else{
                  
                    let id = datos["id"] as! String
                    if self.recordar.isOn{
                        
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                       // print(UserDefaults.standard.object( forKey: "username") as! String)
                    }
                   
                    UserDefaults.standard.set(resultado, forKey: "token")
                    UserDefaults.standard.set(id, forKey: "idUsuario")
                    print("idUsuario = \(id)")
                    
                    self.obtenerSaldo(idUsuario: id, tokenaizer: resultado)
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer \(resultado)",
                        "Accept": "application/json"
                    ]
                   
                    AF.request("\(Utilities.cad)api/Cuentas/mtdConsultarUsuariosXId?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                                       if let JSON = response.value{
                                       let datos = JSON as! NSDictionary
                                        
                                            let emailJ = datos["email"]
                                            let telefono = datos["phoneNumber"] as? String ?? ""
                                            let apellidos = datos["strApellidos"] as? String ?? ""
                                            let nombre = datos["strNombre"] as? String ?? ""
                                            let direccion = datos["str_direccion"] as? String ?? ""
                                            let cp = datos["str_cp"] as? String ?? ""
                                            let rfc = datos["str_rfc"] as? String ?? ""
                                     
                                        
                                        UserDefaults.standard.set(emailJ, forKey: "email")
                                        UserDefaults.standard.set(telefono, forKey: "telefono")
                                        UserDefaults.standard.set(apellidos, forKey: "apellidos")
                                        UserDefaults.standard.set(nombre, forKey: "nombre")
                                        UserDefaults.standard.set(direccion, forKey: "direccion")
                                        UserDefaults.standard.set(cp, forKey: "cp")
                                        UserDefaults.standard.set(rfc, forKey: "rfc")
                                       }
                       
                                          
                                          
                                      })
                    self.irAMenuPrincipal()
                }
            }
        })
    }
    
}
extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}

