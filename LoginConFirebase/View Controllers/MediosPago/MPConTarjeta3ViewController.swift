//
//  MPConTarjeta3ViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 30/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class MPConTarjeta3ViewController: UIViewController {

    let transition = SlideInTransition()
    
    
    @IBOutlet weak var tarjetaTF: UITextField!
    @IBOutlet weak var mesExpTF: UITextField!
    @IBOutlet weak var expAnualTF: UITextField!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var cancelarBTN: UIButton!
    @IBOutlet weak var aceptarBTN: UIButton!
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)

        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.styleTextFieldWBorder(tarjetaTF, txt: "Número de la tarjeta")
        Utilities.styleTextFieldWBorder(mesExpTF, txt: "MM")
        Utilities.styleTextFieldWBorder(expAnualTF, txt: "AAAA")
        Utilities.styleTextFieldWBorder(cvvTF, txt: "")
        Utilities.styleTextFieldWBorder(nombreTF, txt: "Nombre del propietario")
        Utilities.styleFilledButton(cancelarBTN)
        Utilities.styleFilledButton(aceptarBTN)
    }
  
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
    guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                                     
                                 
                                     menuViewController.modalPresentationStyle = .overCurrentContext
                                     menuViewController.transitioningDelegate = self
                                     present(menuViewController, animated: true)


                          }
                          
                      }

                      extension MPConTarjeta3ViewController: UIViewControllerTransitioningDelegate{
                          
                          func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                              transition.isPresenting = true
                              return transition
                          }
                          
                          func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                              transition.isPresenting = false
                              return transition
                            }
                      }
