//
//  FriendsViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 24/10/21.
//

import UIKit
import Firebase
import SideMenu
import FirebaseStorage
import FirebaseStorageUI
class FriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating{
    var menu: SideMenuNavigationController?
    let db = Firestore.firestore()
    var datos = [Usuario]()
    let user = Auth.auth().currentUser
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
       
        navigationItem.hidesBackButton = true
        navigationItem.title = "Amigos"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(leftHandAction))

        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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
        let imagePath = "images/\(datosFiltrados[indexPath.row].email).png"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imagePath)
        let cell = friendsList.dequeueReusableCell(withIdentifier: "zelda") as! AmigosTableViewCell
        
        cell.usuario.text =  datosFiltrados[indexPath.row].usuario
        cell.profilePicture.sd_setImage(with: ref)
        cell.rango.text = datosFiltrados[indexPath.row].rango
        cell.discord.text = datosFiltrados[indexPath.row].discord
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var newFriendsList:[String]
            newFriendsList = []
            for amigos in datosFiltrados{
                newFriendsList.append(amigos.email)
            }
            newFriendsList =  newFriendsList.filter{$0 != datosFiltrados[indexPath.row].email}
            let email = user!.email
            let usuario = db.collection("usuarios").document(email!)
            usuario.updateData([
                "amigos": newFriendsList
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                else{
                    print("Agregado")
                }
            }
            let usuarioBorrado = db.collection("usuarios").document(datosFiltrados[indexPath.row].email)
            var usuarioBorradoFriendsList = datosFiltrados[indexPath.row].amigos
            usuarioBorradoFriendsList =  usuarioBorradoFriendsList.filter{$0 != email!}
            usuarioBorrado.updateData([
                "amigos": usuarioBorradoFriendsList
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                else{
                    print("Agregado")
                }
            }
            datosFiltrados.remove(at: indexPath.row)
            friendsList.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
    @objc
    func leftHandAction() {
        present(menu!, animated: true)
    }
}

