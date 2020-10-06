//
//  Manager.swift
//  todolistURLPlus
//
//  Created by Ray Hsu on 2020/9/15.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class NetworkManager{
    
//    static let shared = NetworkManager()
//    private init(){}
        
    var delegate : RefreshTokenDelegate?
    
    func sendRequest<T:Codable>(with request: URLRequest, completion: @escaping (Result<T,NetworkError>) -> Void){
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async{
                if error != nil { completion(.failure(.systemError)) }
                
                guard let response = response as? HTTPURLResponse else { completion(.failure(.noResponse))
                    return
                }
                guard let data = data else { completion(.failure(.noData))
                    return
                }
                self.responseHandler(data: data, response: response, completion: completion)
            }
        }
        task.resume()
    }
    
    private func responseHandler<T:Codable>
        (data:Data, response:HTTPURLResponse, completion:@escaping (Result<T,NetworkError>) -> Void){
        
        switch response.statusCode {
        case 200 ... 299:
            do{
                let decotedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decotedData))
                print("============= \(T.self) success ==============")
                
            }catch{
                print("======================== Decode Error ========================")
                print(error,"statuscode:\(response.statusCode)")
                completion(.failure(.decodeError(struct: "\(T.self)")))
            }
        case 401 , 403:
//            #warning("refresh token")
            completion(.failure(.refreshToken))
            delegate?.shouldRefreshToken()
        default:
            do{
                let decodedError = try JSONDecoder().decode(ErrorData.self, from: data)
                completion(.failure(.responseError(error: decodedError, statusCode: response.statusCode)))
            }catch{
                print("錯誤訊息decode失敗,status code:\(response.statusCode)")
                completion(.failure(.decodeError(struct: "\(ErrorData.self)")))
            }
        }
    }
    
}

protocol LoadingViewDelegate {
    func loading()
    
    func stopLoading()
}

extension UIViewController: RefreshTokenDelegate {
    func shouldRefreshToken() {
        present(.makeAlert("逾時", "請重新登入", {
            let vc = LoginVC.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return nil
        }) ,animated: true)
    }
    
}
