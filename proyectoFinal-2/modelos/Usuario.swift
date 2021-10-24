//
//  Usuario.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import Firebase
struct Usuario: Decodable{
    var discord:String
    var email:String
    var idJuego:String
    var pais:String
    var password:String
    var rango:String
    var usuario:String
    var id:String
    init(discord:String,email:String,idJuego:String,pais:String,password:String,rango:String,usuario:String){
        self.discord = discord
        self.email = email
        self.idJuego = idJuego
        self.pais = pais
        self.password = password
        self.rango = rango
        self.usuario = usuario
        self.id = email
    }
    init(discord:String,email:String,idJuego:String,pais:String,password:String,rango:String,usuario:String,id:String){
        self.discord = discord
        self.email = email
        self.idJuego = idJuego
        self.pais = pais
        self.password = password
        self.rango = rango
        self.usuario = usuario
        self.id = id
    }
    init(d:DocumentSnapshot){
        self.discord = d.get("discord") as? String ?? ""
        self.email = d.get("email") as? String ?? ""
        self.idJuego = d.get("idJuego") as? String ?? ""
        self.pais = d.get("pais") as? String ?? ""
        self.password = d.get("password") as? String ?? ""
        self.rango = d.get("rango") as? String ?? ""
        self.usuario = d.get("usuario") as? String ?? ""
        self.id = d.documentID
    }
}
