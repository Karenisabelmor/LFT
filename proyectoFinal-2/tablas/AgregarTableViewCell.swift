//
//  AgregarTableViewCell.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.
//

import UIKit
protocol TableUpdate{
func ReloadTable()
}
class AgregarTableViewCell: UITableViewCell {
    var controlador  = Agregar()
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var usuario: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    var tableupdater: TableUpdate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addFriend(_ sender: UIButton) {
        print("add")
        controlador.enviarSolicitud(destino:usuario.text!){(resultado) in
            switch resultado{
            case .failure(let error):
                print(error)
            case .success(let exito):
                print(exito)
            }
        }
        self.tableupdater?.ReloadTable()
    }
}
