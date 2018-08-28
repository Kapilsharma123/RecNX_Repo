//
//  ResetPasswordViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 19/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tfNewPassword: UITextField!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var viewNewPswd: UIView!
    
    @IBOutlet weak var viewConfirmPswd: UIView!
    
    @IBOutlet weak var BtnSubmit: UIButton!
    var countryCode: String?
    var phone:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewNewPswd.layer.cornerRadius = 10.0
        self.viewNewPswd.clipsToBounds = true
        self.viewConfirmPswd.layer.cornerRadius = 10.0
        self.viewConfirmPswd.clipsToBounds = true
        self.BtnSubmit.layer.cornerRadius = 10.0
        self.BtnSubmit.clipsToBounds = true
        tfNewPassword.delegate = self
        tfConfirmPassword.delegate = self
        tfNewPassword.returnKeyType = .done
        tfConfirmPassword.returnKeyType = .done
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionChangePassword(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        if((tfNewPassword.text?.count)! < 6 || (tfConfirmPassword.text?.count)! < 6)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.passwordMustBeAtleast6Characters)
            return
        }
        if(!(tfNewPassword.text == tfConfirmPassword.text))
        {
          self.showAlert(withMessage: GlobalConstants.FillAllDetails.newPasswordAndConfirmPasswordShouldBeSame)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .createPassword(countryCode: self.countryCode!, phoneNo: self.phone!, newPassword: self.tfNewPassword.text!, confirmPassword: self.tfConfirmPassword.text!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
               
                if statusCode == 200
                {
                   self.showAlertPopToLogin(withMessage: responseBodyModel.responseMessage ?? "")
                    
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
