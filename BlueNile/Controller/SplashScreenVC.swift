//
//  SplashScreenVC.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/18/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if getAuthUser() != "" {
            goHomeScreen()
        }else{
            goSignIn()
        }
    }
    
    func goHomeScreen() {
        let home = (self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeVC)
        home.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func goSignIn() {
        let signIn = (self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC)
        signIn.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signIn, animated: true)
    }
}
