//
//  LocationControlador.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 12/11/21.
//

import Firebase
class LocationControlador{
let db = Firestore.firestore()
func getLocation(servidor:String,completion: @escaping (Result<Location,Error>)->Void){
    let servidorObtener = db.collection("servidores").document(servidor.lowercased())
    servidorObtener.getDocument{(document,error) in
        if let document = document, document.exists {
            completion(.success(Location(d:document)))
        }
        else{
            
        }
        
    }
}
}
