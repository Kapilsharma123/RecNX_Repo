//
//  SignUpViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var ViewInsideScroll: UIView!
    
    @IBOutlet weak var viewShowCountryList: UIView!
    
    @IBOutlet weak var TableViewCountryList: UITableView!
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfLastName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfCountryCode: UITextField!
    
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var tfReferral: UITextField!
    
    @IBOutlet weak var tfCity: UITextField!
    
    @IBOutlet weak var titleCountryStateListing: UILabel!
    
    @IBOutlet weak var BtnSignUp: UIButton!
    var BlogCountryList: StateCity.CountryListing?
    var BlogStatesList: StateCity.StatesListing?
    var BlogCitiesList: StateCity.CitiesListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    var stateIdSelected : String?
    var cityIdSelected : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewCountryList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //////20AUG
        self.countryIdSelected = "231"
        self.countryCodeSelected = "+1"
        self.tfCountryCode.text = "+1"
        ///////20AUG
         self.setUpUI()
       self.funcNavigationSetUp()
    }
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func setUpUI()
    {
        self.BtnSignUp.layer.cornerRadius = 10.0
        self.BtnSignUp.clipsToBounds = true
        for subview in self.ViewInsideScroll.subviews
        {
            if  subview.tag > 0
            {
                subview.layer.cornerRadius = 10.0
                subview.clipsToBounds = true
            }
        }
        tfName.returnKeyType = .next
        tfLastName.returnKeyType = .next
        tfEmail.returnKeyType = .next
        tfPhone.keyboardType = .numberPad
        tfPassword.returnKeyType = .next
        tfPassword.isSecureTextEntry = true
        tfName.delegate = self
        tfLastName.delegate = self
        tfEmail.delegate = self
        tfPhone.delegate = self
        tfPassword.delegate = self
        tfCountryCode.delegate = self
        tfState.delegate = self
        tfCity.delegate = self
        tfReferral.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NextAction));
        toolbar.setItems([spaceButton,nextButton], animated: false)
        tfPhone.inputAccessoryView = toolbar
    }
    @objc func NextAction(){
        tfPassword.becomeFirstResponder()
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
                    self.TableViewCountryList.tag = 1
                    self.TableViewCountryList.delegate = self
                    self.TableViewCountryList.dataSource = self
                    self.TableViewCountryList.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.titleCountryStateListing.text = "Select Country"
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    func funcGetAllStatesByCountryId()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        print("countryID==\(String(describing: self.countryIdSelected))")
        _=NetworkHelper().makeRequest(withAPIProvider: .GetAllStatesByCountryId(id: self.countryIdSelected!), completion: { (error, responseBodyModel) in
            self.hideLoading()
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
                    guard let blog = try? JSONDecoder().decode((StateCity.StatesListing).self, from: responseBodyModel.bodyData!)
                        else
                    {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    self.BlogStatesList = blog
                    self.TableViewCountryList.tag = 2
                    self.TableViewCountryList.delegate = self
                    self.TableViewCountryList.dataSource = self
                    self.TableViewCountryList.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.titleCountryStateListing.text = "Select State"
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    func funcGetAllCitiesByStateId()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .GetAllCitiesByStateId(id: self.stateIdSelected!), completion: { (error, responseBodyModel) in
            self.hideLoading()
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
                    guard let blog = try? JSONDecoder().decode((StateCity.CitiesListing).self, from: responseBodyModel.bodyData!)
                        else
                    {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    self.BlogCitiesList = blog
                    self.TableViewCountryList.tag = 3
                    self.TableViewCountryList.delegate = self
                    self.TableViewCountryList.dataSource = self
                    self.TableViewCountryList.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.titleCountryStateListing.text = "Select City"
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func ActionCutViewShowCountries(_ sender: Any) {
        self.viewShowCountryList.isHidden = true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        case tfCountryCode:
            //self.funcGetCountryListing()
            return false
        case tfState:
            if(self.countryIdSelected != nil)
            {
                self.funcGetAllStatesByCountryId()
            }
            else{
                self.showAlert(withMessage: "Please select Country first")
            }
            return false
        case tfCity:
            if(self.stateIdSelected != nil)
            {
                self.funcGetAllCitiesByStateId()
            }
            else{
                self.showAlert(withMessage: "Please select State first")
            }
            return false
            
        default:
            return true
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case tfName:
            tfLastName.becomeFirstResponder()
        case tfLastName:
            tfEmail.becomeFirstResponder()
        case tfEmail:
            tfPhone.becomeFirstResponder()
            //tfCountryCode.becomeFirstResponder()
        case tfPhone:
            tfPassword.becomeFirstResponder()
        case tfPassword:
            tfPassword.resignFirstResponder()
            tfState.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1)
        {
        return self.BlogCountryList!.countries.count
        }
        else if(tableView.tag == 2){
            return (self.BlogStatesList?.states.count)!
        }
        else
        {
            return (self.BlogCitiesList?.cities.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if(tableView.tag == 1)
        {
        let dic = BlogCountryList?.countries[indexPath.row]
        cell.textLabel?.text = dic?.name
        }
        else if(tableView.tag == 2)
        {
            let dic = BlogStatesList?.states[indexPath.row]
            cell.textLabel?.text = dic?.name
        }
        else
        {
            let dic = BlogCitiesList?.cities[indexPath.row]
            cell.textLabel?.text = dic?.name
        }
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag == 1)
        {
        let dic = BlogCountryList?.countries[indexPath.row]
        self.countryIdSelected = String((dic?.id)!)
        self.countryCodeSelected = dic?.phonecode
        self.tfCountryCode.text = dic?.name
        }
        else if(tableView.tag == 2)
        {
            let dic = BlogStatesList?.states[indexPath.row]
            self.stateIdSelected = String((dic?.id)!)
            self.tfState.text = dic?.name
        }
        else
        {
            let dic = BlogCitiesList?.cities[indexPath.row]
            self.cityIdSelected = String((dic?.id)!)
            self.tfCity.text = dic?.name
        }
        self.viewShowCountryList.isHidden = true
    }
   
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionSignIn(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is LoginViewController
            {
                self.navigationController?.popToViewController(vc, animated: true)
                return
            }
           
        }
        if  let VC : LoginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        {
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func ActionSignUp(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        if(tfName.text?.count == 0)
        {
           self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterFirstName)
            return
        }
        if(tfLastName.text?.count == 0)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterLastName)
            return
        }
        if(tfEmail.text?.count == 0)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterEmail)
            return
        }
        let emailValidation = self.isValidEmail(testStr: tfEmail.text!)
        if(emailValidation == false)
        {
           self.showAlert(withMessage: GlobalConstants.FillAllDetails.invalidEmail)
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
        if((tfPassword.text?.count)! < 6)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.passwordMustBeAtleast6Characters)
            return
        }
        if(self.stateIdSelected == nil)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseSelectState)
            return
        }
        if(self.cityIdSelected == nil)
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseSelectCity)
            return
        }
        if(tfReferral.text == nil)
        {
            tfReferral.text = ""
        }
        let user = User(firstName: tfName.text, lastName: tfLastName.text, email: tfEmail.text, phoneNo: tfPhone.text, password: tfPassword.text, countryCode: self.countryCodeSelected, countryId: self.countryIdSelected, stateId: self.stateIdSelected, cityId: self.cityIdSelected,referralCode : tfReferral.text)
       
        self.funcSignUp(user: user)
       
     }
    func funcGoToVerifyOTP()
    {
        if  let otpVC : VerifyOTPViewController = self.storyboard!.instantiateViewController(withIdentifier: "verifyOTP") as? VerifyOTPViewController
        {
            otpVC.countryCode = self.countryCodeSelected
            otpVC.phone = self.tfPhone.text
            otpVC.fromForgotPassword = false
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    func funcSignUp(user: User)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .SignUp(withUser: user), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
               
                if statusCode == 200
                {
                    self.funcGoToVerifyOTP()
                }
                else
                {
                    if statusCode == 501
                    {
                        let alert = UIAlertController(title: "", message: responseBodyModel.responseMessage ?? "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.funcGoToVerifyOTP()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                    }
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
