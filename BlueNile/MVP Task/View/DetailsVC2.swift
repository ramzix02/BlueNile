//
//  DetailsVC2.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/19/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class DetailsVC2: UIViewController {
    
    //Mark: Outlets
    @IBOutlet weak var viewGoldPrice: UIView!
    @IBOutlet weak var viewSeeAll: UIView!
    @IBOutlet weak var detailsCV: UICollectionView!
    @IBOutlet weak var mayBeCV: UICollectionView!
    @IBOutlet weak var btnKnowSize: UIButton!
    @IBOutlet weak var btnAddToBag: UIButton!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var txtProductDesc: UITextView!
    @IBOutlet weak var lblGoldName: UILabel!
    @IBOutlet weak var lblGoldPrice: UILabel!
    
    var presenter: DetailsVCPresenterProtocol?
    var id: Int?
    var productName: String?
    var myProduct: ProductElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DetailsVCPresenter(view: self)
        indicatorSwitch(status: .on, view: view)
        setUpViews()
        presenter?.requestDetails(id: id ?? 0)

    }
    
    func setUpViews() {
        setUpRoundedBtn(btn: btnKnowSize,color: #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1))
        setUpRoundedBtn(btn: btnAddToBag,color: #colorLiteral(red: 0.9019607843, green: 0.8352941176, blue: 0.3176470588, alpha: 1))
        makeRoundedCorners(view: viewGoldPrice)
        makeRoundedCorners(view: viewSeeAll)
        
        detailsCV.dataSource = self
        detailsCV.delegate = self
        mayBeCV.dataSource = self
        mayBeCV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationbar()
    }
    
    func setUpNavigationbar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "back"
        navigationItem.title = productName
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart"), style: .plain, target: self, action:  #selector(cartBarButtonPressed))
    }
    
    @objc private func cartBarButtonPressed(){
            self.view.isUserInteractionEnabled = false
        }
}

