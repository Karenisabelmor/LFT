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
    var rango:String
    var usuario:String
    var id:String
    var rol:String
    var horario:String
    var amigos:[String]
    init(discord:String,email:String,idJuego:String,pais:String,rango:String,usuario:String,horario:String, rol:String){
        self.discord = discord
        self.email = email
        self.idJuego = idJuego
        self.pais = pais
        self.rango = rango
        self.rol = rol
        self.horario = horario
        self.usuario = usuario
        self.id = email
        self.amigos = []
    }
    init(){
        self.discord = ""
        self.email = ""
        self.idJuego = ""
        self.pais = ""
        self.rol = ""
        self.horario = ""
        self.rango = ""
        self.usuario = ""
        self.id = ""
        self.amigos = []
    }
    init(discord:String,email:String,idJuego:String,pais:String,rango:String,usuario:String,id:String,amigos:[String],horario:String, rol:String){
        self.discord = discord
        self.email = email
        self.idJuego = idJuego
        self.pais = pais
        self.rango = rango
        self.usuario = usuario
        self.id = id
        self.rol = rol
        self.horario = horario
        self.amigos = amigos
    }
    init(d:DocumentSnapshot){
        self.discord = d.get("discord") as? String ?? ""
        self.email = d.get("email") as? String ?? ""
        self.idJuego = d.get("idJuego") as? String ?? ""
        self.pais = d.get("pais") as? String ?? ""
        self.rango = d.get("rango") as? String ?? ""
        self.usuario = d.get("usuario") as? String ?? ""
        self.id = d.documentID
        self.rol = d.get("rol") as? String ?? ""
        self.horario = d.get("horario") as? String ?? ""
        self.amigos = d.get("amigos") as? [String] ?? []
    }
}
typealias Usuarios = [Usuario]
