//
//  Places.swift
//  MapKit Starter
//
//  Created by Pranjal Satija on 10/25/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import MapKit
import Alamofire

@objc class Place: NSObject {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func getPlaces() -> [Place] {
        guard let path = Bundle.main.path(forResource: "Places", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var places = [Place]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let title = dictionary?["title"] as? String
            let subtitle = dictionary?["description"] as? String
            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
            
            let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            places.append(place)
        }
        
        return places as [Place]
    }
    
    static func getPlaces2() -> [Place] {
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFndXNfam9iQGhvdG1haWwuY29tIiwibWlWYWxvciI6IkxvIHF1ZSB5byBxdWllcmEiLCJqdGkiOiI1MmRmMDc3My1jNjhhLTQ0ZTQtYTMxMC1kZGY3Yjg3OGYwM2MiLCJleHAiOjE1OTcyNzYwOTd9.pS9QWgUVJC03k5gGac53K3ur5fasWH9TMl_XJCqRoh0"
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        
      
           var places = [Place]()
            AF.request("\(Utilities.cad)api/Concesiones/mtdConsultarPoligonoXIdCiudad?idCiudad=4", method: .get, headers: headers).response{ (responseData) in
                guard let data = responseData.data else {return}
             
                do{
                    let geodata = try JSONDecoder().decode(Geodata.self,from: data)
                    let fea = geodata.features[0].geometry.coordinates
                   
                  //  print(fea)
                    var i = 0
                    while(i<fea[0].count){
                    
                        let place = Place(title: "Pru", subtitle: "Pru2", coordinate: CLLocationCoordinate2DMake(fea[0][i][1], fea[0][i][0]))
                        print(place.coordinate)
                           places.append(place)
                        i+=1
                    }
                     print("Tamano places = \(places.count)")
                 
                //    print(fea[0][0])
                }catch{
                    print("Se vino a error")
                   print(error)
                }
            }
        
        
         //  guard let path = Bundle.main.path(forResource: "Places", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
           
        //   var places = [Place]()
           
    /*       for item in array {
               let dictionary = item as? [String : Any]
               let title = dictionary?["title"] as? String
               let subtitle = dictionary?["description"] as? String
               let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
               
               let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
               places.append(place)
           }*/
       // print("Tamano places = \(places.count)")
           return places as [Place]
       }
}

extension Place: MKAnnotation { }
