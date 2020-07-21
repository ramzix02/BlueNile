//
//  DetailsVCProtocolConform.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/20/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation

extension DetailsVC2: DetailsVC2ViewProtocol{
    
    func UpdateUI(goldName: String, goldPrice: String, productName: String, productPrice: Int, productDesc: String) {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
            self.lblGoldName.text = goldName
            self.lblGoldPrice.text = goldPrice
            self.lblProductName.text = productName
            self.lblProductPrice.text = "\(productPrice ) KWD"
            self.txtProductDesc.text = productDesc
        }
    }
    
    func reloadCollectionViews() {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
            self.detailsCV.reloadData()
            self.mayBeCV.reloadData()
        }
    }
    
    func switchIndecator(status: IndicatorSwitch) {
        if status == .on{
            indicatorSwitch(status: .on,view: self.view)
        }else{
            indicatorSwitch(status: .off,view: self.view)
        }
    }
    
    func showErrorMsg(msg: String) {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
        let alert = showErrorAlert(title: "Wrong!", errorMessage: msg)
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showToastMsg(msg: String){
        DispatchQueue.main.async { [weak self] in
        guard let self = self else{return}
        showToast(message: msg, view: self.view)
        }
    }
}
