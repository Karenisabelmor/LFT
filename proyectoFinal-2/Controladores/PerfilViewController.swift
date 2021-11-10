//
//  PerfilViewController.swift
//  proyectoFinal-2
//
//  Created by user189478 on 10/31/21.
//

import UIKit
import Firebase
import SideMenu
class PerfilViewController: UIViewController {
    var menu: SideMenuNavigationController?
    let db = Firestore.firestore()
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var rol: UILabel!
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var pp: UIImageView!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()//        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
//                  let url = URL(string: urlString) else{
//                      return
//            }
//            URLSession.shared.dataTask(with: url, completionHandler: {data,_ , error in
//                guard let data = data , error == nil else{
//                    return
//                }
//                let image = UIImage(data:data)
//                self.pp.image = image
//            })
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(leftHandAction))

        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        let email = user!.email
        let usuario = db.collection("usuarios").document(email!)
        usuario.getDocument{(document,error) in
            if let document = document, document.exists {
                var  datosUsuario = Usuario(d:document)
                self.username.text = datosUsuario.usuario
                self.rango.text = datosUsuario.rango
                self.rol.text = "Sage"
                self.discord.text = datosUsuario.discord
                self.pp.image = UIImage.init(named: "LFT.png")
                self.navigationItem.title = datosUsuario.usuario
            }
            
        }
        
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc
    func leftHandAction() {
        present(menu!, animated: true)
    }
}
