//
//  MenuViewViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 15/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//
import UIKit

enum MenuType: Int{
    case pagarParquimetro
    case pagarMulta
    case comerciantes
  //  case dejarEstacionamiento
    case historial
    case medioPago
    case soporte
    case evaluarParquimetro
    case cerrarsesion
    case modificarCiudad
}


class MenuViewController: UITableViewController {
    
    var didTapMenuType:((MenuType) -> Void)?
    
    @IBOutlet weak var saldoLb: UILabel!
    @IBOutlet weak var ciudadLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saldo = UserDefaults.standard.object(forKey: "montoSaldo") as! Double
        ciudadLb.text = (UserDefaults.standard.object(forKey: "ciudad") as! String)
        saldoLb.text = "Tu saldo: \(saldo.redondear(numeroDeDecimales: 1)) MXN "
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        
        switch indexPath.row {
        case 0:
        let ir = self.storyboard?.instantiateViewController(identifier: "Configuracion") as? MenuConfiguracionViewController
        self.view.window?.rootViewController = ir
        self.view.window?.makeKeyAndVisible()
        case 1:
            let ir = self.storyboard?.instantiateViewController(identifier: "PagarParquimetro") as? PagarParkimetro1ViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
      /*  case 2:
            let ir = self.storyboard?.instantiateViewController(identifier: "PagarMultaQR") as? PagarMultaQRViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()*/
   /*     case 3:
            let ir = self.storyboard?.instantiateViewController(identifier: "Comerciantes") as? AltaComercianteViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()*/
        case 2:
            let ir = self.storyboard?.instantiateViewController(identifier: "vehiculosact") as? VehiculosActivosViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
        case 3:
            let ir = self.storyboard?.instantiateViewController(identifier: "Historial") as? RecibosViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
        case 4:
            let ir = self.storyboard?.instantiateViewController(identifier: "MediosPago") as? TabMediosPagoViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
     /*   case 8:
            let ir = self.storyboard?.instantiateViewController(identifier: "Soporte") as? SoporteIndexViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()*/
       /* case 9:
            let ir = self.storyboard?.instantiateViewController(identifier: "EvaluarParquimetro") as? SCalificarViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()*/
        case 8:
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
           let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            let ir = self.storyboard?.instantiateViewController(identifier: "Login") as? LoginViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
        case 12:
            let ir = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
            self.view.window?.rootViewController = ir
            self.view.window?.makeKeyAndVisible()
            
        default:
            print("In to default")
        }
    }
    
}
