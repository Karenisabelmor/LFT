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
            "amigos": [],
            "rol":nuevoUsuario.rol,
            "horario": nuevoUsuario.horario
            
        ]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                self.db.collection("invitaciones").document(nuevoUsuario.email).setData([
                    "pendientes": []
                ]) {err in
                    if let err = err {
                        completion(.failure(err))
                    }
                    else
                    {
                        print("agregadaLista")
                    }}
                completion(.success("registro agregado"))
            }
        }
    }
    
    func fetchFriends(completion: @escaping (Result<[Usuario],Error>)->Void){
        var listaUsuarios = [Usuario]()
        var usuario = [Usuario]()
        let user = Auth.auth().currentUser
        let email = user!.email
        db.collection("usuarios").whereField("email", isEqualTo: email!).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    usuario.append(Usuario(d:document))
                }
                if usuario[0].amigos.count != 0 {
                self.db.collection("usuarios").whereField("email", in: usuario[0].amigos).getDocuments(){ (querySnapshot, err) in
                                       if let err = err {
                                           print("Error getting documents: \(err)")
                                       } else {
                                           for document in querySnapshot!.documents {
                                               var a = Usuario(d:document)
                                               listaUsuarios.append(a)
                                           }
                                           completion(.success(listaUsuarios))
                                       }
                    }
                }
            }
        }
    }
   
    
    func fetchInvitaciones(completion: @escaping (Result<[Usuario],Error>)->Void){
        var listaUsuarios = [Usuario]()
        let user = Auth.auth().currentUser
        let email = user!.email
        let inivtaciones = db.collection("invitaciones").document(email!)
        inivtaciones.getDocument{(document,error) in
            if let document = document, document.exists {
                var  invitacion = Invitacion(d:document)
                if(invitacion.pendientes.count != 0){
                self.db.collection("usuarios").whereField("email", in: invitacion.pendientes).getDocuments(){ (querySnapshot, err) in
                                       if let err = err {
                                           print("Error getting documents: \(err)")
                                       } else {
                                           for document in querySnapshot!.documents {
                                               var a = Usuario(d:document)
                                               listaUsuarios.append(a)
                                           }
                                           completion(.success(listaUsuarios))
                                       }
                    }
                }
                else{
                    completion(.success(listaUsuarios))
                }
                } else {
                    print("Document does not exist")
                }

        }
        
    }
}
