//
//  ConfiguracionViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 31/10/21.
//

import UIKit
import Firebase
import SideMenu
class ConfiguracionViewController: UIViewController {
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Configuración"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(leftHandAction))

        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: UIButton) {
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc
    func leftHandAction() {
        present(menu!, animated: true)
    }
}
