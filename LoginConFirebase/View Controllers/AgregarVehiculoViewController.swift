//
//  AgregarVehiculoViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 14/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD

class AgregarVehiculoViewController: UIViewController {
    
    @IBOutlet weak var placaTF: UITextField!
    @IBOutlet weak var colorTF: UITextField!
    @IBOutlet weak var modeloTF: UITextField!
    
    let transition = SlideInTransition()
    var jsonArray: NSArray?
    
    var placasArray: Array<String> = []
    var idPlacasArray: Array<Int> = []
    
    @IBOutlet weak var mensajeLbl: UILabel!
    @IBOutlet weak var pagarParquimetro1: UILabel!
    @IBOutlet weak var pagarParquimetro2: UILabel!
    @IBOutlet weak var agregarPlaca: UIButton!
    var recibirPlaca:String!
    var recibirIdPlaca = 0
    var url:String = ""
    var bandera:Bool = true
    
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        setUpElements()
       
        if(recibirPlaca == nil){
            url = "\(Utilities.cad)api/Vehiculos/mtdIngresarVehiculo"
            bandera = false
            
        }else{
             obtenerColorYmodeloAPI()
            url = "\(Utilities.cad)api/Vehiculos/mtdActualizaVehiculo?id=\(recibirIdPlaca)"
            
            placaTF.text = recibirPlaca
            agregarPlaca.setTitle("Modificar", for: .normal)
            mensajeLbl.text = "Puedes modificar tu placa borrando los datos e ingresando los correctos.";
        }
        
        print("URL de agregar vehiculo \(url)")
        
    }
    func obtenerColorYmodeloAPI(){
        let token = UserDefaults.standard.object(forKey: "token") as! String
                   let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(token)",
                       "Accept": "application/json"
                   ]
        
        AF.request("\(Utilities.cad)api/Vehiculos/mtdConsultarVehiculosXId?id=\(recibirIdPlaca)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            if let JSON = response.value{
               
               let datos = JSON as! NSDictionary
                              let colorAPI = datos["str_color"] as! String
                let modeloAPI = datos["str_modelo"] as! String
                self.colorTF.text = colorAPI
                self.modeloTF.text = modeloAPI
            }
        })
    }
  
    func llamadaAPI(){
        
        let placas = placaTF.text
        let color = colorTF.text
        let modelo = modeloTF.text
        
        var mensaje = ""
        if(placas == "" || color == "" || modelo == ""){
            //    let image = UIImage(named: "qrcode")!
            //   let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1.5), title: "Error", message: "Por favor inserta la información solicitada")
            let hudViewController = APESuperHUD(style: .textOnly, title: "Error", message: "Por favor inserta la información solicitada")
            present(hudViewController, animated: true)
        }else{
            
            let token = UserDefaults.standard.object(forKey: "token") as! String
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            let idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
            if bandera == true{
                AF.request(url, method: .put, parameters:["created_by": "IOS",                                                 "last_modified_by": "IOS",   "bit_status": true,"str_color":color!,"str_modelo": modelo!,"str_placas": placas!, "intidconcesion_id" : 1 ,"int_id_usuario_id": idUsuario], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                    print("Este es el estatus =  \(response.response!.statusCode)")
                    if(response.response!.statusCode == 200){
                        mensaje = "Placas agregadas correctamente."
                    }else{
                        mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
                    }
                    
                    let hudViewController2 = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
                    self.present(hudViewController2, animated: true)
                    let ir = self.storyboard?.instantiateViewController(identifier: "MisVehiculos") as? MisVehiculosViewController
                    self.view.window?.rootViewController = ir
                    self.view.window?.makeKeyAndVisible()
                    
                })
            }else{
                print("URL \(url) Color y Modelo \(color ?? "color"), \(modelo ?? "modelo")")
                /*
                 {
                     "created_by": "android",
                     "last_modified_by": "andriod",
                     "bit_status": true,
                     "str_color":"Rojo",
                     "str_modelo": "Modelo",
                     "str_placas": "TUC-003",
                   "str_marca" : "Chevrolet",
                     "int_id_usuario_id": "4790867f-635e-4900-a0f5-b5f7fb65af9d"
                 }
                 */
                AF.request(url, method: .post, parameters:[
                    "created_by": "IOS",
                    "last_modified_by": "IOS",
                    "bit_status": true,
                    "str_color":color!,
                    "str_modelo": modelo!,
                    "str_placas": placas!,
                    "str_marca" : "marca",
                    "int_id_usuario_id": idUsuario], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                   
                    print(response)
                    if(response.response!.statusCode == 200){
                        mensaje = "Placas agregadas correctamente."
                        let hudViewController2 = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
                                           self.present(hudViewController2, animated: true)
                                           let ir = self.storyboard?.instantiateViewController(identifier: "MisVehiculos") as? MisVehiculosViewController
                                           self.view.window?.rootViewController = ir
                                           self.view.window?.makeKeyAndVisible()
                    }else{
                        mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
                    }
                    
                   
                    
                })
            }
        }
    }
    
    func setUpElements(){
        Utilities.styleTextField(placaTF, txt: "Ingresa la placa")
        Utilities.styleTextField(colorTF, txt: "Ingresa el color")
        Utilities.styleTextField(modeloTF, txt: "Ingresa el modelo")
        Utilities.styleFilledButton(agregarPlaca)
        Utilities.labelColor(pagarParquimetro1)
        Utilities.labelColor(pagarParquimetro2)
        Utilities.navigationBarChange()
    }
    
    func fondoImagen(){
        let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    @IBAction func agregarPlaca(_ sender: UIButton) {
        
        llamadaAPI()
    }
    
}

extension AgregarVehiculoViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
