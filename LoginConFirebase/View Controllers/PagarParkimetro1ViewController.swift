//
//  PagarParkimetro1ViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 14/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreLocation

//UIPickerViewDelegate, UIPickerViewDataSource
class PagarParkimetro1ViewController: UIViewController,CLLocationManagerDelegate {
    
    let transition = SlideInTransition()
    @IBOutlet weak var mapaZonas: MKMapView!
    let regionInMeters:Double = 10000
    @IBOutlet weak var addresLabel: UILabel!
    var manager = CLLocationManager()
    var latitud : CLLocationDegrees!
    var longitud : CLLocationDegrees!
    var previousLocation: CLLocation?
    var zona : String = ""
    var id : Int = 0
    var ban: Bool = false
    var Poligono2 = MKPolygonRenderer()
    
    
    @IBOutlet weak var siguienteBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // downloadDataFromAPI()
        siguienteBTN.isEnabled = false
        setUpElements()
       checkLocationServices()
        pintaPoligono()
    }
    
    func setUpElements(){
        Utilities.navigationBarChange()
        Utilities.styleFilledButton(siguienteBTN)
 }
    
    func setupLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
      }
    
   func checkLocationServices(){
          if CLLocationManager.locationServicesEnabled(){
              setupLocationManager()
              checkLocationAuthorization()
          }else{
              
          }
          
      }
    
    func startTackinUserLocation(){
        // Muestra la localización del usuario, el puntito azul
        mapaZonas.showsUserLocation = true
       // centerViewOnUserLocation()
      manager.startUpdatingLocation()
        // con este de arriba se actualiza la localización del usuario y se activa el metodo de abajo en donde dice didUpdateLocations
        previousLocation = getCenterLocation(for: mapaZonas)

    }
    
     func checkLocationAuthorization(){
            switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
               startTackinUserLocation()
                
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                break;
            case .restricted:
                
                 break;
            case .denied:
                
                 break;
            case .authorizedAlways:
                        
                 break;
            
                
            }
        }


    
    func pintaPoligono(){
        let token = UserDefaults.standard.object(forKey: "token") as! String
                   
                   let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(token)",
                       "Accept": "application/json"
                   ]
        let idCi =  UserDefaults.standard.object(forKey: "idCiudad") as! Int
             
                  var places = [Place]()
                   AF.request("\(Utilities.cad)api/Concesiones/mtdConsultarPoligonoXIdCiudad?idCiudad=\(idCi)", method: .get, headers: headers).response{ (responseData) in
                       guard let data = responseData.data else {return}
                    
                       do{
                           let geodata = try JSONDecoder().decode(Geodata.self,from: data)
                           let fea = geodata.features[0].geometry.coordinates
                          
                         //  print(fea)
                           var i = 0
                           while(i<fea[0].count){
                           
                               let place = Place(title: "Pru", subtitle: "Pru2", coordinate: CLLocationCoordinate2DMake(fea[0][i][1], fea[0][i][0]))
                              
                                  places.append(place)
                               i+=1
                           }
                        self.addAnnotations(places: places)
                              // addPolyline()
                        self.addPolygon(places: places)
                        
                       //    print(fea[0][0])
                       }catch{
                           print("Se vino a error")
                          print(error)
                       }
                   }
        
    }
    
    
        func addAnnotations(places:[Place]) {
            mapaZonas?.delegate = self
            mapaZonas?.addAnnotations(places)

            let overlays = places.map { MKCircle(center: $0.coordinate, radius: 100) }
            mapaZonas?.addOverlays(overlays)
            
            // Add polylines
            
           var locations = places.map { $0.coordinate }
            print("Number of locations: \(locations.count)")
           let polyline = MKPolyline(coordinates: &locations, count: locations.count)
            mapaZonas?.addOverlay(polyline)
            
        }
        
        func addPolyline(places:[Place]) {
            var locations = places.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: &locations, count: locations.count)
            
            mapaZonas?.addOverlay(polyline)
        }
    
   
        
        func addPolygon(places:[Place]) {
            var locations = places.map { $0.coordinate }
            let polygon = MKPolygon(coordinates: &locations, count: locations.count)
         
            mapaZonas?.addOverlay(polygon)
            
        }
    func fondoImagen(){
        let backgroundImageView = UIImageView(image: UIImage(named: "fondo.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
            let lati = "\(String(describing: latitud!))"
            let longi = "\(String(describing: longitud!))"
             UserDefaults.standard.set(lati, forKey: "latitud")
             UserDefaults.standard.set(longi, forKey: "longitud")
        }
        if self.ban ==  false {
            centerViewOnUserLocation()
            verPoligono()
            self.ban = true
        }
      
    }
    
    func verPoligono(){
        let punto = CLLocationCoordinate2DMake(19.199722, -96.133099)
        let currentMapPoint: MKMapPoint = MKMapPoint(punto)
        let _: CGPoint = Poligono2.point(for: currentMapPoint)
       // print("Esto es \(polygonViewPoint)")
     //  print(Poligono2.path.contains(polygonViewPoint).description)
     /*   if Poligono2.path.contains(polygonViewPoint) == true {
                       print("Si esta dentro")
                 }else{
                    print("No esta dentro")
                 }*/
    }
    func centerViewOnUserLocation(){
           if let location = manager.location?.coordinate{
               let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
               mapaZonas.setRegion(region, animated: true)
         
           }
       }
    
    func obtenerLocalizacion(){
        let localizacion = CLLocationCoordinate2DMake(latitud, longitud)
                     let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                     let region = MKCoordinateRegion(center: localizacion, span: span)
                     mapaZonas.setRegion(region, animated: true)
                     mapaZonas.showsUserLocation = true
    }
    
    func getCenterLocation(for mapView:MKMapView)->CLLocation{
         let latitude = mapView.centerCoordinate.latitude
         let longitude = mapView.centerCoordinate.longitude
         return CLLocation(latitude: latitude, longitude: longitude)
     }

    
}

extension PagarParkimetro1ViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
extension PagarParkimetro1ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
           
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "place icon")
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            print("Entro en el AnnotationView")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
           let renderer = MKCircleRenderer(overlay: overlay)
            //renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
          //  renderer.strokeColor = UIColor.blue
           // renderer.lineWidth = 2
            return renderer
        
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            Poligono2 = renderer
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
        let alertController = UIAlertController(title: "Welcome to \(title)", message: "You've selected \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation)>50 else{return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks,error) in
            guard let self = self else {return}
        
            if let _ = error{
                return
            }
            
            guard let placemark = placemarks?.first else{
                
                return
            }
            let latitud = placemark.location?.coordinate.latitude
            let longitud = placemark.location?.coordinate.longitude
            UserDefaults.standard.set("\(String(describing: latitud!))", forKey: "latitud")
            UserDefaults.standard.set("\(String(describing: longitud!))", forKey: "longitud")
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
        
            let punto = CLLocationCoordinate2DMake(latitud!, longitud!)
                  //   let punto = CLLocationCoordinate2DMake(43.655782, -79.382094)
                       let currentMapPoint: MKMapPoint = MKMapPoint(punto)
            let polygonViewPoint: CGPoint = self.Poligono2.point(for: currentMapPoint)
            if self.Poligono2.path.contains(polygonViewPoint) == true {
                self.siguienteBTN.isEnabled = true
                     }else{
                self.siguienteBTN.isEnabled = false
                     }
            DispatchQueue.main.async {
                self.addresLabel.text = "\(streetNumber) \(streetName)"
            }
        }
        
        
    }
}
