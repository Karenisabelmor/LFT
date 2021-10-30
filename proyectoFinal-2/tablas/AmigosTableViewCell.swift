//
//  AmigosTableViewCell.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 27/10/21.
//

import UIKit

class AmigosTableViewCell: UITableViewCell {

    @IBOutlet weak var discord: UILabel!
    @IBOutlet weak var rango: UILabel!
    @IBOutlet weak var usuario: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
