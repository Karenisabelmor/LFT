//
//  LoginViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    var controlador = UsuarioControlador()
    @IBOutlet weak var Discord: UITextField!
    @IBOutlet weak var rango: UITextField!
    @IBOutlet weak var idJuego: UITextField!
    @IBOutlet weak var pais: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var usuario: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerUser(_ sender: UIButton) {
        if let email = email.text , let password = password.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if  let e = error {
                   self.displayError(e: e)
               }
                else
                {
                    let nuevoUsuario = Usuario(discord: self.Discord.text!, email: email, idJuego: self.idJuego.text!, pais: self.pais.text!, password: password ,rango: self.rango.text!, usuario: self.usuario.text!)
                    self.controlador.addUsuario(nuevoUsuario: nuevoUsuario){(resultado) in
                        switch resultado{
                        case .failure(let error):
                            self.displayError(e: error)
                        case .success(let exito):
                            self.performSegue(withIdentifier: "registerToFriends", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    func displayExito(exito:String ){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Se agrego el usuario", message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
