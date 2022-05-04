//
//  SeleccionarTiempoViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 30/03/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import HGCircularSlider

extension Date {
    
}

class SeleccionarTiempoViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    let colors = Colors()
    
    lazy var dateFormatter: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
          dateFormatter.dateFormat = "hh:mm a"
          return dateFormatter
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
               rangeCircularSlider.startThumbImage = UIImage(named: "008-temporizador-peque")
               rangeCircularSlider.endThumbImage = UIImage(named: "temporizador-abierto-peque")
               
               let dayInSeconds = 24 * 60 * 60
               rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
               
               rangeCircularSlider.startPointValue = 1 * 60 * 60
               rangeCircularSlider.endPointValue = 8 * 60 * 60

        updateTexts(rangeCircularSlider!)
    }
 
    func setUpElements(){
          Utilities.navigationBarChange()
       //   Utilities.styleFilledButton(siguienteBTN)
         
      }
    @IBAction func updateTexts(_ sender: Any) {
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)

        
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
   

}
