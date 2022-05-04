//
//  MPConTarjetaViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 29/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD

class MPConTarjetaViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
    

    let transition = SlideInTransition()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var confirmarBTN: UIButton!
    @IBOutlet weak var montoRecargaPV: UIPickerView!
    var montos: [String] = []
    var montoRe = "100"
    let colors = Colors()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        montos = ["100","200","300","500"]
        setUpElements()
        
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.tabBarChange()
        Utilities.labelColor(label1)
        Utilities.styleFilledButton(confirmarBTN)
        let color1 = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        montoRecargaPV.setValue(color1, forKey: "textColor")
        
    }
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Si entro a montos")
        return montos.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return montos[row]
      }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           montoRe = montos[row]
            
       }
    
   func fondoImagen(){
                       let backgroundImageView = UIImageView(image: UIImage(named: "fondoClaro2.png"))
           
                                     backgroundImageView.frame = view.frame
                                     backgroundImageView.contentMode = .scaleAspectFill
                                     view.addSubview(backgroundImageView)
                                     view.sendSubviewToBack(backgroundImageView)
                   }
    
    
    @IBAction func realizarRecarga(_ sender: UIButton) {
        self.showSpinner()
        
        let token = UserDefaults.standard.object(forKey: "token") as! String
                   let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(token)",
                       "Accept": "application/json"
                   ]
        var mensaje = ""
        let idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
       // let idSaldo = UserDefaults.standard.object(forKey: "idSaldo") as! String
    
        print("\(Utilities.cad)api/Saldos/mtdRecargarSaldo?id=\(1)&fltMonto=\(montoRe)")
        AF.request("\(Utilities.cad)api/Saldos/mtdRecargarSaldo?id=\(idUsuario)&fltMonto=\(montoRe)", method: .put, parameters:[
       "created_by": "IOS",
       "created_date": "2020-02-04",
       "last_modified_by": "IOS",
       "last_modified_date": "2020-02-04",
       "int_id_usuario_trans": idUsuario,
       "str_forma_pago": "Efectivo",
       "str_tipo_recarga": "Recarga",
       "intidconcesion_id" : 1
       ], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                     
      
                      if(response.response!.statusCode == 200){
                          mensaje = "Saldo agregado correctamente."
                        
                        self.obtenerSaldo(idUsuario: idUsuario, tokenaizer: token)
                          self.removeSpinner()
                      }else{
                          mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
                      }
                      
                      let hudViewController2 = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
                      self.present(hudViewController2, animated: true)
          self.removeSpinner()
                     
                      
                  })
      
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
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
    guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                              
                          
                              menuViewController.modalPresentationStyle = .overCurrentContext
                              menuViewController.transitioningDelegate = self
                              present(menuViewController, animated: true)


                   }
                   
               }

               extension MPConTarjetaViewController: UIViewControllerTransitioningDelegate{
                   
                   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                       transition.isPresenting = true
                       return transition
                   }
                   
                   func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                       transition.isPresenting = false
                       return transition
                     }
               }

