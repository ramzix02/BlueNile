//
//  xXx.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/20/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

extension DetailsVC2 : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case detailsCV:
            return presenter?.getArrImagesCount() ?? 0
        default:
            return presenter?.getArrProductsCount() ?? 0
        }
        
    }
    
    @objc func arrProductsFavPressed(_ sender: UIButton)
    {
        guard let indexPath = mayBeCV?.indexPath(for: ((sender.superview?.superview) as! MayBeLikeCVCell)) else { return}
        guard let id = myProduct?.id else { return }
        presenter?.requestFav(id: id, indexPath:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case detailsCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCVCell", for: indexPath) as! DetailsCVCell
            let myImage = presenter?.getArrImagesItem(index: indexPath.row)
            let url = URL(string :myImage?.image ?? "")
            cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "Ad"))
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mayBeLikeCVCell", for: indexPath) as! MayBeLikeCVCell
            
               myProduct = presenter?.getArrProductsItem(index: indexPath.row)
            
            let url = URL(string :myProduct?.image ?? "")
               cell.imgView?.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "logo"))
               cell.lblProduct?.text = myProduct?.name
               cell.lblPrice?.text = myProduct?.price
               cell.btnFav.addTarget(self, action: #selector(arrProductsFavPressed(_:)), for: .touchUpInside)
               if myProduct?.favourite == 1 {
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
                productID = myProduct?.id
                productName = myProduct?.name
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
        
        if collectionView == self.detailsCV{
            return CGSize(width: width/1, height: height/4)
        }else{
            return CGSize(width: width/2.8, height: height/3.5)
        }
    }
}
