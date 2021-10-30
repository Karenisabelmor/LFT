//
//  agregar.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.
//
import Firebase
class Agregar{
    let db = Firestore.firestore()
    
    func agregarAmigos(completion: @escaping (Result<[Usuario],Error>)->Void){
        var listaUsuarios = [Usuario]()
        let user = Auth.auth().currentUser
        let email = user!.email
        let usuario = db.collection("usuarios").document(email!)
        usuario.getDocument{(document,error) in
            if let document = document, document.exists {
                var  datosUsuario = Usuario(d:document)
                if(datosUsuario.amigos.count == 0)
                {
                    self.db.collection("usuarios").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    var a = Usuario(d:document)
                                    if(a.usuario != datosUsuario.usuario)
                                    {
                                        listaUsuarios.append(a)
                                    }
                                }
                                completion(.success(listaUsuarios))
                            }
                    }
                }
                else
                {
                    self.db.collection("usuarios").whereField("email", notIn: datosUsuario.amigos )
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    var a = Usuario(d:document)
                                    if(a.usuario != datosUsuario.usuario)
                                    {
                                        listaUsuarios.append(a)
                                    }
                                    
                                }
                                completion(.success(listaUsuarios))
                            }
                    }
                }
               
            }
            else {
                print("error")
            }
        }
    }
    
    func enviarSolicitud(destino:String, completion: @escaping (Result<String,Error>)->Void){
        let user = Auth.auth().currentUser
        var usuario = [Usuario]()
        let email = user!.email
        db.collection("usuarios").whereField("usuario", isEqualTo:destino).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    usuario.append(Usuario(d:document))
                }
                let destinatario = self.db.collection("invitaciones").document(usuario[0].email)
                        destinatario.getDocument{(document,error) in
                            if let document = document, document.exists {
                                var datosDestino = Invitacion(d:document)
                                var solicitudesPendientes = datosDestino.pendientes
                                solicitudesPendientes.append(email!)
                                destinatario.updateData([
                                    "pendientes": solicitudesPendientes
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    }
                                    else{
                                        completion(.success("Agregado"))
                                    }
                                }
                            }
                            else{
                                print ("error")
                            }
                        }
            }
    }

    }
   
}
