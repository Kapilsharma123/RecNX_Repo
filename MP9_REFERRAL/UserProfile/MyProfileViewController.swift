//
//  MyProfileViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfCountryCode: UITextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var tfCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelUserName.text = (GlobalLoginUSerDetail?.firstName)! + " " + (GlobalLoginUSerDetail?.lastName)!
        self.labelUserName.text = self.labelUserName.text?.uppercased()
        self.tfEmail.text = GlobalLoginUSerDetail?.email
        self.tfCountryCode.text = GlobalLoginUSerDetail?.countryCode
        self.tfPhoneNumber.text = GlobalLoginUSerDetail?.phoneNo
        self.tfState.text = GlobalLoginUSerDetail?.state?.name
        self.tfCity.text = GlobalLoginUSerDetail?.city?.name
    }
    
    @IBAction func AcionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionLogOut(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
            self.showLoading()
            _=NetworkHelper().makeRequest(withAPIProvider: .logOut(userId: String(GlobalLoginUSerDetail?.id ?? 0), savedDeviceID: String(GlobalLoginUSerDetail?.savedDeviceId ?? 0)), completion: { (error, responseBodyModel) in
                self.hideLoading()
                if let responseBodyModel = responseBodyModel {
                    let statusCode = responseBodyModel.statusCode
                    
                    if statusCode == 200
                    {
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "loginUserDetail")
                        defaults.synchronize()
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                        let navController = UINavigationController(rootViewController: viewController)
                        self.navigationController?.present(navController, animated: true, completion: nil)
                        
                    }else {
                        
                        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                    }
                    
                    
                } else {
                    
                }
            })
    }
   
    @IBAction func ActionOfEditProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "toEditProfile", sender: self)
    }
    

    @IBAction func ActionEdit(_ sender: Any) {
        self.performSegue(withIdentifier: "toEditProfile", sender: self)
    }
    
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
