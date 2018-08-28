//
//  VerifyOTPViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 19/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class VerifyOTPViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    @IBOutlet weak var tfOTP: UITextField!
    
    @IBOutlet weak var BtnSubmit: UIButton!
    
    @IBOutlet weak var BtnResend: UIButton!
    var countryCode: String?
    var phone:String?
    var fromForgotPassword = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelPhoneNumber.text = self.countryCode! + "-" + self.phone!
        self.BtnSubmit.layer.cornerRadius = 10.0
        self.BtnSubmit.clipsToBounds = true
        self.BtnResend.layer.cornerRadius = 10.0
        self.BtnResend.clipsToBounds = true
        tfOTP.delegate = self
        tfOTP.keyboardType = .numberPad
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneTap));
        toolbar.setItems([spaceButton,nextButton], animated: false)
        tfOTP.inputAccessoryView = toolbar
        
        tfOTP.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    @objc func DoneTap(){
        tfOTP.resignFirstResponder()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionSubmit(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        if(self.tfOTP.text?.count != 4)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterFourdigitcode)
            return
        }
        if( self.fromForgotPassword == true)
        {
           self.funcVerifyPasswordOTP()
        }
        else
        {
            self.funcVerifyOTP()
        }
        
    }
    func funcVerifyOTP()
    {
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .verifyOTP(countryCode: self.countryCode!, phoneNo: self.phone!, otp: self.tfOTP.text!, deviceType: "ios", deviceId: AuthToken.FCMToken), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                        guard let loginUserDetail = try? JSONDecoder().decode(UserLoginDetail.self, from: data) else {
                            print("Error: Couldn't decode data into Blog")
                            return
                        }
                        GlobalLoginUSerDetail = loginUserDetail
                        let defaults = UserDefaults.standard
                        defaults.set(data, forKey: "loginUserDetail")
                        defaults.synchronize()
                        let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                        let navController = UINavigationController(rootViewController: dashBoardNav)
                        navController.navigationBar.isHidden = true
                        self.navigationController?.present(navController, animated: true, completion: nil)
                    
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    func funcVerifyPasswordOTP()
    {
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .verifyPasswordOTP(countryCode: self.countryCode!, phoneNo: self.phone!, otp: self.tfOTP.text!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    if  let VC : ResetPasswordViewController = self.storyboard!.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordViewController
                        {
                            VC.countryCode = self.countryCode
                            VC.phone = self.phone
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                        }
                    
                }
                else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })    }
    
    @IBAction func ActionResend(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .resendOTP(countryCode: self.countryCode!, phoneNo: self.phone!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                if statusCode == 200
                {
                    self.showAlert(withMessage:  responseBodyModel.responseMessage ?? "")
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
