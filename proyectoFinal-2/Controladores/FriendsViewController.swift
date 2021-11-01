//
//  FriendsViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import UIKit
import Firebase
class FriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating{
    
    var datos = [Usuario]()
    var controlador = UsuarioControlador()
    @IBOutlet weak var friendsList: UITableView!
    var datosFiltrados = [Usuario]()
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
        
        self.friendsList.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        controlador.fetchFriends{ (resultado) in
            switch resultado{
            case .success(let listausuario):self.updateGUI(listaUsuarios:listausuario )
            case .failure(let error):print("error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        friendsList.dataSource = self
        controlador.fetchFriends{ (resultado) in
            switch resultado{
            case .success(let listausuario):self.updateGUI(listaUsuarios:listausuario )
            case .failure(let error):print("error")
            }
        }
        searchController.searchResultsUpdater = self
        //paso 7: controlar el background de los datos al momento de hacer la búsqueda
        searchController.dimsBackgroundDuringPresentation = false
        //Paso 8: manejar la barra de navegación durante la busuqeda
        searchController.hidesNavigationBarDuringPresentation = false
        //Paso 9: Instalar la barra de búsqueda en la cabecera de la tabla
       friendsList.tableHeaderView = searchController.searchBar

        // Do any additional setup after loading the view.
    }
  
    func updateGUI(listaUsuarios: Usuarios){
        DispatchQueue.main.async {
            self.datos = listaUsuarios
            //paso 5: copiar el contenido del arreglo en el arreglo filtrad
            self.datosFiltrados = listaUsuarios
            self.friendsList.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsList.dequeueReusableCell(withIdentifier: "zelda") as! AmigosTableViewCell
        cell.usuario.text =  datosFiltrados[indexPath.row].usuario
        cell.profilePicture.image = UIImage(named: "LFT.png")
        cell.rango.text = datosFiltrados[indexPath.row].rango
        cell.discord.text = datosFiltrados[indexPath.row].discord
        return cell
    }
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let siguiente = segue.destination as! PerfilAmigoViewController
            let indice = self.friendsList.indexPathForSelectedRow?.row
            //paso 12 usar datos filtrados
            siguiente.user = datosFiltrados[indice!]
        
    }
    

}
