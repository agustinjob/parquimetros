//
//  VehiculosActivosViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 17/06/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire

@available(iOS 13.0, *)
class VehiculosActivosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    let colors = Colors()
    let transition = SlideInTransition()
       var jsonArray: NSArray?
       var placasArray: Array<String> = []
       var idMovimientosArray: Array<Int> = []
    var fechaArray: Array<String> = []
    var horaArray: Array<String> = []
    var token = ""
    var idUsuario = ""
    @IBOutlet weak var movimientosTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        llamadaAPI()
        UserDefaults.standard.set("consultarMovimientoBD", forKey: "tipoOperacion")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movimientosTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
               cell.textLabel?.text = placasArray[indexPath.row]
               cell.detailTextLabel?.text = "\(fechaArray[indexPath.row]) \(horaArray[indexPath.row])"
               cell.layer.borderColor = UIColor.orange.cgColor
               cell.layer.borderWidth = 1
               cell.layer.cornerRadius = 8
                cell.clipsToBounds = true
               return cell
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    
    func llamadaAPI(){
        
        placasArray = []
        idMovimientosArray = []
        fechaArray = []
        
        token = UserDefaults.standard.object(forKey: "token") as! String
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
         idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
        AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosActivosXIdUsuarioSE?strIdUsuario=\(idUsuario)", method: .get, headers: headers).responseJSON(completionHandler: { response in
            
            if let JSON = response.value{
                self.jsonArray = JSON as? NSArray
                for item in self.jsonArray as! [NSDictionary]{
                    let ciudad = item["str_placa"] as? String
                    let id = item["id"] as? Int
                    let fecha = item["dtm_hora_fin"] as? String
                    self.placasArray.append((ciudad)!)
                    self.idMovimientosArray.append((id)!)
                    let datos: [Substring] = fecha!.split(separator: "T")
                    self.fechaArray.append("Fecha: \(datos[0])")
                    self.horaArray.append("Hora: \(datos[1])")
                   
                }
                self.movimientosTV.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set("\(idMovimientosArray[indexPath.row])", forKey: "idMovimiento")
        print("Esto es: \(idMovimientosArray[indexPath.row])")
        
        let ir = self.storyboard?.instantiateViewController(identifier: "EstacionamientosActu") as? EstacionamientosActualesViewController
               self.view.window?.rootViewController = ir
               self.view.window?.makeKeyAndVisible()
    
    }
 

}

extension VehiculosActivosViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


