//
//  EditProfileViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 19/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var TableViewMain: UITableView!
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfCountryCode: UITextField!
    
    @IBOutlet weak var tfLastName: UITextField!
    
    @IBOutlet weak var tfPhoneNo: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var tfCity: UITextField!
    
    @IBOutlet weak var viewShowCountryList: UIView!
    
    @IBOutlet weak var labelViewShowCountryList: UILabel!
    
    @IBOutlet weak var viewchangePswd: UIView!
    
    @IBOutlet weak var BtnChangePswd: UIButton!
    
    @IBOutlet weak var BtnUpdate: UIButton!
    
    @IBOutlet weak var viewInsideChangePswd: UIView!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    
    @IBOutlet weak var tfNewPassword: UITextField!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var viewBlurChangePswd: UIView!
    
    
    var BlogCountryList: StateCity.CountryListing?
    var BlogStatesList: StateCity.StatesListing?
    var BlogCitiesList: StateCity.CitiesListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    var stateIdSelected : String?
    var cityIdSelected : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInsideChangePswd.layer.cornerRadius = 3.0
        viewInsideChangePswd.clipsToBounds = true
        viewInsideChangePswd.layer.borderWidth = 2.0
       viewInsideChangePswd.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self // This is not required
        viewBlurChangePswd.addGestureRecognizer(tap)
        
         TableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.viewInsideChangePswd.layer.cornerRadius = 10.0
        self.viewInsideChangePswd.clipsToBounds = true
        
         self.tfName.text = GlobalLoginUSerDetail?.firstName
         self.tfLastName.text = GlobalLoginUSerDetail?.lastName
         self.tfEmail.text = GlobalLoginUSerDetail?.email
         self.tfCountryCode.text = GlobalLoginUSerDetail?.countryCode
         self.tfPhoneNo.text = GlobalLoginUSerDetail?.phoneNo
        self.tfState.text = GlobalLoginUSerDetail?.state?.name
        self.tfCity.text = GlobalLoginUSerDetail?.city?.name
        
        countryIdSelected = GlobalLoginUSerDetail?.countryId
        countryCodeSelected = GlobalLoginUSerDetail?.countryCode
        stateIdSelected = String(GlobalLoginUSerDetail?.state?.id ?? 0)
        cityIdSelected = String(GlobalLoginUSerDetail?.city?.id ?? 0)
        if self.countryIdSelected == nil || self.countryIdSelected == ""
        {
            self.countryIdSelected = "231"
            self.countryCodeSelected = "+1"
        }
        
         self.tfName.delegate = self
         self.tfLastName.delegate = self
         self.tfEmail.delegate = self
         self.tfCountryCode.delegate = self
         self.tfPhoneNo.delegate = self
         tfOldPassword.isSecureTextEntry = true
         tfNewPassword.isSecureTextEntry = true
         tfConfirmPassword.isSecureTextEntry = true
         self.tfState.delegate = self
         self.tfCity.delegate = self
        self.tfOldPassword.delegate = self
        self.tfNewPassword.delegate = self
        self.tfConfirmPassword.delegate = self
        tfName.returnKeyType = UIReturnKeyType.next
        tfLastName.returnKeyType = UIReturnKeyType.next
        
        self.tfOldPassword.returnKeyType = .next
        self.tfNewPassword.returnKeyType = .next
        self.tfConfirmPassword.returnKeyType = .done
        self.tfPhoneNo.isUserInteractionEnabled = false
        self.tfEmail.isUserInteractionEnabled = false
        self.tfCountryCode.isUserInteractionEnabled = false
        
        
        self.BtnChangePswd.layer.cornerRadius = 10.0
        self.BtnChangePswd.clipsToBounds = true
        self.BtnUpdate.layer.cornerRadius = 10.0
        self.BtnUpdate.clipsToBounds = true
    }
    
    @IBAction func ActionHome(_ sender: Any) {
        for VC in (self.navigationController?.viewControllers)!
        {
            if (VC is HomeViewController)
            {
                self.navigationController?.popToViewController(VC, animated: true)
                break
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.viewchangePswd.isHidden = true
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        
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
            tfState.becomeFirstResponder()
       
        case tfOldPassword:
            tfNewPassword.becomeFirstResponder()
        case tfNewPassword:
            tfOldPassword.resignFirstResponder()
            tfConfirmPassword.becomeFirstResponder()
        
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func funcGetAllStatesByCountryId()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
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
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.tag = 2
                    self.TableViewMain.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.labelViewShowCountryList.text = "Select State"
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
                    self.TableViewMain.tag = 3
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.labelViewShowCountryList.text = "Select City"
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
         if(tableView.tag == 2){
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
         if(tableView.tag == 2)
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
         if(tableView.tag == 2)
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
    
    @IBAction func ActionCutViewShowCountryList(_ sender: Any) {
        self.viewShowCountryList.isHidden = true
    }
    
    
    @IBAction func ActionChangePswd(_ sender: Any) {
        self.viewchangePswd.isHidden = false
    }
    
    @IBAction func ActionUpdate(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .editProfile(userId: String(GlobalLoginUSerDetail?.id ?? 0), firstName: self.tfName.text!,lastName: self.tfLastName.text!, email: self.tfEmail.text!, phoneNo: self.tfPhoneNo.text!, countryCode: self.countryCodeSelected!, countryId: self.countryIdSelected!, stateId: self.stateIdSelected!, cityId: self.cityIdSelected!,savedDeviceId : String(GlobalLoginUSerDetail?.savedDeviceId ?? 0)), completion: { (error, responseBodyModel) in
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
                    
                    let alert = UIAlertController(title: "", message: responseBodyModel.responseMessage ?? "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                        let navController = UINavigationController(rootViewController: dashBoardNav)
                        navController.navigationBar.isHidden = true
                        self.navigationController?.present(navController, animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                   
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    
    @IBAction func ActionCutViewChangePswd(_ sender: Any) {
         self.viewchangePswd.isHidden = true
    }
    
    
    @IBAction func ActionSubmitNewPswd(_ sender: Any) {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        if((tfOldPassword.text?.count)! < 6 || (tfNewPassword.text?.count)! < 6 || (tfConfirmPassword.text?.count)! < 6)
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
        _=NetworkHelper().makeRequest(withAPIProvider: .changePassword(userId: String(GlobalLoginUSerDetail?.id ?? 0), oldPassword: tfOldPassword.text!, newPassword: tfNewPassword.text!, confirmPassword: tfConfirmPassword.text!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                
                if statusCode == 200
                {
                    self.viewchangePswd.isHidden = true
                    self.showAlert(withMessage: responseBodyModel.responseMessage ?? "")
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
