//
//  DetailsVCPresenter.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/19/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation
protocol DetailsVCPresenterProtocol  {
    func requestDetails(id: Int)
    func requestFav(id: Int, indexPath: IndexPath)
    func getArrImagesCount() -> Int
    func getArrProductsCount() -> Int
    func getArrImagesItem(index: Int) -> Image?
    func getArrProductsItem(index: Int) -> ProductElement?
    
}

class DetailsVCPresenter : DetailsVCPresenterProtocol {
    
    private var urlFav: String = "http://bluenilekw.com/api/favourite_action/"
    private let auth: String = getAuthUser()
    private var url: String?
    private var arrImages: [Image]?
    private var arrProducts: [ProductElement]?
    
    private weak var view: DetailsVC2ViewProtocol?
    
    init(view: DetailsVC2ViewProtocol) {
        self.view = view
    }
    
    func getArrImagesCount() -> Int {
           arrImages?.count ?? 0
       }
       
    func getArrProductsCount() -> Int {
           arrProducts?.count ?? 0
       }
       
    func getArrImagesItem(index: Int) -> Image? {
           return arrImages?[index]
       }
       
    func getArrProductsItem(index: Int) -> ProductElement? {
           return arrProducts?[index]
       }
    
    func requestDetails(id: Int) {
        url = "http://bluenilekw.com/api/product/\(id)"
        arrImages = [Image]()
        arrProducts = [ProductElement]()
        excuteRequest()
    }
    

    private func excuteRequest() {
    NetworkHandler.excuteDetailsRequest(url: url ?? "",auth: auth,lang: "en"){
            
        detailsModel , error in

        self.view?.switchIndecator(status: .off)
        
            let status = detailsModel?.status ?? 0
            let msg = detailsModel?.message ?? ""
            
            let goldName = detailsModel?.data.gold.name ?? ""
            let goldPrice = detailsModel?.data.gold.price ?? ""
            let productName = detailsModel?.data.product.name ?? ""
            let productPrice = detailsModel?.data.product.price ?? 0
            let productDesc = detailsModel?.data.product.desc ?? ""
        
            self.arrImages = detailsModel?.data.product.images
            self.arrProducts = detailsModel?.data.products
            
        if(status == 1){
            self.view?.UpdateUI(goldName: goldName, goldPrice: goldPrice, productName: productName, productPrice: productPrice, productDesc: productDesc)

        }else{
            self.view?.showErrorMsg(msg: msg) 
            return
        }
        
        if(error != nil){
            self.view?.showToastMsg(msg: "Error")
        }
        self.view?.reloadCollectionViews()
        }
    }
    
    func requestFav(id: Int, indexPath: IndexPath) {
        let myURLFav = "\(urlFav)"+"\(id)"
        NetworkHandler.RequestFavourite(url: myURLFav,auth: auth,lang: "en"){
            
        favModel , error in
        
        let status = favModel?.status ?? 0
        let msg = favModel?.message ?? ""
            
        if(status == 1){
            self.view?.showToastMsg(msg: msg)
            self.excuteRequest()
        }else{
            self.view?.showErrorMsg(msg: msg)
            return
        }
        
        if(error != nil){
            self.view?.showToastMsg(msg: error?.localizedDescription ?? "")
        }
    }
    }
   
}
