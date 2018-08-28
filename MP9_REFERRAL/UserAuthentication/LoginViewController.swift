//
//  LoginViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit
class LoginViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var heightConstViewInsideScroll: NSLayoutConstraint!
    
    @IBOutlet weak var BtnFacebookLogin: UIButton!
    
    @IBOutlet weak var viewInsideSrollVerticalConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewFacebookLogin: UIView!
    
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var viewCountryCode: UIView!
    
    @IBOutlet weak var tfCountryCode: UITextField!
    
    
    @IBOutlet weak var viewInsideScroll: UIView!
    
    @IBOutlet weak var BtnLogin: UIButton!
    
    @IBOutlet weak var viewShowCountryList: UIView!
    
    @IBOutlet weak var TableViewMain: UITableView!
    var BlogCountryList: StateCity.CountryListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UIScreen.main.sizeType == .iPhone4 {
            self.heightConstViewInsideScroll.constant = 680
            self.heightConstViewInsideScroll.priority = UILayoutPriority(rawValue: 1000)
            self.viewInsideSrollVerticalConst.priority = UILayoutPriority(rawValue: 250)
            
        }
        else if UIScreen.main.sizeType == .iPhone5
        {
            self.heightConstViewInsideScroll.constant = 610
            self.heightConstViewInsideScroll.priority = UILayoutPriority(rawValue: 1000)
            self.viewInsideSrollVerticalConst.priority = UILayoutPriority(rawValue: 250)
        }
        else{
            self.heightConstViewInsideScroll.constant = 750
            self.heightConstViewInsideScroll.priority = UILayoutPriority(rawValue: 1000)
            self.viewInsideSrollVerticalConst.priority = UILayoutPriority(rawValue: 250)
        }
       
        //////20AUG
        self.countryCodeSelected = "+1"
        self.countryIdSelected = "231"
        //////
        self.funcNavigationSetUp()
        
         TableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.setUpUI()
      
    }
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func setUpUI()
    {
      
        self.viewPhone.layer.cornerRadius = 10.0
        self.viewPhone.clipsToBounds = true
        
        self.viewPassword.layer.cornerRadius = 10.0
        self.viewPassword.clipsToBounds = true
        self.viewCountryCode.layer.cornerRadius = 10.0
        self.viewCountryCode.clipsToBounds = true
       
        self.BtnLogin.layer.cornerRadius = 10.0
        self.BtnLogin.clipsToBounds = true
        
        tfPhone.keyboardType = .numberPad
        tfPassword.returnKeyType = .done
        tfPassword.isSecureTextEntry = true
        tfPhone.delegate = self
        tfPassword.delegate = self
        tfCountryCode.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NextAction));
        toolbar.setItems([spaceButton,nextButton], animated: false)
        tfPhone.inputAccessoryView = toolbar
        //////////////////////////////////////
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                let user = UserSocialMedia(firstName: session?.userName, lastName: "", email: "", phoneNo: "", password: "", countryCode: "", countryId: "", stateId: "", cityId: "",socialId: session?.userID, smPlatform: "Twitter",deviceId: AuthToken.FCMToken, deviceType: "ios")
                
                self.funcSocialSignUp(user: user)
                
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        
        //logInButton.center = self.viewOfTwitter.center
        logInButton.backgroundColor = UIColor.clear
        logInButton.setBackgroundImage(UIImage(named:"button_orange_large_3x"), for: .normal)
       // self.viewInsideScroll.addSubview(logInButton)
        
       /* logInButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewInsideScroll.addConstraints([
            NSLayoutConstraint(item: logInButton, attribute: .width, relatedBy: .equal, toItem: viewFacebookLogin, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: logInButton, attribute: .height, relatedBy: .equal, toItem: viewFacebookLogin, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: logInButton, attribute: .centerX, relatedBy: .equal, toItem: self.viewInsideScroll, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: logInButton, attribute: .top, relatedBy: .equal, toItem: viewFacebookLogin, attribute: .bottom, multiplier: 1.0, constant: 10),
            ])
       */
        
    }
    
    @IBAction func ActionFacebookLogin(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            
         //   print("FBUserInfo===\(String(describing: dataDictionary))")
          //  print("FBUserInfoDic===\(String(describing: dataDictionary!["email"]))")
           if dataDictionary != nil
           {
            let user = UserSocialMedia(firstName: dataDictionary!["first_name"] as? String, lastName: dataDictionary!["last_name"] as? String, email: dataDictionary!["email"] as? String, phoneNo: "", password: "", countryCode: "", countryId: "", stateId: "", cityId: "",socialId: dataDictionary!["id"] as? String, smPlatform: "Facebook",deviceId: AuthToken.FCMToken, deviceType: "ios")
            
            self.funcSocialSignUp(user: user)
            }
        }
    }
    func funcSocialSignUp(user: UserSocialMedia)
    {
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .SignUpSM(withUser: user), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                
                if statusCode == 200
                {
                    guard let loginUserDetail = try? JSONDecoder().decode(UserLoginDetail.self, from: responseBodyModel.bodyData!) else {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    print("blog title: \(loginUserDetail)")
                    GlobalLoginUSerDetail = loginUserDetail
                    let defaults = UserDefaults.standard
                    defaults.set(responseBodyModel.bodyData!, forKey: "loginUserDetail")
                    defaults.synchronize()
                    let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    let navController = UINavigationController(rootViewController: dashBoardNav)
                    navController.navigationBar.isHidden = true
                    self.navigationController?.present(navController, animated: true, completion: nil)
                }
                else
                {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 208/255, blue: 240/255, alpha: 1.0)
    }
    @objc func NextAction(){
        tfPassword.becomeFirstResponder()
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        case tfCountryCode:
            self.funcGetCountryListing()
            return false
        default:
            return true
        }
    }
    func funcGetCountryListing()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        _=NetworkHelper().makeRequest(withAPIProvider: .getCountryListing(), completion: { (error, responseBodyModel) in
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil
                    else
                {
                    self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    guard let blog = try? JSONDecoder().decode((StateCity.CountryListing).self, from: responseBodyModel.bodyData!)
                        else
                    {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    self.BlogCountryList = blog
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    self.viewShowCountryList.isHidden = false
                   
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.BlogCountryList!.countries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = BlogCountryList?.countries[indexPath.row]
        cell.textLabel?.text = dic?.name
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = BlogCountryList?.countries[indexPath.row]
        self.countryIdSelected = String((dic?.id)!)
        self.countryCodeSelected = dic?.phonecode
        self.tfCountryCode.text = dic?.name
        self.viewShowCountryList.isHidden = true
    }
    
    @IBAction func ActionCutViewCountryList(_ sender: Any) {
        self.viewShowCountryList.isHidden = true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case tfPhone:
            tfPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func ActionForgotPswd(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPswd", sender: self)
    }
    
    @IBAction func ActionSignUp(_ sender: Any) {
        
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is SignUpViewController
            {
                self.navigationController?.popToViewController(vc, animated: true)
                return
            }
            
        }
        self.performSegue(withIdentifier: "toSignUp", sender: self)
        
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionLogin(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        
        if(self.countryIdSelected == nil)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseSelectCountryCode)
            return
        }
        if(tfPhone.text?.count == 0)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseSelectPhoneNumber)
            return
        }
        if(tfPassword.text?.count == 0)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseSelectPassword)
            return
        }
        self.funcLogin()
       
    }
    func funcLogin()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .login(countryCode: self.countryCodeSelected!, phoneNo: self.tfPhone.text!, password: self.tfPassword.text!, deviceType: "ios", deviceId: AuthToken.FCMToken), completion: { (error, responseBodyModel) in
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
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                }
                    print("blog title: \(loginUserDetail)")
                    GlobalLoginUSerDetail = loginUserDetail
                    if(loginUserDetail.status == 0)
                    {
                        let alertController = UIAlertController(title: "RecNX", message: "Please verify your OTP !", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            if  let otpVC : VerifyOTPViewController = self.storyboard!.instantiateViewController(withIdentifier: "verifyOTP") as? VerifyOTPViewController
                            {
                                otpVC.countryCode = self.countryCodeSelected
                                otpVC.phone = self.tfPhone.text
                                otpVC.fromForgotPassword = false
                                self.navigationController?.pushViewController(otpVC, animated: true)
                            }
                        }
                        alertController.addAction(OKAction)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                            print("Cancel button tapped");
                        }
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion:nil)
                    }
                    else
                    {
                        
                        let defaults = UserDefaults.standard
                        defaults.set(data, forKey: "loginUserDetail")
                        defaults.synchronize()
                        let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                        let navController = UINavigationController(rootViewController: dashBoardNav)
                        navController.navigationBar.isHidden = true
                        self.navigationController?.present(navController, animated: true, completion: nil)
                       
                    }
                   
                } else {
                    
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
