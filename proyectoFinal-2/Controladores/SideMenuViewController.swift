//
//  SideMenuViewController.swift
//  proyectoFinal-2
//
//  Created by Luis Alcantara on 09/11/21.
//
import SideMenu
import UIKit

class SideMenuViewController: UIViewController {
    var menu: SideMenuNavigationController?
    var controlador = MenuListController()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        menu = SideMenuNavigationController(rootViewController: controlador)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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
    @IBAction func didTapMenu() {
        present(menu!, animated: true)
    }
    
}

