//
//  NetworkHandler.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/15/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler  {

    static func loginORRegister(url: String,userDic: [String : String], completionHandler: @escaping(UserModel?, Error?)-> Void){
                
        AF.request(url, method: .post, parameters:
            userDic)
            .responseJSON{ (response) in
            do{
                 if(response.data != nil){
                    
                    let userModel = try JSONDecoder().decode(UserModel.self, from: response.data!)
                
                    completionHandler(userModel,nil)
                 }
                 else if((response.error) != nil){
                    completionHandler(nil,response.error)
                }
            }
            catch{
                print(error.localizedDescription)
                }
            }
        }
    

    static func excuteHomeRequest(url: String,auth: String,lang: String, completionHandler: @escaping(HomeModel?, Error?)-> Void){
    
        AF.request(url, method: .get, headers: [
            "Auth":auth,
            "Lang":lang
        ])
        .responseJSON{ (response) in
        do{
             if(response.data != nil){
                                
                let homeModel = try JSONDecoder().decode(HomeModel.self, from: response.data!)
                
                completionHandler(homeModel,nil)
             }
             else if((response.error) != nil){
                completionHandler(nil,response.error)
            }
        }
        catch{
            print(error.localizedDescription)
            }
        }
    }
    
    static func excuteDetailsRequest(url: String,auth: String,lang: String, completionHandler: @escaping(Details?, Error?)-> Void){
    
        AF.request(url, method: .get, headers: [
            "Auth":auth,
            "Lang":lang
        ])
        .responseJSON{ (response) in
        do{
             if(response.data != nil){
                                
                let detailsModel = try JSONDecoder().decode(Details.self, from: response.data!)
            
                completionHandler(detailsModel,nil)
             }
             else if((response.error) != nil){
                completionHandler(nil,response.error)
            }
        }
        catch{
            print(error.localizedDescription)
            }
        }
    }
    
    static func RequestFavourite(url: String, auth: String,lang: String, completionHandler: @escaping(FavouriteModel?, Error?)-> Void){
    
    AF.request(url, method: .post,headers: [
        "Auth":auth,
        "Lang":lang
    ])
        .responseJSON{ (response) in
        do{
             if(response.data != nil){
                
                let favModel = try JSONDecoder().decode(FavouriteModel.self, from: response.data!)
            
                completionHandler(favModel,nil)
             }
             else if((response.error) != nil){
                completionHandler(nil,response.error)
            }
        }
        catch{
            print(error.localizedDescription)
            }
        }
    }
    
}

