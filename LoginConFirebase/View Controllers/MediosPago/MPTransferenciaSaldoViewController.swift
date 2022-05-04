//
//  MPTransferenciaSaldoViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 29/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MPTransferenciaSaldoViewController: UIViewController {

    let transition = SlideInTransition()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmarBTN: UIButton!
    let colors = Colors()
    
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
        Utilities.styleFilledButton(confirmarBTN)
        Utilities.labelColor(label1)
        Utilities.labelColor(label2)
        Utilities.styleTextFieldWBorder(emailTF, txt: "Ingresa el correo electrónico")
        
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
                          
                      }


extension MPTransferenciaSaldoViewController: UIViewControllerTransitioningDelegate{
                          
                          func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                              transition.isPresenting = true
                              return transition
                          }
                          
                          func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                              transition.isPresenting = false
                              return transition
                            }
                      }
