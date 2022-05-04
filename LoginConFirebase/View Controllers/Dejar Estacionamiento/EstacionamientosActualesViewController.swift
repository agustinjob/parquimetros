//
//  EstacionamientosActualesViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 27/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import HGCircularSlider
import Alamofire
import UserNotifications


class EstacionamientosActualesViewController: UIViewController,UNUserNotificationCenterDelegate {
    
 let transition = SlideInTransition()
   
       
       
    @IBOutlet weak var ampliarBTN: UIButton!
    @IBOutlet weak var pararBTN: UIButton!
    @IBOutlet weak var reciboBTN: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var circulaSlider: CircularSlider!
    @IBOutlet weak var tiempoInicio: UILabel!
    @IBOutlet weak var horaF: UILabel!
    @IBOutlet weak var minutoF: UILabel!
    var jsonArray: NSArray?
    var hi = 0
    var mi = 0
    var hf = 0
    var mf = 0
    var tiempoTotal = 0
    var mensaje = ""
    var token = ""
    var idUsuario = ""
    var placa = ""
    var idEspacio = 0
    var idMovimiento = ""
    var horaCelular = 0
    var minutosCelular = 0
    var diaCel = 0
    var mesCel = 0
    var diaCelular = ""
    let calendar = Calendar.current
    let date = Date()
    var idVehiculo = 0
    var fechaFinal = Date()

