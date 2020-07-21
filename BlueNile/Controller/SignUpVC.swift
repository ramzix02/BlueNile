//
//  SignUpVC.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/14/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    private let url: String = "http://bluenilekw.com/api/register"
    private var activityInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegates()
        setUpTxtFields()
        setUpRoundedBtn(btn:btnSignUp, color: #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1))
           }
           
    func setUpDelegates() {
        txtUserName.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
        txtPassword.delegate = self
    }
    
    func setUpTxtFields() {
        txtUserName.placeholder = "User name"
        txtUserName.title = "User name"
        txtUserName.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        
        txtEmail.placeholder = "E-mail"
        txtEmail.title = "E-mail"
        txtEmail.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        
        txtPhone.placeholder = "Phone number"
        txtPhone.title = "Phone number"
        txtPhone.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        
        txtPassword.placeholder = "Password"
        txtPassword.title = "Password"
        txtPassword.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
        txtPassword.isSecureTextEntry = true
        
        txtAddress.placeholder = "Address"
        txtAddress.title = "Address"
        txtAddress.lineColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.3098039216, alpha: 1)
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if txtPassword.isSecureTextEntry{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    func requestSignUp() {
        NetworkHandler.loginORRegister(url: url, userDic:
                ["email":txtEmail.text!,
                 "phone":txtPhone.text!,
                 "password":txtPassword.text!,
                 "password_confirmation":txtPassword.text!,
                 "name":txtUserName.text!,
                 "address":txtAddress.text!
        ]){
            
        userModel , error in

        indicatorSwitch(status: .off, view: self.view)
        
        let status = userModel?.status ?? 0
        let msg = userModel?.message ?? ""
        let auth = userModel?.data?.user?.authorization ?? ""
            
        if(status == 1){
            showToast(message: msg, view: self.view)
            //Navigation
            self.goHomeScreen()
            
            //user defaults
            saveAuthUser(auth: auth)
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
    
    @IBAction func signUp(_ sender: Any) {
        if(validateInputs()){
            indicatorSwitch(status: .on, view: view)
            requestSignUp()
        }
        
    }
    
    func validateInputs() -> Bool {
        
        let email = txtEmail.text ?? ""
        
        if (txtUserName.text?.count == 0){
            showToast(message: "Please enter name", view: self.view)
            return false
        }else if(email.count == 0){
            showToast(message: "Please enter E-Mail", view: self.view)
            return false
        }else if !validateRegex(inputRegix: email, regixFormat: emailRegEx){
            showToast(message: "Please enter a valid E-Mail", view: self.view)
            return false
        }
        else if (txtPhone.text?.count == 0){
            showToast(message: "Please enter Phone", view: self.view)
            return false
        }else if(txtPassword.text?.count == 0){
            showToast(message: "Please enter Password", view: self.view)
            return false
        }else if (txtAddress.text?.count == 0){
            showToast(message: "Please enter Address", view: self.view)
            return false
        }
        else{
            return true
        }
    }
    
    
    @IBAction func goLogin(_ sender: Any) {
        
        let signInVC = (self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC)
        signInVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    func goHomeScreen() {
        let home = (self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeVC)
        home.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}


