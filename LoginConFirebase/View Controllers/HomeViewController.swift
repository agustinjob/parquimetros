//
//  HomeViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 23/12/19.
//  Copyright © 2019 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import MapKit
import Alamofire



class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var ciudadesPV: UIPickerView!
    @IBOutlet weak var mapaCiudadesMV: MKMapView!
    @IBOutlet weak var siguienteBTN: UIButton!
    
    var jsonArray: NSArray?
    var ciudadesArray: Array<String> = []
    var idCiudadesArray: Array<Int> = []
    var latitudArray: Array<String> = []
    var longitudArray: Array<String> = []
    
    var manager = CLLocationManager()
    var latitud : CLLocationDegrees!
    var longitud : CLLocationDegrees!
    var ciudad : String = ""
    var id : Int = 0
   
          
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadDataFromAPI()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        setUpElements()
    //     let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
      //  imprimirDatos()
        
        }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.styleFilledButton(siguienteBTN)
       
    }
    
  
    
    @objc func fireTimer() {
           // let roll = arc4random_uniform(6) + 1
  
     //   crearNotificacionesLocales()
        
          // print("Se esta imprimiendo cada \(roll) segundos!")
       }
   
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ciudadesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ciudadesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        latitud = Double(latitudArray[row])
        longitud = Double(longitudArray[row])
        ciudad = ciudadesArray[row]
        id = idCiudadesArray[row]
        print("Este el id de la ciudad \(id)")
        print("Este el id de la ciudad \(ciudad)")
        
     //   print("Latitud \(latitud!) Longitud \(longitud!)")
        let localizacion = CLLocationCoordinate2DMake(latitud, longitud)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        mapaCiudadesMV.setRegion(region, animated: true)
        mapaCiudadesMV.showsUserLocation = true
    }
    
    func downloadDataFromAPI(){
        let token = UserDefaults.standard.object(forKey: "token") as! String
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
                   
        AF.request("\(Utilities.cad)api/Ciudad/mtdConsultarCiudades", method: .get, headers: headers).responseJSON(completionHandler: { response in
            
            if let JSON = response.value{
                self.jsonArray = JSON as? NSArray
                for item in self.jsonArray as! [NSDictionary]{
                    let ciudad = item["str_ciudad"] as? String
                    let id = item["id"] as? Int
                    let latitud = item["str_latitud"] as? String
                    let longitud = item["str_longitud"] as? String
                    self.ciudadesArray.append((ciudad)!)
                    self.idCiudadesArray.append((id)!)
                    self.latitudArray.append((latitud)!)
                    self.longitudArray.append((longitud)!)
                    
                }
                self.ciudadesPV.reloadAllComponents()
                self.latitud = Double(self.latitudArray[0])
                self.longitud = Double(self.longitudArray[0])
                self.ciudad = self.ciudadesArray[0]
                self.id = self.idCiudadesArray[0]
                let localizacion = CLLocationCoordinate2DMake(self.latitud, self.longitud)
                       let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                       let region = MKCoordinateRegion(center: localizacion, span: span)
                self.mapaCiudadesMV.setRegion(region, animated: true)
             //   self.mapaCiudadesMV.showsUserLocation = true
            }
            
        })
           
      

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
    
    
    @IBAction func irSiguiente(_ sender: UIButton) {
      //  let date = Date()
      //  let calendar = Calendar.current

       
         UserDefaults.standard.set(ciudad, forKey: "ciudad")
         UserDefaults.standard.set(id, forKey: "idCiudad")
         UserDefaults.standard.set(latitud, forKey: "latitudCiudad")
         UserDefaults.standard.set(longitud, forKey: "longitudCiudad")
         let ir = self.storyboard?.instantiateViewController(identifier: "PagarParquimetro") as? PagarParkimetro1ViewController
         self.view.window?.rootViewController = ir
         self.view.window?.makeKeyAndVisible()
        
    }
    
}


