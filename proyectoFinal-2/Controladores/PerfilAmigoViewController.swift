//
//  PerfilAmigoViewController.swift
//  proyectoFinal-2
//
//  Created by user189478 on 10/31/21.
//

import UIKit
import Firebase

class PerfilAmigoViewController: UIViewController {
    @IBOutlet weak var usuario: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var rol: UILabel!
    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var pp: UIImageView!
    var user: Usuario?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usuario.text = user?.usuario
        rango.text = user?.rango
        rol.text = "Sage"
        discord.text = user?.discord
        pp.image = UIImage.init(named: "LFT.png")
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
