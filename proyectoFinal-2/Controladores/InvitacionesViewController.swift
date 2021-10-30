//
//  InvitacionesViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.
//

import UIKit

class InvitacionesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    var datos = [Usuario]()
    var controlador = UsuarioControlador()
    var datosFiltrados = [Usuario]()
    @IBOutlet weak var invitaciones: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            datosFiltrados = datos
        } else {
            // Filtrar los resultados de acuerdo al texto escrito en la caja que es obtenido a través del parámetro $0
            //$0 es un objeto tipo Raza
            datosFiltrados = datos.filter{
                let s:String = $0.usuario
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        }
        
        self.invitaciones.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        controlador.fetchInvitaciones{ (resultado) in
            switch resultado{
            case .success(let listausuario):self.updateGUI(listaUsuarios:listausuario )
            case .failure(let error):print("error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        invitaciones.dataSource = self
        controlador.fetchInvitaciones{ (resultado) in
            switch resultado{
            case .success(let listausuario): self.updateGUI(listaUsuarios:listausuario )
            case .failure(let error):print("error")
            }
            
        }
        searchController.searchResultsUpdater = self
        //paso 7: controlar el background de los datos al momento de hacer la búsqueda
        searchController.dimsBackgroundDuringPresentation = false
        //Paso 8: manejar la barra de navegación durante la busuqeda
        searchController.hidesNavigationBarDuringPresentation = false
        //Paso 9: Instalar la barra de búsqueda en la cabecera de la tabla
       invitaciones.tableHeaderView = searchController.searchBar
        // Do any additional setup after loading the view.
    }
    func updateGUI(listaUsuarios: Usuarios){
        DispatchQueue.main.async {
            self.datos = listaUsuarios
            //paso 5: copiar el contenido del arreglo en el arreglo filtrad
            self.datosFiltrados = listaUsuarios
            self.invitaciones.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = invitaciones.dequeueReusableCell(withIdentifier: "invitacion") as! InvitacionesTableViewCell
        cell.username.text =  datosFiltrados[indexPath.row].usuario
        cell.profilePicture.image = UIImage(named: "LFT.png")
        cell.rango.text = datosFiltrados[indexPath.row].rango
        cell.discord.text = datosFiltrados[indexPath.row].discord
        cell.parentDelegate = self
        return cell
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
extension InvitacionesViewController: ParentControllerDelegate{
func requestReloadTable() {
    controlador.fetchInvitaciones{ (resultado) in
        switch resultado{
        case .success(let listausuario):self.updateGUI(listaUsuarios:listausuario )
        case .failure(let error):print("error")
        }
    }
    self.invitaciones.reloadData()
}
}
