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


class PagarParquimetroDEViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    let transition = SlideInTransition()
    
    @IBOutlet weak var horaFinalTF: UILabel!
    @IBOutlet weak var horayfecha: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: CircularSlider!
    @IBOutlet weak var pagarBTN: UIButton!
    @IBOutlet weak var costoEstacionamientoLabel: UILabel!
//    @IBOutlet weak var espaciosPV: UIPickerView!
   
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
    //var espaciosArray:[String] = ["Selecciona espacio:","E-01","E-02","E-03","E-04","E-05"]
    var totalPrecio:Double = 4.0
    var totalTiempo:Int = 0
    var idEspacio = 0
    var jsonArray: NSArray?
    var espaciosArray: Array<String> = []
    var idEspaciosArray: Array<Int> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
      
        setupSliders()
        
        hour = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)
        seconds = calendar.component(.second, from: date)
        day = calendar.component(.day, from: date)
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "HH:mm  '|' dd MMMM , yyyy"
        
        dateString = formatter.string(from: Date())
        horayfecha.text = "\(dateString) hrs"
        var minutosFinalTemp = minutes+30
        var horaFinalTemp = hour
        if(minutosFinalTemp>=60){
        horaFinalTemp = hour+1
           minutosFinalTemp = minutosFinalTemp - 60
            if(horaFinalTemp>=24){
                horaFinalTemp = horaFinalTemp - 24
            }
        }
        
        horaFinalTF.text = "\(horaFinalTemp):\(minutosFinalTemp) h"
        horaF = horaFinalTemp
        minutosF = minutosFinalTemp
        setUpElements()
       // downloadDataFromAPIBySpaces()
          UserDefaults.standard.set("agregarMovimientoBD", forKey: "tipoOperacion")
    }
    
  
  /*  func downloadDataFromAPIBySpaces(){
        let token = UserDefaults.standard.object(forKey: "token") as! String
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let idZona =  UserDefaults.standard.object(forKey: "idZona") as! Int
        AF.request("\(Utilities.cad)api/Espacios/mtdObtenerEspaciosXIdZona?intIdZona=\(idZona)", method: .get, headers: headers).responseJSON(completionHandler: { response in
            self.espaciosArray.append("Seleccionar espacio")
            self.idEspaciosArray.append(0)
            if let JSON = response.value{
                self.jsonArray = JSON as? NSArray
                for item in self.jsonArray as! [NSDictionary]{
                    let espacio = item["str_clave"] as? String
                    let id = item["id"] as? Int
                    self.espaciosArray.append((espacio)!)
                    self.idEspaciosArray.append((id)!)
                   
                    
                }
                self.espaciosPV.reloadAllComponents()
            }
            
        })
    }*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return espaciosArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return espaciosArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        idEspacio = idEspaciosArray[row]
         UserDefaults.standard.set(idEspaciosArray[row], forKey: "idEspacio")
    }
    
    
    func setUpElements(){
        Utilities.styleFilledButton(pagarBTN)
        _ = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
     //   espaciosPV.setValue(color1, forKey: "textColor")
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
        costoEstacionamientoLabel.text = "$\(precio).00 MXN"
        
        let horaInSeg = ((hour + selectedHour) * 60) * 60
        let minutosInSeg = (minutos + minutes) * 60
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
    
   /* func downloadDataFromAPI(){
        
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
        let idPlaca =  UserDefaults.standard.object(forKey: "idPlaca") as! Int
        let placas =  UserDefaults.standard.object(forKey: "placas") as! String
        let idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
        let idSaldo = UserDefaults.standard.object(forKey: "idSaldo") as! Int
        let montoSaldo = UserDefaults.standard.object(forKey: "montoSaldo") as! Double
        if(totalPrecio>montoSaldo){
                let alertaGuia = UIAlertController(title: title, message: "No cuentas con el saldo suficiente, favor de agregar más saldo", preferredStyle: .alert)
                let guiaOk = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                }
                alertaGuia.addAction(guiaOk)
            present(alertaGuia, animated: true, completion: nil)

        }else{
            self.showSpinner()
        AF.request("\(Utilities.cad)api/Movimientos/mtdMovAparcar", method: .post, parameters:[
         "created_by": "Job",
         "str_placa":placas,
         "boolean_auto_recarga": false,
         "flt_monto": totalPrecio,
         "str_so": "IOS",
         "dt_hora_inicio" : "2020-06-03T16:08:00",
         "int_id_espacio":idEspacio ,
         "int_id_vehiculo_id": idPlaca,
         "intidconcesion_id" : 1,
         "int_id_usuario_id" : idUsuario,
       //  "int_tiempo":3,
         "int_tiempo": tiempoTotal!,
         "int_id_saldo_id": idSaldo
            ],
                   encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                 
            print("Este es el estatus =  \(response.response!.statusCode)")
                    let esta = response.response!.statusCode;
            if(response.response!.statusCode == 200){
                mensaje = "Se ha registrado su tiempo con exito."
                if let JSON = response.value{
                             let datos = JSON as! NSDictionary
                             let idMovimiento = datos["idMovimiento"]
                             print("Este es el idMovimiento \(idMovimiento!)")
                             UserDefaults.standard.set(idMovimiento!, forKey: "idMovimiento")
                             self.obtenerSaldo(idUsuario: idUsuario, tokenaizer: token)
                             
                         }
            }else{
                mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
            }
            self.mostrarAlerta(title: "Información", message: mensaje, estatus: esta )
         
         
           
            
        })
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
      //  let seconds = calendar.component(.second, from: date)
        UserDefaults.standard.set(hour, forKey: "horaI")
        UserDefaults.standard.set(minutes, forKey: "minutoI")
        UserDefaults.standard.set(tiempoTotal, forKey: "tiempoTotal")
        UserDefaults.standard.set(horaF, forKey: "horaF")
         UserDefaults.standard.set(minutosF, forKey: "minutoF")
        }
       } */
    
    func downloadDataFromAPISinEspacios(){
      
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
      let idPlaca =  UserDefaults.standard.object(forKey: "idPlaca") as! Int
      let placas =  UserDefaults.standard.object(forKey: "placas") as! String
      let idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
     // let idSaldo = UserDefaults.standard.object(forKey: "idSaldo") as! String
      let montoSaldo = UserDefaults.standard.object(forKey: "montoSaldo") as! Double
      let latitud = UserDefaults.standard.object(forKey: "latitud") as! String
      let longitud = UserDefaults.standard.object(forKey: "longitud") as! String
      
      if(totalPrecio>montoSaldo){
              let alertaGuia = UIAlertController(title: title, message: "No cuentas con el saldo suficiente, favor de agregar más saldo", preferredStyle: .alert)
              let guiaOk = UIAlertAction(title: "OK", style: .default) {
                  (action) in
              }
              alertaGuia.addAction(guiaOk)
          present(alertaGuia, animated: true, completion: nil)

      }else{
         
        
       /*
         {
                 "created_by": "Dulce Olivia",
                 "str_placa":"DOCT-002",
                 "boolean_auto_recarga": false,
                 "flt_monto":8,
                 "str_so": "IOS",
                 "str_latitud":"19.193939" ,
                 "str_longitud":"-96.13745",
                 "int_id_vehiculo_id": 6,
                 "intidconcesion_id" :1,
                 "int_id_usuario_id" : "4790867f-635e-4900-a0f5-b5f7fb65af9d",
                 "int_tiempo": 60,
                 "int_id_saldo_id": 1

         }
         */
        print("\(Utilities.cad)api/Movimientos/mtdMovAparcar {created_by : IOS,str_placa: \(placas), boolean_auto_recarga: false, flt_monto: \(totalPrecio), str_so: IOS,        str_latitud :\(latitud), str_longitud :\(longitud), int_id_vehiculo_id: \(idPlaca),intidconcesion_id : 1,       int_id_usuario_id : \(idUsuario),  int_tiempo: \(tiempoTotal!), int_id_saldo_id: 1}")
        
      AF.request("\(Utilities.cad)api/Movimientos/mtdMovAparcar", method: .post, parameters:[
       "created_by": "IOS",
       "str_placa":placas,
       "boolean_auto_recarga": false,
       "flt_monto": totalPrecio,
       "str_so": "IOS",
       "str_latitud" :latitud,
       "str_longitud" :longitud,
       "int_id_vehiculo_id": idPlaca,
       "intidconcesion_id" : 1,
       "int_id_usuario_id" : idUsuario,
     //  "int_tiempo":3,
       "int_tiempo": tiempoTotal!,
       "int_id_saldo_id": 1
          ],
                 encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
               
          print("Este es el estatus =  \(response.response!.statusCode)")
                  let esta = response.response!.statusCode;
          if(response.response!.statusCode == 200){
              mensaje = "Se ha registrado su tiempo con exito."
              if let JSON = response.value{
                           let datos = JSON as! NSDictionary
                           let idMovimiento = datos["idMovimiento"] as! String
                            print ("Tipo var = \(type(of: idMovimiento))")
                            print("Este es el idMovimiento \(idMovimiento)")
                           UserDefaults.standard.set(idMovimiento, forKey: "idMovimiento")
                           self.obtenerSaldo(idUsuario: idUsuario, tokenaizer: token)
                           
                       }
          }else{
              mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
            self.removeSpinner()
          
          }
          self.mostrarAlerta(title: "Información", message: mensaje, estatus: esta )
       
       
         
          
      })
      let hour = calendar.component(.hour, from: date)
      let minutes = calendar.component(.minute, from: date)
    //  let seconds = calendar.component(.second, from: date)
      UserDefaults.standard.set(hour, forKey: "horaI")
      UserDefaults.standard.set(minutes, forKey: "minutoI")
      UserDefaults.standard.set(tiempoTotal, forKey: "tiempoTotal")
      UserDefaults.standard.set(horaF, forKey: "horaF")
       UserDefaults.standard.set(minutosF, forKey: "minutoF")
      }
     }
    @IBAction func registrarParquimetro(_ sender: UIButton) {
        downloadDataFromAPISinEspacios()
    }
    
    func mostrarAlerta(title: String, message: String, estatus:Int) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let guiaOk = UIAlertAction(title: "OK", style: .default) {
            (action) in
            if(estatus==200){
               
             let ir = self.storyboard?.instantiateViewController(identifier: "EstacionamientosActu") as? EstacionamientosActualesViewController
                   self.view.window?.rootViewController = ir
                   self.view.window?.makeKeyAndVisible()
            }
               
        }
        alertaGuia.addAction(guiaOk)
    present(alertaGuia, animated: true, completion: nil)
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
    
}

extension PagarParquimetroDEViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension Double {
    func redondear(numeroDeDecimales: Int) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = numeroDeDecimales
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
}
