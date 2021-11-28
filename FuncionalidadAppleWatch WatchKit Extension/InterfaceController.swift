//
//  InterfaceController.swift
//  FuncionalidadAppleWatch WatchKit Extension
//
//  Created by user191334 on 11/27/21.
//

import WatchKit
import Foundation
import Firebase


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var laTabla: WKInterfaceTable!
    
    
    var datos = [Usuario]()
        var usuarioControlador = ControladorDatos()

        func updateGUI(lista_usuarios: [Usuario]){
                DispatchQueue.main.async {
                    self.datos = lista_usuarios
                    self.laTabla.setNumberOfRows(self.datos.count, withRowType: "renglones")
                    for indice in 0 ..< self.datos.count {
                        let elRenglon=self.laTabla.rowController(at: indice) as! ControladorRenglon
                        elRenglon.etiquetaAmix.setText(self.datos[indice].usuario)

                    }
                }

            }
        func displayError(e:Error){
                DispatchQueue.main.async {
                    print(e)
                }
            }
        override func awake(withContext context: Any?) {
            // Configure interface objects here.
            usuarioControlador.fetchUsuario{ (resultado) in
                switch resultado{
                case .success(let lista_usuarios):self.updateGUI(lista_usuarios: lista_usuarios)
                case .failure(let error):self.displayError(e: error)
                }
        }



        }

        override func willActivate() {
            // This method is called when watch view controller is about to be visible to user

        }

        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
        }

        override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
            let usuarioContexto = datos[rowIndex]
            return usuarioContexto
        }
    
}
