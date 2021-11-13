//
//  Location.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 12/11/21.
//
import Firebase
struct Location: Decodable{
    var latitud:Double
    var longitud:Double
    var id:String
    init(latitud:Double,longitud:Double){
        self.latitud = latitud
        self.longitud = longitud
        self.id = ""
    }
    
    init(){
        self.latitud = 0.0
        self.longitud = 0.0
        self.id = ""
    }
    
   
    init(d:DocumentSnapshot){
        self.latitud = d.get("latitud") as? Double ?? 0.0
        self.longitud = d.get("longitud") as? Double ?? 0.0
        self.id = d.documentID
    }
}
typealias Locations = [Location]
