//
//  DetalleInterfaceController.swift
//  FuncionalidadAppleWatch WatchKit Extension
//
//  Created by user191334 on 11/28/21.
//

import WatchKit
import Foundation


class DetalleInterfaceController: WKInterfaceController {

    @IBOutlet weak var etiquetaUsuario: WKInterfaceLabel!
    @IBOutlet weak var etiquetaDiscord: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
           super.awake(withContext: context)

           // Configure interface objects here.
           let r = context as! Usuario
           etiquetaUsuario.setText(r.usuario)
           etiquetaDiscord.setText(r.discord)
           
       }

       override func willActivate() {
           // This method is called when watch view controller is about to be visible to user
           super.willActivate()
       }

       override func didDeactivate() {
           // This method is called when watch view controller is no longer visible
           super.didDeactivate()
       }
}
