//
//  PerfilAmigoViewController.swift
//  proyectoFinal-2
//
//  Created by user189478 on 10/31/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import MapKit
class PerfilAmigoViewController: UIViewController {
    private let storage = Storage.storage().reference()
    var controladorMapa = LocationControlador()
    @IBOutlet weak var usuario: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var rol: UILabel!
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var tabla: UIImageView!
    var urlPhoto:String?
    var user: Usuario?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePath = "images/\(user!.email).png"
        let tablePath = "tablas/\(user!.email).png"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imagePath)
        let ref2 = storageRef.child(tablePath)
      controladorMapa.getLocation(servidor:user!.pais){ (resultado) in
            switch resultado{
            case .success(let location):
                let centro = CLLocationCoordinate2DMake(location.latitud, location.longitud)
                self.mapa.region = MKCoordinateRegion(center:centro,
                latitudinalMeters: 10000,longitudinalMeters: 10000)
                let pin = MKPointAnnotation()
                pin.coordinate = centro
                pin.title = self.user?.pais
                self.mapa.addAnnotation(pin)
            case .failure(let error):print("error")
            }
        }
        usuario.text = user?.usuario
        
        rango.text = user?.rango
        rol.text = user?.rol
        horario.text = "Horario: \(user!.horario)"
        discord.text = user?.discord
        pp.sd_setImage(with: ref)
        tabla.sd_setImage(with: ref2)
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

}
