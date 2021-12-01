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
import FirebaseDatabase

class PerfilViewController: UIViewController {
    var menu: SideMenuNavigationController?
    var controladorMapa = LocationControlador()
    let db = Firestore.firestore()
    
    var ref: DatabaseReference!

    
    
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var rol: UILabel!
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var tabla: UIImageView!
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePath = "images/\(user!.email!).png"
        let tablePath = "tablas/\(user!.email!).png"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imagePath)
        let ref2 = storageRef.child(tablePath)
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
                        self.mapa.addAnnotation(pin)
                    case .failure(let error):print("error")
                    }
                }
                self.username.text = datosUsuario.usuario
                self.rango.text = datosUsuario.rango
                self.rol.text = datosUsuario.rol
                self.discord.text = datosUsuario.discord
                self.pp.sd_setImage(with: ref)
                self.tabla.sd_setImage(with: ref2)
                self.navigationItem.title = datosUsuario.usuario
                self.horario.text = "Horario: \(datosUsuario.horario)"
                
                
                self.ref = Database.database().reference()
                self.ref.child("Usuarios").setValue(["Usuario": String(datosUsuario.usuario),  "Discord": String(datosUsuario.discord), "Rango": String(datosUsuario.rango)]) {
                              (error:Error?, ref:DatabaseReference) in
                              if let error = error {
                                print("Data could not be saved: \(error).")
                              } else {
                                print("Data saved successfully!")
                              }
                            }
                
                
                
                
                
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
