//
//  MaybeLikeCVCell.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/17/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class MayBeLikeCVCell: UICollectionViewCell {
    

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    override func awakeFromNib() {
        setUpCVImage(imgView: imgView)
    }
    
}
