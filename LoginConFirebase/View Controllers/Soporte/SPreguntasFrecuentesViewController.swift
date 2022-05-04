//
//  SPreguntasFrecuentesViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 29/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class SPreguntasFrecuentesViewController: UIViewController {

    let transition = SlideInTransition()
    
    
    @IBOutlet weak var label1: UILabel!
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
                
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.tabBarChange()
        Utilities.labelColor(label1)
    }
 
    @IBAction func didTapeMenu(_ sender: UIBarButtonItem) {
     guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                       
                   
                       menuViewController.modalPresentationStyle = .overCurrentContext
                       menuViewController.transitioningDelegate = self
                       present(menuViewController, animated: true)


        }
        }
        extension SPreguntasFrecuentesViewController: UIViewControllerTransitioningDelegate{
            
            func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = true
                return transition
            }
            
            func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                transition.isPresenting = false
                return transition
              }
        }
