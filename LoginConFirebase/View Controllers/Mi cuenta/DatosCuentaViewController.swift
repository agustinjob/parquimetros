
import UIKit
import Alamofire
import APESuperHUD

@available(iOS 13.0, *)
class DatosCuentaViewController: UIViewController {
    
    let transition = SlideInTransition()
    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var apellidoTF: UITextField!
    @IBOutlet weak var prefijoTF: UITextField!
    @IBOutlet weak var celularTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmarBTN: UIButton!
    @IBOutlet weak var rfcTF: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var cpTF: UITextField!
    
    let colors = Colors()
    var email = ""
    var telefono = ""
    var nombre = ""
    var apellidos = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefijoTF.text = "52"
        
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.tabBarChange()
     // Utilities.styleFilledButton(facturaBTN)
        Utilities.styleFilledButton(confirmarBTN)
        
      //  Utilities.styleTextField(nombreTF, txt: "Nombre")
        Utilities.styleTextField(nombreTF, txt: "Nombre")
        
        Utilities.styleTextField(apellidoTF, txt: "Apellido")
        Utilities.styleTextField(prefijoTF, txt: "+52")
        Utilities.styleTextField(celularTF, txt: "Celular")
        Utilities.styleTextField(emailTF, txt: "Correo electrónico")
        Utilities.styleTextField(direccion, txt: "Dirección")
        Utilities.styleTextField(rfcTF, txt: "RFC")
        Utilities.styleTextField(cpTF, txt: "Código postal")
        llenarDatos()
    }
    
    func llenarDatos(){
        email = UserDefaults.standard.object(forKey: "email") as! String
        telefono = UserDefaults.standard.object(forKey: "telefono") as! String
        nombre = UserDefaults.standard.object(forKey: "nombre") as! String
        apellidos = UserDefaults.standard.object(forKey: "apellidos") as! String
        
        nombreTF.text = nombre
        emailTF.text = email
        celularTF.text = telefono
        apellidoTF.text = apellidos
        direccion.text = (UserDefaults.standard.object(forKey: "direccion") as! String)
        cpTF.text = (UserDefaults.standard.object(forKey: "cp") as! String)
        rfcTF.text = (UserDefaults.standard.object(forKey: "rfc") as! String)
        
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{ return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
    
    
    func llamadaAPI(){
        
        let nombres = nombreTF.text
        let apellidos = apellidoTF.text
        let celular = celularTF.text
        let direccionS = direccion.text
        let rfc = rfcTF.text
        let cp = cpTF.text
     
        var mensaje = ""
        if(nombres == "" || apellidos == "" || celular == ""){
           
            let hudViewController = APESuperHUD(style: .textOnly, title: "Error", message: "Por favor inserta la información solicitada")
            present(hudViewController, animated: true)
        }else{
            
            let token = UserDefaults.standard.object(forKey: "token") as! String
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        /*    {

              "UserName": "Job",
              "Email": "agus_job@hotmail.com",
              "created_by": "string",
              "last_modified_by": "string",
              "strNombre": "stringN",
              "strApellidos": "string",
              "PhoneNumber": "string",
              "str_rfc" : "RYTD012",
              "str_direccion" : "direccion",
              "str_cp" : "94563",
              "str_razon_social" :"razon"

            } */
            
            let idUsuario = UserDefaults.standard.object(forKey: "idUsuario") as! String
                AF.request("\(Utilities.cad)api/Cuentas/mtdEditarUsuario?id=\(idUsuario)", method: .put, parameters:[
                    "UserName": "Job",
                    "Email": email,
                    "created_by": "IOS",
                    "last_modified_by": "IOS",
                    "strNombre":nombres!,
                    "strApellidos": apellidos!,
                    "PhoneNumber": "\(celular!)",
                    "str_rfc" : rfc!,
                    "str_direccion" : direccionS!,
                    "str_cp" : cp!,
                    "str_razon_social" :"razon"], encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                    print("Este es el estatus =  \(response.response!.statusCode)")
                    if(response.response!.statusCode == 200){
                        
                               UserDefaults.standard.set(celular, forKey: "telefono")
                               UserDefaults.standard.set(nombres, forKey: "nombre")
                               UserDefaults.standard.set(apellidos, forKey: "apellidos")
                               UserDefaults.standard.set(direccionS, forKey: "direccion")
                               UserDefaults.standard.set(cp, forKey: "cp")
                               UserDefaults.standard.set(rfc, forKey: "rfc")
                               mensaje = "Datos de usuario agregados correctamente"
                                              
                    }else{
                        mensaje = "Ocurrio un error, vuelve a intentarlo por favor."
                    }
                    
                    let hudViewController2 = APESuperHUD(style: .textOnly, title: "Información", message: mensaje)
                    self.present(hudViewController2, animated: true)
                   
                    
                })
          
        }
        
    }
    
    @IBAction func registrarDatos(_ sender: UIButton) {
        llamadaAPI()
    }
    
    

    
}

extension DatosCuentaViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
