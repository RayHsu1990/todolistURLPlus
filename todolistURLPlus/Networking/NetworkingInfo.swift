//
//  NetworkingInfo.swift
//  todolistURLPlus
//
//  Created by Ray Hsu on 2020/9/3.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import Foundation


enum HTTPMethod:String{
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint:String {
    case userToken
    case register
    case task
    case card
    case user
    case userImage = "user/image"
    case groups
    case groupsCard = "groups/card/users"
}

enum ContentType:String{
    case json = "application/json"
    case formData = "multipart/form-data"
}


//MARK:- Token
struct UserToken {
    private(set) var userToken = ""
    private init(){}
    static var shared = UserToken()
    
    ///拿token 如果沒有的話 回傳nil
    static func getToken() -> String?{
        guard let tokenFromUserDefault = UserDefaults.standard.string(forKey: "token") else {return nil}
        let token = tokenFromUserDefault.isEmpty ? nil : tokenFromUserDefault
        return token
    }
    
    private static func updateTokenToUserdefault(with token:String){
        UserDefaults.standard.set(token, forKey: "token")
    }

    
    mutating func updateToken(by token: String){
        userToken = token
        print(userToken)
//        updateTokenToUserdefault(with: token)
    }
    mutating func clearToken(){
        userToken = ""
        print("Token cleared")
//        updateTokenToUserdefault(with: "")
    }
    
    
}
