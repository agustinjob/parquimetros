//
//  MPOxxo2ViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 30/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class MPOxxo2ViewController: UIViewController {

    let transition = SlideInTransition()
    
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
                
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
                // Do any additional setup after loading the view.
    }
    
    func setUPElements(){
        Utilities.navigationBarChange()
    }

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
    guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                       
                   
                       menuViewController.modalPresentationStyle = .overCurrentContext
                       menuViewController.transitioningDelegate = self
                       present(menuViewController, animated: true)


        }
        }
        extension MPOxxo2ViewController: UIViewControllerTransitioningDelegate{
            
            func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = true
                return transition
            }
            
            func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = false
                return transition
              }
        }
