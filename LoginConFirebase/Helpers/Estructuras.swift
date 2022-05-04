//
//  Estructuras.swift
//  PruebaPoligono
//
//  Created by Agustin Job Hernandez Montes on 11/08/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import Foundation

struct Geodata: Codable {
    let type: String
    let features: [Feature]
    
 /*   enum CodingKeys: String, CodingKey {
           case type = "type"
           case features = "features"
          
       }*/
}

struct Feature: Codable {
    let type: String
  //  let properties: Properties
    let geometry: Geometry
 /*   enum CodingKeys: String, CodingKey {
             case type = "type"
             case properties = "properties"
             case geometry = "geometry"
            
         }*/
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[[Double]]]
  
}

struct Properties: Codable {
    let name: String?
}
