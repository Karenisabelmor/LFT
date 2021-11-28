//
//  Amix.swift
//  FuncionalidadAppleWatch WatchKit Extension
//
//  Created by user191334 on 11/27/21.
//

import Foundation
struct Usuario {
    var usuario:String
    var discord:String
    var rango:String
    
    
    init(usuario:String,discord:String,rango:String){
        self.usuario = usuario
        self.discord = discord
        self.rango = rango
    }
}
typealias Usuarios = [Usuario]