    var movimiento = DatosMovimiento()
    
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        UNUserNotificationCenter.current().delegate = self
        idMovimiento = UserDefaults.standard.object(forKey: "idMovimiento") as! String
        obtenerDatosMovimientos()
        horaCelular = calendar.component(.hour, from: date)
        minutosCelular = calendar.component(.minute, from: date)
        diaCel = calendar.component(.day, from: date)
        mesCel = calendar.component(.month, from: date)
        setUpElements()
        
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.styleFilledButton(pararBTN)
        Utilities.styleFilledButton(ampliarBTN)
        Utilities.labelColor(label1)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          
             completionHandler([.alert, .sound])
         }
    
    func guardarMovimiento(){
        
          var dateComponents = DateComponents()
          dateComponents.year = 2020
          dateComponents.month = 6
          dateComponents.day = 25
         // dateComponents.calendar?.locale = Locale(identifier: "es_MX")
          dateComponents.hour = 2
          dateComponents.minute = 31
        //s  let userCalendar = Calendar.current // user calendar
      //    let someDateTime = userCalendar.date(from: dateComponents)
          
      }
    func obtenerDatosMovimientos(){
         idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
        print("Id movimiento " + idMovimiento)
        
        
        token = UserDefaults.standard.object(forKey: "token") as! String
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json"
               ]
                
               AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosXId?id=\(idMovimiento)", method: .get, headers: headers).responseJSON(completionHandler: { response in
                   
                   if let JSON = response.value{
                      let item = JSON as! NSDictionary
                          
                    self.idMovimiento = "\(item["id"] as! Int)"
                           self.placa = item["str_placa"] as! String
                           let horaInicio = item["dt_hora_inicio"] as! String
                           let horaFin = item["dtm_hora_fin"] as! String
                        //   self.idEspacio = item["int_id_espacio"] as! Int
                           self.tiempoTotal = item ["int_tiempo"] as! Int
                    self.idVehiculo = item["int_id_vehiculo_id"] as! Int
                   let monto = item["flt_total_con_comision"] as!  Double
                   let datosInicio: [Substring] = horaInicio.split(separator: "T")
                   let datosFin: [Substring] = horaFin.split(separator: "T")
                  //  var horaInicio = String(datosInicio[1])
                    
                    let horaInicioMinutos: [Substring] = datosInicio[1].split(separator: ":")
                    let horaI = String(horaInicioMinutos[0])
                    let minutoI = String(horaInicioMinutos[1])
                    self.hi = Int(horaI)!
                    self.mi = Int(minutoI)!
                    UserDefaults.standard.set(self.hi, forKey: "horaI")
                    UserDefaults.standard.set(self.mi, forKey: "minutoI")
                    let horaFinMinutos: [Substring] = datosFin[1].split(separator: ":")
                    self.hf = Int(horaFinMinutos[0])!
                    self.mf = Int(horaFinMinutos[1])!
                    self.label1.text =  self.placa
                    self.horaF.text = String(horaFinMinutos[0])
                    self.minutoF.text = String(horaFinMinutos[1])
                    self.tiempoInicio.text = "Inicia \(horaInicioMinutos[0]) : \(horaInicioMinutos[1])"
                    
                    
                    UserDefaults.standard.set(self.hf, forKey: "horaF")
                    UserDefaults.standard.set(self.mf, forKey: "minutoF")
                 //   UserDefaults.standard.set(self.idEspacio, forKey: "idEspacio")
                    UserDefaults.standard.set(datosInicio[0], forKey: "fechaI")
                    UserDefaults.standard.set(datosFin[0], forKey: "fechaF")
                    UserDefaults.standard.set(self.placa, forKey: "placa")
                    UserDefaults.standard.set(monto, forKey: "monto")
              //      let datosFechaFin: [Substring] = datosFin[0].split(separator: "-")
                    self.obtenerSaldo(idUsuario: self.idUsuario, tokenaizer: self.token)
                    //  let mesFin = Int(datosFechaFin[1])
                  //  let diaFin = Int(datosFechaFin[2])
                  let tipoOperacion =  UserDefaults.standard.object(forKey: "tipoOperacion") as! String
                  
                   
                  
                                    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

                                           let dateFormatter = DateFormatter()
                                           dateFormatter.locale = Locale(identifier: "es_MX")
                                           dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                           dateFormatter.dateFormat = dateFormat
                 
                    print("Con prefix \(horaFin.prefix(19))")
                    let date = dateFormatter.date(from: String(horaFin.prefix(19)))!
                    self.fechaFinal = date
                    self.movimiento.idMovimiento = self.idMovimiento
                                      self.movimiento.idVehiculo = self.idVehiculo
                    self.movimiento.fecha = date
                 
                    let ale1 = Calendar.current.date(byAdding: .minute, value: -15, to: date)
                    let ale2 = Calendar.current.date(byAdding: .minute, value: -10, to: date)
                    let ale3 = Calendar.current.date(byAdding: .minute, value: -5, to: date)
                    let ale4 = Calendar.current.date(byAdding: .second, value: -1, to: date)
                    
                    self.movimiento.alerta1 = dateFormatter.string(from: ale1!)
                    self.movimiento.alerta2 = dateFormatter.string(from: ale2!)
                    self.movimiento.alerta3 = dateFormatter.string(from: ale3!)
                    self.movimiento.alertaF = dateFormatter.string(from: ale4!)
                    self.movimiento.placa = self.placa
                                        
                    if(tipoOperacion == "consultarMovimientoBD"){
                        
                    }else{
                    if(tipoOperacion == "agregarMovimientoBD"){
                     /*   try! self.realm.write {
                            self.realm.add(self.movimiento)
                                                        print("guardo \(horaFin)")
                                                    }*/
                        self.generaNotificacionLocal(item: self.movimiento)
                    }else{
                         if(tipoOperacion == "extenderMovimientoBD"){
                  /*      try! self.realm.write {
                            self.movimiento.estatusAlerta = false
                            self.realm.add(self.movimiento, update: .modified)
                            
                                   print("Edito")
                               }*/
                             self.generaNotificacionLocal(item: self.movimiento)
                        }
                    }
                    }
               }
                })
        //414263047848
        //603004043638
    }
    
    
    
    
    func setupSliders(){
        circulaSlider.endThumbImage = UIImage(named: "temporizador-abierto-peque")
        circulaSlider.minimumValue = 15
        circulaSlider.maximumValue = 180
        circulaSlider.endPointValue = CGFloat(tiempoTotal)
        
        //  updateTexts(rangeCircularSlider)
    }
    func fondoImagen(){
                       let backgroundImageView = UIImageView(image: UIImage(named: "fondoClaro2.png"))
           
                                     backgroundImageView.frame = view.frame
                                     backgroundImageView.contentMode = .scaleAspectFill
                                     view.addSubview(backgroundImageView)
                                     view.sendSubviewToBack(backgroundImageView)
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
    
    
    @IBAction func detener(_ sender: UIButton) {
        self.showSpinner()
        let token = UserDefaults.standard.object(forKey: "token") as! String
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json"
               ]
        
       AF.request("\(Utilities.cad)api/Movimientos/mtdMovDesaparcar?intIdMovimiento=\(idMovimiento)", method: .put, parameters:["last_modified_by": "IOS", "int_id_espacio": idEspacio], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
        
        print("Este es el estatus =  \(response.response!.statusCode)")
        
        if(response.response!.statusCode == 200){
            self.mensaje = "Se ha registrado la salida con exito"
        
       //     var movimientoABorrar = self.realm.objects(DatosMovimiento.self).filter("idMovimiento = \(self.idMovimiento)").first
        //Borrar las notificaciones de acá una vez que se elimina esto
        /*    try! self.realm.write {
                self.realm.delete(movimientoABorrar!)
                                              print("Elimino")
                                          }*/
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                        var identifiers: [String] = []
                        for notification:UNNotificationRequest in notificationRequests {
                            if notification.identifier == "\(self.idMovimiento)a" || notification.identifier == "\(self.idMovimiento)b" || notification.identifier == "\(self.idMovimiento)c" || notification.identifier == "\(self.idMovimiento)d"  {
                               identifiers.append(notification.identifier)
                               print("Entro a acumular para eliminar notificaciones")
                            }
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                     }
            
            
        }else{
            self.mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
        }
            self.mostrarAlerta(title: "Información", message: self.mensaje)
       
        
        })
        
    }
    
    
    @IBAction func ampliar(_ sender: UIButton) {
        let ir = self.storyboard?.instantiateViewController(identifier: "ExtenderTiempo") as? PagarParquimetroExtenderViewController
        self.view.window?.rootViewController = ir
        self.view.window?.makeKeyAndVisible()
    }
    
        func mostrarAlerta(title: String, message: String) {
            let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let guiaOk = UIAlertAction(title: "OK", style: .default) {
                (action) in
                 let ir = self.storyboard?.instantiateViewController(identifier: "MisVehiculos") as? MisVehiculosViewController
                       self.view.window?.rootViewController = ir
                       self.view.window?.makeKeyAndVisible()
                   
            }
            alertaGuia.addAction(guiaOk)
        present(alertaGuia, animated: true, completion: nil)
    }
    
    func generaNotificacionLocal(item:DatosMovimiento){
    
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
             var identifiers: [String] = []
             for notification:UNNotificationRequest in notificationRequests {
                 if notification.identifier == "\(item.idMovimiento)a" || notification.identifier == "\(item.idMovimiento)b" || notification.identifier == "\(item.idMovimiento)c" || notification.identifier == "\(item.idMovimiento)d"   {
                    identifiers.append(notification.identifier)
                    print("Entro a acumular para eliminar notificaciones")
                 }
             }
             UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
          }
        
    //    let fecha = item.fecha
        let fale1 = item.alerta1
        let fale2 = item.alerta2
        let fale3 = item.alerta3
    //    let fecha = item.fecha
        let faleF = item.alertaF
         
  //      let alerta1 = Calendar.current.date(byAdding: .minute, value: -15, to: fecha)
    //    let alerta2 = Calendar.current.date(byAdding: .minute, value: -10, to: fecha)
      //  let alerta3 = Calendar.current.date(byAdding: .minute, value: -5, to: fecha)
       
        
        let resultado =  devuelviaFechaCortada(fecha: fale1)
        let año = resultado.year
        let dia = resultado.dia
        let mes = resultado.mes
        let hora = resultado.hora
        let minuto = resultado.minuto
        let  segundo = resultado.segundo
        
        let resultado2 =  devuelviaFechaCortada(fecha: fale2)
        let año2 = resultado2.year
          let dia2 = resultado2.dia
          let mes2 = resultado2.mes
          let hora2 = resultado2.hora
          let minuto2 = resultado2.minuto
          let  segundo2 = resultado2.segundo
        
        let resultado3 =  devuelviaFechaCortada(fecha: fale3)
        let año3 = resultado3.year
          let dia3 = resultado3.dia
          let mes3 = resultado3.mes
          let hora3 = resultado3.hora
          let minuto3 = resultado3.minuto
          let  segundo3 = resultado3.segundo
        
        let resultadoF =  devuelviaFechaCortada(fecha: faleF)
               let añoF = resultadoF.year
                 let diaF = resultadoF.dia
                 let mesF = resultadoF.mes
                 let horaF = resultadoF.hora
                 let minutoF = resultadoF.minuto
                 let  segundoF = resultadoF.segundo
        
        
        
    
        let ale1 = DateComponents(year: año, month: mes, day: dia , hour: hora , minute: minuto, second: segundo)
        let ale2 = DateComponents(year: año2, month: mes2, day: dia2 , hour: hora2 , minute: minuto2, second: segundo2)
        let ale3 = DateComponents(year: año3, month: mes3, day: dia3 , hour: hora3 , minute: minuto3, second: segundo3)
       let aleF = DateComponents(year: añoF, month: mesF, day: diaF , hour: horaF , minute: minutoF, second: segundoF)
    
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: ale1, repeats: false)
        print(trigger1)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: ale2, repeats: false)
          print(trigger2)
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: ale3, repeats: false)
          print(trigger3)
        let trigger4 = UNCalendarNotificationTrigger(dateMatching: aleF, repeats: false)
        print(trigger4)
        
        let content = UNMutableNotificationContent()
               content.title = "Aviso"
        content.subtitle = "Faltan 15 para que su tiempo expire"
               content.body = "Agrega más tiempo a tu vehiculo: \(item.placa)"
              
               content.sound = UNNotificationSound.default
        
        let content2 = UNMutableNotificationContent()
         content2.title = "Aviso"
       content2.subtitle = "Faltan 10 para que su tiempo expire"
                       content.body = "Agrega más tiempo a tu vehiculo: \(item.placa)"
        
         content2.sound = UNNotificationSound.default
        
         let content3 = UNMutableNotificationContent()
          content3.title = "Aviso"
          content3.subtitle = "Faltan 5 para que su tiempo expire"
                        content3.body = "Agrega más tiempo a tu vehiculo: \(item.placa)"
         
          content3.sound = UNNotificationSound.default
        
        let content4 = UNMutableNotificationContent()
                 content4.title = "Aviso"
                 content4.subtitle = "Multa generada"
                 content4.body = "El tiempo de tu vehiculo \(item.placa) se termino"
                
                 content4.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "\(item.idMovimiento)a", content: content, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: "\(item.idMovimiento)b", content: content2, trigger: trigger2)
        let request3 = UNNotificationRequest(identifier: "\(item.idMovimiento)c", content: content3, trigger: trigger3)
        let request4 = UNNotificationRequest(identifier: "\(item.idMovimiento)d", content: content4, trigger: trigger4)
        
       
                UNUserNotificationCenter.current().add(request) {(error) in
                   if let error = error {
                      print("Se ha producido un error: \(error)")
                   }
                }
      UNUserNotificationCenter.current().add(request2) {(error) in
                         if let error = error {
                            print("Se ha producido un error: \(error)")
                         }
                      }
        UNUserNotificationCenter.current().add(request3) {(error) in
                         if let error = error {
                            print("Se ha producido un error: \(error)")
                         }
                      }
        UNUserNotificationCenter.current().add(request4) {(error) in
                               if let error = error {
                                  print("Se ha producido un error: \(error)")
                               }
                            }
     
    
}
    
    func devuelviaFechaCortada(fecha:String)->(year: Int,mes:Int,dia:Int,hora:Int,minuto:Int,segundo:Int){
         
          let datosInicio: [Substring] = fecha.split(separator: "T")
         let tiempo: [Substring] = datosInicio[1].split(separator: ":")
         let fecha: [Substring] = datosInicio[0].split(separator: "-")
         let dia:Int = Int(String(fecha[2]))!
         let mes = Int(String(fecha[1]))!
         let year = Int(String(fecha[0]))!
         let hora = Int(String(tiempo[0]))!
         let minuto = Int(String(tiempo[1]))!
         let segundo = Int(String(tiempo[2]))!
         return (year,mes,dia,hora,minuto,segundo)
     }
}

extension EstacionamientosActualesViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
      }
}
