//
//  MPQR2ViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 30/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class MPQR2ViewController: UIViewController {

    let transition = SlideInTransition()
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var codigoTF: UITextField!
    @IBOutlet weak var botonQR: UIButton!
    @IBOutlet weak var confirmarBTN: UIButton!
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
        Utilities.labelColor(label1)
        Utilities.styleTextFieldWBorder(codigoTF, txt: "Ingresa el código")
        Utilities.styleFilledButton(confirmarBTN)
        Utilities.styleFilledButton(botonQR)
    }

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
    guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                       
                   
                       menuViewController.modalPresentationStyle = .overCurrentContext
                       menuViewController.transitioningDelegate = self
                       present(menuViewController, animated: true)


            }
            
        }


extension MPQR2ViewController: UIViewControllerTransitioningDelegate{
            
            func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = true
                return transition
            }
            
            func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = false
                return transition
              }
        }
    


