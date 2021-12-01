//
//  ViewController.swift
//  fotosS4
//
//  Created by Rodrigo y los regaños de Karen on 11/7/17.
//
//

import UIKit
import CoreML
import Vision
import SideMenu
//ML solo funciona a partir de iOS 11
@available(iOS 11.0, *)
class MlmAgentesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    

    @IBOutlet weak var identificacionImagen: UILabel!
    
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        miPicker.delegate = self
        navigationItem.hidesBackButton = true
        navigationItem.title = "Agentes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(leftHandAction))
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }


    @IBAction func ejecutarML() {
        //instanciar el modelo de la red neuronal
        let modelFile = AgentesClassifier_1()
        let model = try! VNCoreMLModel(for: modelFile.model)
        //Convertir la imagen obtenida a CIImage
        let imagenCI = CIImage(image: fotoVista.image!)
        //Crear un controlador para el manejo de la imagen, este es un requerimiento para ejecutar la solicitud del modelo
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        //Crear una solicitud al modelo para el análisis de la imagen
        let request = VNCoreMLRequest(model: model, completionHandler: resultadosModelo)
        try! handler.perform([request])
        
    }
    
    func resultadosModelo(request: VNRequest, error: Error?)
    {
        guard let results = request.results as? [VNClassificationObservation] else { fatalError("No hubo respuesta del modelo ML")}
        var bestPrediction = ""
        var y = 0.0
        var bestConfidence: VNConfidence = 0
        //recorrer todas las respuestas en búsqueda del mejor resultado
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                y = Double((bestConfidence * 100).rounded())
                bestPrediction = classification.identifier
            }
        }
        let resultado = bestPrediction+" "+String(y) + "%"
        print(resultado)
        identificacionImagen.text = resultado
    }
    
    
    @IBAction func camara() {
        miPicker.sourceType = UIImagePickerController.SourceType.camera
        present(miPicker, animated: true, completion: nil)
    }
    
    @IBAction func album() {
        miPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            fotoVista.contentMode = .scaleAspectFit
            fotoVista.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func leftHandAction() {
        present(menu!, animated: true)
    }
}

