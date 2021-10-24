//
//  UsuarioControlador.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import Firebase
class UsuarioControlador{
    let db = Firestore.firestore()
    
    func addUsuario(nuevoUsuario:Usuario,completion: @escaping (Result<String,Error>)->Void){
        db.collection("usuarios").document(nuevoUsuario.email).setData([
            "discord": nuevoUsuario.discord,
            "email": nuevoUsuario.email,
            "idJuego": nuevoUsuario.idJuego,
            "pais": nuevoUsuario.pais,
            "password": nuevoUsuario.password,
            "rango": nuevoUsuario.rango,
            "usuario": nuevoUsuario.usuario,
            
        ]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success("registro agregado"))
            }
        }
    }
}
