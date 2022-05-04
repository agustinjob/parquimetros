//
//  SeguridadViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 31/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import Alamofire
import APESuperHUD

@available(iOS 13.0, *)
class SeguridadViewController: UIViewController {

     let transition = SlideInTransition()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var confirmarBTN: UIButton!
    let colors = Colors()
    let email = UserDefaults.standard.object(forKey: "email") as! String
    let nombres = UserDefaults.standard.object(forKey:"nombre") as! String
    let apellidos = UserDefaults.standard.object(forKey:"apellidos") as! String
    let celular = UserDefaults.standard.object(forKey:"telefono") as! String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        setUpElements()
    }

    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.tabBarChange()
        Utilities.labelColor(label1)
        Utilities.labelColor(label2)
        Utilities.styleFilledButton(confirmarBTN)
    }

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
         guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                       
                   
                       menuViewController.modalPresentationStyle = .overCurrentContext
                       menuViewController.transitioningDelegate = self
                       present(menuViewController, animated: true)


        }
    
    

   func llamarAPI(){
    AF.request("\(Utilities.cad)api/Cuentas/ForgotPassword", method: .post, parameters: ["email":email], encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
           if let JSON = response.value{
               let datos = JSON as! NSDictionary
               
               let resultado = datos["token"] as? String ?? ""
               
               var mensaje = ""
               
               if(resultado == "Restablecimiento correcto"){
                   mensaje = "Se ha enviando un correo electronico a tu dirección email"
                  
               }else{
                   mensaje = "Ha ocurrido un problema, vuelve a intentarlo"
               }
               
               let hudViewController = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
               self.present(hudViewController, animated: true)
            
            self.removeSpinner()
           }
           
           
           
       })
   
   }
    
    
    @IBAction func modificarPassword(_ sender: UIButton) {
         self.showSpinner()
        llamarAPI()
      
       
  
    }
    
}


extension SeguridadViewController: UIViewControllerTransitioningDelegate{
            
            func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = true
                return transition
            }
            
            func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = false
                return transition
              }
        }
