//
//  PagarParquimetroDEViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 27/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import HGCircularSlider
import Alamofire
import APESuperHUD

@available(iOS 13.0, *)
class PagarParquimetroExtenderViewController: UIViewController {
    
    
    let transition = SlideInTransition()
    
    @IBOutlet weak var rangeCircularSlider: CircularSlider!
    @IBOutlet weak var horayfecha: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var pagarBTN: UIButton!
    @IBOutlet weak var costoEstacionamiento: UILabel!
    @IBOutlet weak var horaFinalTF: UILabel!
    
    let colors = Colors()
    var idPlacaReci = 0
    var placaReci = ""
    let date = Date()
    let calendar = Calendar.current
    var hour = 0
    var minutes = 0
    var seconds = 0
    var day = 0
    var month = 0
    var year = 0
    var horaF = 0
    var minutosF = 0
    var dateString = ""
    var totalPrecio:Double = 0
    var totalTiempo:Int = 0
    var hf = 0
    var mf = 0
    var jsonArray: NSArray?
    var bandera:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        setUpElements()
        setupSliders()
        
        hour = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)
        seconds = calendar.component(.second, from: date)
        day = calendar.component(.day, from: date)
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        
        hf =  UserDefaults.standard.object(forKey: "horaF") as! Int
        mf = UserDefaults.standard.object(forKey: "minutoF") as! Int
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "'|' dd MMMM , yyyy"
        
        dateString = formatter.string(from: Date())
        horayfecha.text = "\(hf):\(mf) \(dateString) hrs"
        
        var minutosFinalTemp = mf+30
        var horaFinalTemp = hf
        if(minutosFinalTemp>=60){
        horaFinalTemp = hf+1
           minutosFinalTemp = minutosFinalTemp - 60
            if(horaFinalTemp>=24){
                horaFinalTemp = horaFinalTemp - 24
            }
        }
        
        horaFinalTF.text = "\(horaFinalTemp):\(minutosFinalTemp) h"
        horaF = horaFinalTemp
        minutosF = minutosFinalTemp
        totalPrecio = 4.23
        setUpElements()
         UserDefaults.standard.set("modificarMovimientoBD", forKey: "tipoOperacion")
    }
   
  
    
    
    func setUpElements(){
        Utilities.styleFilledButton(pagarBTN)
        //espaciosPV.setValue(color2, forKey: "backgroundColor")
    }
    
    func setupSliders(){
        rangeCircularSlider.endThumbImage = UIImage(named: "temporizador-abierto-peque")
        rangeCircularSlider.minimumValue = 15
        rangeCircularSlider.maximumValue = 180
        rangeCircularSlider.endPointValue = 30
        
        rangeCircularSlider.addTarget(self, action: #selector(updateHours), for: .valueChanged)
        rangeCircularSlider.addTarget(self, action: #selector(adjustHours), for: .editingDidEnd)
        
        //  updateTexts(rangeCircularSlider)
    }
    
    
    @objc func updateHours() {
        var selectedHour = Int(rangeCircularSlider.endPointValue)
        selectedHour = selectedHour / 60
        hoursLabel.text = String(format: "%02d", selectedHour)
        
        let minutos = Int(rangeCircularSlider.endPointValue) % 60
        minutesLabel.text = String(format: "%02d", minutos)
        
        let numero = Int(rangeCircularSlider.endPointValue) / 15
        let precio = numero * 2
        costoEstacionamiento.text = "$\(precio).00 MXN"
        
        let horaInSeg = ((hf + selectedHour) * 60) * 60
        let minutosInSeg = (minutos + mf) * 60
        let segundosTotal = horaInSeg + minutosInSeg
        let (h,m,_) = secondsToHoursMinutesSeconds(seconds: segundosTotal)
       horaF = h
        minutosF = m
        horaFinalTF.text = "\(h):\(m) hrs"
        let total:Double = Double(precio) + 0.20 + 0.03
        totalPrecio = total
        pagarBTN.setTitle("Pagar $\(total.redondear(numeroDeDecimales: 3)) MXN", for: .normal)
        
    }
    
    @objc func adjustHours() {
        print(rangeCircularSlider.endPointValue)
        let selectedHour = ceil(rangeCircularSlider.endPointValue / 15.0) * 15
        rangeCircularSlider.endPointValue = selectedHour
        print(selectedHour)
        updateHours()
    }
    
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func obtenerFechaSiguiente(dia: Int) -> (String){
        
        return ""
    }
    
    func downloadDataFromAPI(){
        
        let token = UserDefaults.standard.object(forKey: "token") as! String
       
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        var tiempoTotal = Int(hoursLabel.text!)
        tiempoTotal = tiempoTotal! * 60
        let minutosT = Int(minutesLabel.text!)
        tiempoTotal = tiempoTotal! + minutosT!
        var mensaje = ""
        let idMovimiento = UserDefaults.standard.object(forKey: "idMovimiento") as! String
        let idUsuario = UserDefaults.standard.object(forKey: "idUsuario")!
         //let idSaldo = UserDefaults.standard.object(forKey: "idSaldo") as! String
        let montoSaldo = UserDefaults.standard.object(forKey: "montoSaldo") as! Double
        
        if(totalPrecio>montoSaldo){
                       let alertaGuia = UIAlertController(title: title, message: "No cuentas con el saldo suficiente, favor de agregar más saldo", preferredStyle: .alert)
                       let guiaOk = UIAlertAction(title: "OK", style: .default) {
                           (action) in
                       }
                       alertaGuia.addAction(guiaOk)
                   present(alertaGuia, animated: true, completion: nil)

               }else{
            
            AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosXId?id=\(idMovimiento)", method: .get, headers: headers).responseJSON(completionHandler: { response in
                                  
                             if let JSON = response.value{
                            let item = JSON as! NSDictionary
                               let bandera2 = item["boolean_multa"] as! Bool
                                if(bandera2 == true){
                                    
                                    let alertaGuia = UIAlertController(title: self.title, message: "Tu tiempo ha termino, no puedes extenderlo", preferredStyle: .alert)
                                                                         let guiaOk = UIAlertAction(title: "OK", style: .default) {
                                                                             (action) in
                                                                         }
                                                                         alertaGuia.addAction(guiaOk)
                                    self.present(alertaGuia, animated: true, completion: nil)
                                }else{
                                   self.showSpinner()
                                    AF.request("\(Utilities.cad)api/Movimientos/mtdMovExtenderTiempo?intIdMovimiento=\(idMovimiento)", method: .put, parameters:["last_modified_by": "Job",
                                    //"int_id_espacio": 1,
                                    "int_tiempo" : tiempoTotal!,
                                    "flt_monto" : self.totalPrecio,
                                    "int_id_usuario_id":idUsuario,
                                    "int_id_saldo_id": 1], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                                        
                                        print("Este es el estatus =  \(String(describing: response.response?.statusCode))")
                                        
                                        if(response.response!.statusCode == 200){
                                            mensaje = "Se ha realizado la extensión del tiempo correctamente"
                                            UserDefaults.standard.set("extenderMovimientoBD", forKey: "tipoOperacion")
                                            
                                        }else{
                                            mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
                                        }
                                        self.mostrarAlerta(title: "Información", message: mensaje)
                                       
                                       
                                    })
                                }
                                
                               }
                            
                              })
        
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
    
    func tieneMulta(idMovimiento:Int, tokenaizer:String)->Bool{
        
                   let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(tokenaizer)",
                       "Accept": "application/json"
                   ]
        
       
        
    AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosXId?id=\(idMovimiento)", method: .get, headers: headers).responseJSON(completionHandler: { response in
                       
                  if let JSON = response.value{
                 let item = JSON as! NSDictionary
                    self.bandera = item["boolean_multa"] as! Bool
                  
                    }
                 
                   })
        
        return self.bandera
    }
    
    @IBAction func registrarExtension(_ sender: UIButton) {
      //  UserDefaults.standard.set(horaF, forKey: "horaF")
      // UserDefaults.standard.set(minutosF, forKey: "minutoF")
      downloadDataFromAPI()
    }
    
    func mostrarAlerta(title: String, message: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let guiaOk = UIAlertAction(title: "OK", style: .default) {
            (action) in
             let ir = self.storyboard?.instantiateViewController(identifier: "EstacionamientosActu") as? EstacionamientosActualesViewController
                   self.view.window?.rootViewController = ir
                   self.view.window?.makeKeyAndVisible()
               
        }
        alertaGuia.addAction(guiaOk)
    present(alertaGuia, animated: true, completion: nil)
}
    
}


extension PagarParquimetroExtenderViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}



