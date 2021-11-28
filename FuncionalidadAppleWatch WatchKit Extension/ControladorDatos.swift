import Foundation
import Firebase

class ControladorDatos{

    func fetchUsuario(completion: @escaping (Result<[Usuario],Error>)->Void){

        var lista_usuarios = [Usuario]()


        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Dictionary<String,String>]{
            let dic = data["Usuarios"]!
            for (k,v) in dic{
                let r = Usuario(usuario: k,discord: v, rango: k)
                lista_usuarios.append(r)
            }
            completion(.success(lista_usuarios))
    }

        }){
            (error) in
            completion(.failure(error))
            print(error.localizedDescription)
        }

    }
}
