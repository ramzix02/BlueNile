//
//  DetailsVC2Extension.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/20/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//
import Foundation

protocol DetailsVC2ViewProtocol : class {
    func UpdateUI(goldName: String, goldPrice: String, productName: String, productPrice: Int, productDesc: String)
    func reloadCollectionViews()
    func switchIndecator(status: IndicatorSwitch)
    func showErrorMsg(msg: String)
    func showToastMsg(msg: String)
}

