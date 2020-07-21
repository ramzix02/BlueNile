//
//  SignInVC.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/14/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

enum SelectIcon{
    case selected
    case notSelected
}

class SignInVC: UIViewController {
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    
    var selectIcon: SelectIcon = .notSelected
    private let url: String = "http://bluenilekw.com/api/login"
    private var activityInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        txtEmail.placeholder = "E-mail"
        txtEmail.title = "E-mail"
        txtEmail.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        
        txtPassword.placeholder = "Password"
        txtPassword.title = "Password"
        txtPassword.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        txtPassword.isSecureTextEntry = true
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        setUpRoundedBtn(btn:btnLogIn, color: #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1))
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if(validateInputs()){
               indicatorSwitch(status: .on, view: view)
               requestLogin()
           }
    }
    
    func goHomeScreen() {
        let home = (self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeVC)
        home.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func requestLogin() {
        NetworkHandler.loginORRegister(url: url, userDic:
            ["email": txtEmail.text!,
             "password": txtPassword.text!
        ]){
            
        userModel , error in

        indicatorSwitch(status: .off, view: self.view)
        
        let status = userModel?.status ?? 0
        let msg = userModel?.message ?? ""
        let auth = userModel?.data?.user?.authorization ?? ""
        
        if(status == 1){
            showToast(message: msg, view: self.view)

            if self.selectIcon == .selected{
                saveAuthUser(auth: auth)
            }

            self.goHomeScreen()
            
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

    @IBAction func showPassword(_ sender: Any) {
        if txtPassword.isSecureTextEntry{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func selectRememberMe(_ sender: Any) {
        if (selectIcon == SelectIcon.notSelected){
            selectIcon = .selected
            btnSelect.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }else{
            selectIcon = .notSelected
            btnSelect.setImage(#imageLiteral(resourceName: "check2"), for: .normal)
        }
    }
    
    func validateInputs() -> Bool {
                
        let email = txtEmail.text ?? ""
        
         if(email.count == 0){
            showToast(message: "Please enter E-Mail", view: self.view)
            return false
        }else if !validateRegex(inputRegix: email, regixFormat: emailRegEx){
            showToast(message: "Please enter a valid E-Mail", view: self.view)
            return false
        }else if(txtPassword.text?.count == 0){
            showToast(message: "Please enter Password", view: self.view)
            return false
        }
        else{
            return true
        }
    }
    
    @IBAction func goSignUp(_ sender: Any) {
        let signUpVC = (self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC)
        signUpVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}


