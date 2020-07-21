//
//  DetailsVC.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/17/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

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
    
    private var urlFav: String = "http://bluenilekw.com/api/favourite_action/"
    private let auth: String = getAuthUser()
    private var url: String?
    //private var activityInd = UIActivityIndicatorView()
    private var arrImages: [Image]?
    private var arrProducts: [ProductElement]?
    var id: Int?
    var productName: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()
        indicatorSwitch(status: .on, view: view)
        setUpViews()
        requestDetails()
    }
    
    func initValues() {
        url = "http://bluenilekw.com/api/product/\(id ?? 1)"
        arrImages = [Image]()
        arrProducts = [ProductElement]()
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

    func requestDetails() {
        NetworkHandler.excuteDetailsRequest(url: url ?? "",auth: auth,lang: "en"){
                
            detailsModel , error in

            indicatorSwitch(status: .off,view: self.view)
            
                let status = detailsModel?.status ?? 0
                let msg = detailsModel?.message ?? ""
                
                let goldName = detailsModel?.data.gold.name
                let goldPrice = detailsModel?.data.gold.price
                
                self.arrImages = detailsModel?.data.product.images
                self.arrProducts = detailsModel?.data.products
                
            if(status == 1){

                self.lblGoldName.text = goldName
                self.lblGoldPrice.text = goldPrice
                self.lblProductName.text = detailsModel?.data.product.name
                self.lblProductPrice.text = "\(detailsModel?.data.product.price ?? 0 ) KWD" 
                self.txtProductDesc.text = detailsModel?.data.product.desc

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
                    self.detailsCV.reloadData()
                    self.mayBeCV.reloadData()
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
            self.requestDetails()
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



extension DetailsVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case detailsCV:
            return arrImages?.count ?? 0
        default:
            return arrProducts?.count ?? 0
        }
        
    }
    
    @objc func arrProductsFavPressed(_ sender: UIButton)
    {
        let indexPath = mayBeCV?.indexPath(for: ((sender.superview?.superview) as! MayBeLikeCVCell))
        guard let id = arrProducts?[indexPath?.row ?? 0].id else { return }
        requestFav(id: id)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case detailsCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCVCell", for: indexPath) as! DetailsCVCell
            let url = URL(string :arrImages?[indexPath.row].image ?? "")
            cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "Ad"))
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mayBeLikeCVCell", for: indexPath) as! MayBeLikeCVCell

               let url = URL(string :arrProducts?[indexPath.row].image ?? "")
               cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
               cell.lblProduct?.text = arrProducts?[indexPath.row].name
               cell.lblPrice?.text = arrProducts?[indexPath.row].price
               cell.btnFav.addTarget(self, action: #selector(arrProductsFavPressed(_:)), for: .touchUpInside)
               if arrProducts?[indexPath.row].favourite == 1 {
                   cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav2")
               }else{
                   cell.btnFav.imageView?.image = #imageLiteral(resourceName: "fav")
               }
               return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var productID: Int?
        var productName: String?
        
        switch collectionView {
        case mayBeCV:
                productID = arrProducts?[indexPath.row].id
                productName = arrProducts?[indexPath.row].name
                    break
        default:
                return
        }
            let details = (self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsVC)
            
            details.id = productID
            details.productName = productName
            details.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(details, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if collectionView == self.detailsCV{
            return CGSize(width: width/1, height: height/4)
        }else{
            return CGSize(width: width/2.8, height: height/3.5)
        }  
    }
}
