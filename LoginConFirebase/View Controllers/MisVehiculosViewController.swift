//
//  MisVehiculosViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 21/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD


class MisVehiculosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var addPlacaBTN: UIButton!
    @IBOutlet weak var placasTBL: UITableView!
    let transition = SlideInTransition()
    var jsonArray: NSArray?
    var placasArray: Array<String> = []
    var idPlacasArray: Array<Int> = []
    var token = ""
    var idUsuario = ""
    var posicion = 0
    var idPlaca = 0
    var datosPlaca = ""
    var color = ""
    var modelo = ""
    
    @IBOutlet weak var label1: UILabel!
    let colors = Colors()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        setUpElements()
        llamadaAPI()
        
    }
    
    func setUpElements(){
        placasArray = []
        idPlacasArray = []
        
        Utilities.navigationBarChange()
        Utilities.labelColor(label1)
        
        Utilities.styleFilledButton(addPlacaBTN)
        let icon = UIImage(named: "ico-eliminar")
        addPlacaBTN.setImage(icon, for: .normal)
        addPlacaBTN.imageView?.contentMode = .scaleAspectFit
        addPlacaBTN.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
    }
    
    func fondoImagen(){
        let backgroundImageView = UIImageView(image: UIImage(named: "fondoClaro2.png"))
        
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    func llamadaAPI(){
        
        placasArray = []
        idPlacasArray = []
        
        token = UserDefaults.standard.object(forKey: "token") as! String
         idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
        obtenerSaldo(idUsuario: idUsuario, tokenaizer: token)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request("\(Utilities.cad)api/Vehiculos/mtdConsultarVehiculosXIdUsuario", method: .get, parameters:["id":idUsuario], headers: headers).responseJSON(completionHandler: { response in
            
            if let JSON = response.value{
                self.jsonArray = JSON as? NSArray
                for item in self.jsonArray as! [NSDictionary]{
                    let ciudad = item["str_placas"] as? String
                    let id = item["id"] as? Int
                    self.placasArray.append((ciudad)!)
                    self.idPlacasArray.append((id)!)
                }
                self.placasTBL.reloadData()
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placasArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = placasTBL.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = placasArray[indexPath.row]
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        // cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        posicion = indexPath.row
        let contextItem = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
        
        //Aqui va el seguro
            let alert = UIAlertController(title: "Easypago", message: "Seguro que quieres eliminar el vehículo con placa \(self.placasArray[self.posicion])?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
             
                let headers: HTTPHeaders = [
                           "Authorization": "Bearer \(self.token)",
                                  "Accept": "application/json"
                              ]
                           self.idPlaca = self.idPlacasArray[indexPath.row]
                           self.datosPlaca = self.placasArray[indexPath.row]
                           AF.request("\(Utilities.cad)api/Vehiculos/mtdConsultarVehiculosXId?id=\(self.idPlaca)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                                     
                                     if let JSON = response.value{
                                        
                                        let datos = JSON as! NSDictionary
                                                       let colorAPI = datos["str_color"] as! String
                                         let modeloAPI = datos["str_modelo"] as! String
                                         self.color = colorAPI
                                         self.modelo = modeloAPI
                                     }
                               
                               AF.request("\(Utilities.cad)api/Vehiculos/mtdActualizaVehiculo?id=\(self.idPlaca)", method: .put, parameters:["created_by": "IOS",
                                  "last_modified_by": "IOS",
                                  "bit_status": false,
                                  "str_color":self.color,
                                  "str_modelo": self.modelo,
                                  "str_placas": self.datosPlaca,
                                  "intidconcesion_id" : 1,
                                  "int_id_usuario_id": self.idUsuario
                                  ], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                                  
                                   let hudViewController2 = APESuperHUD(style: .textOnly, title: "Información", message: "Placas eliminadas")
                                                  self.present(hudViewController2, animated: true)
                                   self.llamadaAPI()
                                 
                               })
                                 })
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            

            self.present(alert, animated: true)
            
           
            
            
        }
        
        
        let modificar = UIContextualAction(style: .normal, title: "") { (contextalAction, view, boolValue) in
            self.envioDatos()
        }
        
        contextItem.image = UIImage(named: "ico-eliminar")
        modificar.image = UIImage(named: "ico-editar")
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, modificar])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(idPlacasArray[indexPath.row], forKey: "idPlaca")
        UserDefaults.standard.set(placasArray[indexPath.row], forKey: "placas")
        
            let ir = self.storyboard?.instantiateViewController(identifier: "SeleccionarTiempo") as? PagarParquimetroDEViewController
               self.view.window?.rootViewController = ir
               self.view.window?.makeKeyAndVisible()
    
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func envioDatos(){
        performSegue(withIdentifier: "EnviarPlaca", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "EnviarPlaca" {
            let destino = segue.destination as! AgregarVehiculoViewController
            destino.recibirPlaca = placasArray[posicion]
                destino.recibirIdPlaca = idPlacasArray[posicion]
     
        }
      
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
    func obtenerColorYmodeloAPI(){
           let token = UserDefaults.standard.object(forKey: "token") as! String
                      let headers: HTTPHeaders = [
                          "Authorization": "Bearer \(token)",
                          "Accept": "application/json"
                      ]
           
           AF.request("\(Utilities.cad)api/Vehiculos/mtdConsultarVehiculosXId?id=\(idPlaca)", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
               
               if let JSON = response.value{
                  
                  let datos = JSON as! NSDictionary
                                 let colorAPI = datos["str_color"] as! String
                   let modeloAPI = datos["str_modelo"] as! String
                   self.color = colorAPI
                   self.modelo = modeloAPI
               }
           })
       }
    
}


extension MisVehiculosViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
