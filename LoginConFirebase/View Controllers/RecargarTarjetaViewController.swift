//
//  RecargarTarjetaViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 20/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class RecargarTarjetaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
 
     let transition = SlideInTransition()

    let monto = ["$ 50.00 MXN","$ 100.00 MXN", "$ 200.00 MXN", "$ 300.00 MXN" , "$ 400.00 MXN" , "$ 500.00 MXN", "$ 1000.00 MXN"]
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var continuarBTN: UIButton!
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
        Utilities.labelColor(label1)
        Utilities.labelColor(label2)
        Utilities.styleFilledButton(continuarBTN)
    }
    
     func fondoImagen(){
                     let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
                                   backgroundImageView.frame = view.frame
                                   backgroundImageView.contentMode = .scaleAspectFill
                                   view.addSubview(backgroundImageView)
                                   view.sendSubviewToBack(backgroundImageView)
                 }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monto.count
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
              return monto[row]
          }

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
                         menuViewController.modalPresentationStyle = .overCurrentContext
                         menuViewController.transitioningDelegate = self
                         present(menuViewController, animated: true)
    }
    

}

extension RecargarTarjetaViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
      }
}
