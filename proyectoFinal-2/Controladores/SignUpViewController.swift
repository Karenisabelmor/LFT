//
//  SignUpViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        if let email = email.text , let password = password.text{        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                self.displayError(e: e)
            }
            else
            {
                self.performSegue(withIdentifier: "signInToFriends", sender: self)
            }
          // ...
        }
        }
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
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
