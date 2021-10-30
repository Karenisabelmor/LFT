//
//  Invitaciones.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.

import Firebase
struct Invitacion: Decodable{
    var id:String
    var pendientes:[String]
    init(){
        self.id = "1213"
        self.pendientes = []
    }
    init(id:String,pendientes:[String]){
    
        self.id = id
        self.pendientes = pendientes
    }
    init(d:DocumentSnapshot){
        self.id = d.documentID
        self.pendientes = d.get("pendientes") as? [String] ?? []
    }
}
typealias Invitaciones = [Invitacion]
