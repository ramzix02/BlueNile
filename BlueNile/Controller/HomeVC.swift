//
//  HomeVC.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/16/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class HomeVC: UIViewController {

    @IBOutlet weak var viewSeeAll: UIView!
    @IBOutlet weak var viewGoldPrice: UIView!
    @IBOutlet weak var bestSellerCV: UICollectionView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var offerCV: UICollectionView!
    @IBOutlet weak var newCollectionCV: UICollectionView!
    @IBOutlet weak var lblGoldName: UILabel!
    @IBOutlet weak var lblGoldPrice: UILabel!
    
    private let url: String = "http://bluenilekw.com/api/home_screen"
    private var urlFav: String = "http://bluenilekw.com/api/favourite_action/"
    
    private var activityInd = UIActivityIndicatorView()
    private let auth: String = getAuthUser()

    private var arrCategories: [Category]?
    private var arrMostSeller: [MostSeller]?
    private var arrOffers: [MostSeller]?
    private var arrNewCollection: [MostSeller]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initArrays()
        indicatorSwitch(status: .on, view: view)
        requestHome()
        setUpViews()
    }
    
    func initArrays() {
        arrCategories = [Category]()
        arrMostSeller = [MostSeller]()
        arrOffers = [MostSeller]()
        arrNewCollection = [MostSeller]()
    }
    
    func setUpViews(){
        makeRoundedCorners(view: viewSeeAll)
        makeRoundedCorners(view: viewGoldPrice)
        
        categoryCV.delegate = self
        categoryCV.dataSource = self
        
        bestSellerCV.delegate = self
        bestSellerCV.dataSource = self
        
        offerCV.delegate = self
        offerCV.dataSource = self
        
        newCollectionCV.delegate = self
        newCollectionCV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
           setUpNavigationBar()
       }

    func setUpNavigationBar(){
            
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Optima", size: 22)!, NSAttributedString.Key.foregroundColor: themeColor]
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = themeColor
        navigationItem.leftBarButtonItem=nil;
        navigationItem.hidesBackButton=true;
        navigationItem.title = "Blue Nile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart"), style: .plain, target: self, action:  #selector(cartBarButtonPressed))
    }
    
    @objc private func cartBarButtonPressed(){
        self.view.isUserInteractionEnabled = false
    }
    
    func requestHome() {

        NetworkHandler.excuteHomeRequest(url: url,auth: auth,lang: "en"){
            
        homeModel , error in

        indicatorSwitch(status: .off,view: self.view)
        
        let status = homeModel?.status ?? 0
        let msg = homeModel?.message ?? ""
            
        let goldName = homeModel?.data.gold.name
        let goldPrice = homeModel?.data.gold.price
            
        self.arrCategories = homeModel?.data.categories
        self.arrMostSeller = homeModel?.data.mostSeller
        self.arrOffers = homeModel?.data.offers
        self.arrNewCollection = homeModel?.data.newCollection
            
        if(status == 1){
            self.lblGoldName.text = goldName
            self.lblGoldPrice.text = goldPrice
        }else{
            let alert = showErrorAlert(title: "Wrong!", errorMessage: msg)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(error != nil){
            showToast(message: "ERROR", view: self.view)
        }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else{return}
                self.categoryCV.reloadData()
                self.bestSellerCV.reloadData()
                self.offerCV.reloadData()
                self.newCollectionCV.reloadData()
            }
        }
    }
    
    func requestFav(id: Int) {
        let myURLFav = "\(urlFav)"+"\(id)"
        NetworkHandler.RequestFavourite(url: myURLFav,auth: auth,lang: "en"){
            
        favModel , error in
        
        let status = favModel?.status ?? 0
        let msg = favModel?.message ?? ""
            
        if(status == 1){
            showToast(message: msg, view: self.view)
            self.requestHome()
        }else{
            let alert = showErrorAlert(title: "Wrong!", errorMessage: msg)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(error != nil){
            showToast(message: "ERROR", view: self.view)
        }
        }
    }
}


extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bestSellerCV:
                return arrMostSeller?.count ?? 0
                    
        case offerCV:
                return arrOffers?.count ?? 0
                    
        case newCollectionCV:
                return arrNewCollection?.count ?? 0
                    
        default:
                return arrCategories?.count ?? 0
                    
        }
        
    }
    
    @objc func bestSellerFav(_ sender: UIButton)
    {
        let indexPath = bestSellerCV?.indexPath(for: ((sender.superview?.superview) as! BestSellerCVCell))

        guard let id = arrMostSeller?[indexPath?.row ?? 0].id else { return }
        requestFav(id: id)
    }
    @objc func offersFav(_ sender: UIButton)
    {
        let indexPath = offerCV?.indexPath(for: ((sender.superview?.superview) as! OfferCVCell))

        guard let id = arrOffers?[indexPath?.row ?? 0].id else { return }
        requestFav(id: id)
    }
    @objc func newCollectionsFav(_ sender: UIButton)
    {
        let indexPath = newCollectionCV?.indexPath(for: ((sender.superview?.superview) as! NewCollectionCVCell))

        guard let id = arrNewCollection?[indexPath?.row ?? 0].id else { return }
        requestFav(id: id)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case bestSellerCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCV", for: indexPath) as! BestSellerCVCell
                 
                let url = URL(string :arrMostSeller?[indexPath.row].image ?? "")

                 cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
                 cell.lblProduct?.text = arrMostSeller?[indexPath.row].name
                 cell.lblPrice?.text = arrMostSeller?[indexPath.row].price
               
                 cell.btnFav.addTarget(self, action: #selector(bestSellerFav(_:)), for: .touchUpInside)
                
                if arrMostSeller?[indexPath.row].favourite == 1 {
                    cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav2")
                }else{
                    cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav")
                }
               
                return cell
                    
        case offerCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCVCell", for: indexPath) as! OfferCVCell
                 
                
                 let url = URL(string :arrOffers?[indexPath.row].image ?? "")

                  cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
                  cell.lblProduct?.text = arrOffers?[indexPath.row].name
                  cell.lblPrice?.text = arrOffers?[indexPath.row].offerPrice
                  cell.lblOldPrice?.text = arrOffers?[indexPath.row].price
                  
                  cell.btnFav.addTarget(self, action: #selector(offersFav(_:)), for: .touchUpInside)
                
                  if arrOffers?[indexPath.row].favourite == 1 {
                      cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav2")
                  }else{
                      cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav")
                  }
                     return cell
                    
        case newCollectionCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCollectionCV", for: indexPath) as! NewCollectionCVCell
                 
                
                 let url = URL(string :arrNewCollection?[indexPath.row].image ?? "")

                  cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
                  cell.lblProduct?.text = arrNewCollection?[indexPath.row].name
                  cell.lblPrice?.text = arrNewCollection?[indexPath.row].price
                
                  cell.btnFav.addTarget(self, action: #selector(newCollectionsFav(_:)), for: .touchUpInside)
                
                 if arrNewCollection?[indexPath.row].favourite == 1 {
                     cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav2")
                 }else{
                     cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav")
                 }
                     return cell
                    
        default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catrgoryCVCell", for: indexPath) as! CategoryCVCell

                 let url = URL(string :arrCategories?[indexPath.row].image ?? "")
                
                 cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
                 
                 cell.lblName?.text = arrCategories?[indexPath.row].name
            
                    return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var productID: Int?
        var productName: String?
        
        switch collectionView {
        case bestSellerCV:
                productID = arrMostSeller?[indexPath.row].id
                productName = arrMostSeller?[indexPath.row].name
                    break
        case offerCV:
                productID = arrOffers?[indexPath.row].id
                productName = arrOffers?[indexPath.row].name
                    break
        case newCollectionCV:
                 productID = arrNewCollection?[indexPath.row].id
                 productName = arrNewCollection?[indexPath.row].name
                    break
        default:
                return
        }
        
        
        let details = (self.storyboard?.instantiateViewController(withIdentifier: "detailsVC2") as! DetailsVC2)
        
        details.id = productID
        details.productName = productName
        details.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(details, animated: true)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if collectionView == self.categoryCV{
            return CGSize(width: width/5, height: height/9.9)
        }else{
            
            return CGSize(width: width/2.8, height: height/3.5)
        }
    }
}

