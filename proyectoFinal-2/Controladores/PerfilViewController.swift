//
//  PerfilViewController.swift
//  proyectoFinal-2
//
//  Created by user189478 on 10/31/21.
//

import UIKit
import Firebase
import SideMenu
import FirebaseStorage
import FirebaseStorageUI
import MapKit
class PerfilViewController: UIViewController {
    var menu: SideMenuNavigationController?
    var controladorMapa = LocationControlador()
    let db = Firestore.firestore()
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var rol: UILabel!
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePath = "images/\(user!.email!).png"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imagePath)
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
                self.controladorMapa.getLocation(servidor:datosUsuario.pais){ (resultado) in
                    switch resultado{
                    case .success(let location):
                        let centro = CLLocationCoordinate2DMake(location.latitud, location.longitud)
                        self.mapa.region = MKCoordinateRegion(center:centro,
                        latitudinalMeters: 10000,longitudinalMeters: 10000)
                        let pin = MKPointAnnotation()
                        pin.coordinate = centro
                        pin.title = datosUsuario.pais
                    case .failure(let error):print("error")
                    }
                }
                self.username.text = datosUsuario.usuario
                self.rango.text = datosUsuario.rango
                self.rol.text = datosUsuario.rol
                self.discord.text = datosUsuario.discord
                self.pp.sd_setImage(with: ref)
                self.navigationItem.title = datosUsuario.usuario
                self.horario.text = "Horario: \(datosUsuario.horario)"
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
