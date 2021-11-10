//
//  AgregarAmigosViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 29/10/21.
//

import UIKit
import SideMenu
class AgregarAmigosViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    var menu: SideMenuNavigationController?
    var datos = [Usuario]()
    @IBOutlet weak var agregar: UITableView!
    var datosFiltrados = [Usuario]()
    var controladorA = Agregar()
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
        
        self.agregar.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Amigos"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(leftHandAction))

        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        agregar.dataSource = self
        controladorA.agregarAmigos{ (resultado) in
            switch resultado{
            case .success(let listausuario): self.updateGUI(listaUsuarios:listausuario)
            case .failure(let error):print("error")
            }
            
        }
        searchController.searchResultsUpdater = self
        //paso 7: controlar el background de los datos al momento de hacer la búsqueda
        searchController.dimsBackgroundDuringPresentation = false
        //Paso 8: manejar la barra de navegación durante la busuqeda
        searchController.hidesNavigationBarDuringPresentation = false
        //Paso 9: Instalar la barra de búsqueda en la cabecera de la tabla
       agregar.tableHeaderView = searchController.searchBar
    }
    override func viewDidAppear(_ animated: Bool) {
        controladorA.agregarAmigos{ (resultado) in
            switch resultado{
            case .success(let listausuario):self.updateGUI(listaUsuarios:listausuario )
            case .failure(let error):print("error")
            }
        }
    }
    func updateGUI(listaUsuarios: Usuarios){
        DispatchQueue.main.async {
            self.datos = listaUsuarios
            //paso 5: copiar el contenido del arreglo en el arreglo filtrad
            self.datosFiltrados = listaUsuarios
            self.agregar.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = agregar.dequeueReusableCell(withIdentifier: "agregarAmigo") as! AgregarTableViewCell
        cell.usuario.text =  datosFiltrados[indexPath.row].usuario
        cell.profilePicture.image = UIImage(named: "LFT.png")
        cell.rango.text =  datosFiltrados[indexPath.row].rango
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
extension AgregarAmigosViewController: TableUpdate{
func ReloadTable() {
    controladorA.agregarAmigos{ (resultado) in
        switch resultado{
        case .success(let listausuario): self.updateGUI(listaUsuarios:listausuario)
        case .failure(let error):print("error")
        }
        
    }
    self.agregar.reloadData()
}

    @objc
    func leftHandAction() {
        present(menu!, animated: true)
    }
}
