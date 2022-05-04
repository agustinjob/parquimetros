//
//  RecibosViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 27/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire

class RecibosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let transition = SlideInTransition()
    

 
    var jsonArray: NSArray?
    var placasArray: Array<String> = []
    var idMovimientosArray: Array<Int> = []
    var fechaArray: Array<String> = []
    var token = ""
    var idUsuario = ""
    let colors = Colors()
  
    @IBOutlet weak var historialTB: UITableView!
    
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
        Utilities.navigationBarChange()
      //  Utilities.styleFilledButton(filtrarBTN)
    }
    
    func fondoImagen(){
                       let backgroundImageView = UIImageView(image: UIImage(named: "fondoClaro2.png"))
           
                                     backgroundImageView.frame = view.frame
                                     backgroundImageView.contentMode = .scaleAspectFill
                                     view.addSubview(backgroundImageView)
                                     view.sendSubviewToBack(backgroundImageView)
                   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idMovimientosArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historialTB.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                      cell.textLabel?.text = placasArray[indexPath.row]
                      cell.detailTextLabel?.text = "\(fechaArray[indexPath.row])"
                      cell.layer.borderColor = UIColor.orange.cgColor
                      cell.layer.borderWidth = 1
                      cell.layer.cornerRadius = 8
                       cell.clipsToBounds = true
        return cell
       
     }

    func llamadaAPI(){
        
       
        idMovimientosArray = []
       
        
        token = UserDefaults.standard.object(forKey: "token") as! String
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
         idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
        AF.request("\(Utilities.cad)api/Movimientos/mtdConsultarMovimientosInactivosXIdUsuarioSE?strIdUsuario=\(idUsuario)", method: .get, headers: headers).responseJSON(completionHandler: { response in
            
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
                }
                self.historialTB.reloadData()
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

extension RecibosViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
      }
}
