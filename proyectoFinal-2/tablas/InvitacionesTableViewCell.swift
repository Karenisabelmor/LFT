//
//  InvitacionesTableViewCell.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.
//

import UIKit
import Firebase
protocol ParentControllerDelegate{
func requestReloadTable()
}
class InvitacionesTableViewCell: UITableViewCell {
    let db = Firestore.firestore()
    var controlador = UsuarioControlador()
    var parentDelegate: ParentControllerDelegate?
    var usuarioB:String = ""
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addFriend(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let email = user!.email
        let usuarioAgregar = db.collection("usuarios").whereField("usuario", isEqualTo: username.text!)
        usuarioAgregar.getDocuments{(querySnapshot,error) in
            if let e = error{
    
            }
            else{
                for document in querySnapshot!.documents{
                    var a = Usuario(d:document)
                    self.usuarioB = a.email
                }
                let usuario = self.db.collection("usuarios").document(email!)
                usuario.getDocument{(document,error) in
                    if let document = document, document.exists {
                            var doc = Usuario(d:document)
                            var amigos = doc.amigos
                        amigos.append(self.usuarioB)
                            usuario.updateData([
                                "amigos": amigos
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                }
                            }
                        let pendientes = self.db.collection("invitaciones").document(email!)
                            pendientes.getDocument{(document,error) in
                                if let document = document, document.exists {
                                    var pending = Invitacion(d:document)
                                    var newPendingList = pending.pendientes
                                    newPendingList = newPendingList.filter{ $0 != self.usuarioB}
                                    pendientes.updateData([
                                        "pendientes": newPendingList
                                    ]) { err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                        }
                                    }
                                    self.parentDelegate?.requestReloadTable()
                                }
                                else
                                {
                                    print("document not found")
                                }
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                
                }
            }
        }
        

          
    }
    @IBAction func rejectFriend(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let email = user!.email
        let usuarioAgregar = db.collection("usuarios").whereField("usuario", isEqualTo: username.text!)
        usuarioAgregar.getDocuments{(querySnapshot,error) in
            if let e = error{
               
            }
            else{
                for document in querySnapshot!.documents{
                    var a = Usuario(d:document)
                    self.usuarioB = a.email
                }
                let pendientes = self.db.collection("invitaciones").document(email!)
                    pendientes.getDocument{(document,error) in
                        if let document = document, document.exists {
                            var pending = Invitacion(d:document)
                            var newPendingList = pending.pendientes
                            newPendingList = newPendingList.filter{ $0 != self.usuarioB}
                            pendientes.updateData([
                                "pendientes": newPendingList
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                }
                            }
                            self.parentDelegate?.requestReloadTable()
                        }
                        else
                        {
                            print("document not found")
                        }
                    }
            }
        }
       
    }
}


