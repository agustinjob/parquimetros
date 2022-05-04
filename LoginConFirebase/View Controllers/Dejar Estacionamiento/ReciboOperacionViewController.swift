//
//  ReciboOperacionViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 27/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire

class ReciboOperacionViewController: UIViewController {

     let transition = SlideInTransition()
    
    let colors = Colors()
    
    @IBOutlet weak var fechaI: UILabel!
    @IBOutlet weak var fechaF: UILabel!
    @IBOutlet weak var horaI: UILabel!
    @IBOutlet weak var horaF: UILabel!
    @IBOutlet weak var zona: UILabel!
    @IBOutlet weak var placa: UILabel!
    @IBOutlet weak var costo: UILabel!
    @IBOutlet weak var tiempoTotal: UILabel!
    @IBOutlet weak var costoTotal: UILabel!
    var jsonArray: NSArray?
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
      //  horaI.text = "\(String(describing: hi)):\(String(describing: mi))"
       // horaF.text = "\(String(describing: hf)):\(String(describing: mf))"
      //  placa.text = UserDefaults.standard.object(forKey: "placa") as? String
   //     fechaI.text = fechaIn
    //    fechaF.text = fechaFi
   //     costoTotal.text = "$\(monto.redondear(numeroDeDecimales: 2)) MXN"
     //   costo.text = "$\(Int(monto)).00 MXN"
        obtenerDatosMovimientos()
        
    }

    func setUpElements(){
        Utilities.navigationBarChange()
        
    }
    
   
    
    func fondoImagen(){
                       let backgroundImageView = UIImageView(image: UIImage(named: "fondoClaro2.png"))
           
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
    
    func obtenerDatosMovimientos(){
      let idMovimiento = UserDefaults.standard.object(forKey: "idMovimiento") as! String
        
        
        token = UserDefaults.standard.object(forKey: "token") as! String
        
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json"
               ]
        
                print("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosXId?id=\(idMovimiento)")
        
            AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosXId?id=\(idMovimiento)", method: .get, headers: headers).responseJSON(completionHandler: { response in
                                
                              if let JSON = response.value{
                                let item = JSON as! NSDictionary
                                    self.placa.text = (item["str_placa"] as! String)
                                    let costoF = item["flt_monto"] as! Double
                                    self.costo.text = "$\(costoF)0 MXN"
                                    let costoFT = costoF + 0.23
                                    self.costoTotal.text = "$\(costoFT) MXN"
                                    let horaInicio = item["dt_hora_inicio"] as! String
                                    let horaFin = item["dtm_hora_fin"] as! String
                                    let datosInicio: [Substring] = horaInicio.split(separator: "T")
                                    let datosFin: [Substring] = horaFin.split(separator: "T")
                                    self.fechaI.text = String(datosInicio[0])
                                    self.horaI.text = String(datosInicio[1])
                                    self.fechaF.text = String(datosFin[0])
                                    self.horaF.text = String(datosFin[1])
                                    self.tiempoTotal.text = String(item["int_tiempo"] as! Int) + " min"
                           
           
                   
                    
               
                    //  let mesFin = Int(datosFechaFin[1])
                  //  let diaFin = Int(datosFechaFin[2])
               
               }
               })
        //414263047848
        //603004043638
    }
    
}
extension ReciboOperacionViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
      }
}

