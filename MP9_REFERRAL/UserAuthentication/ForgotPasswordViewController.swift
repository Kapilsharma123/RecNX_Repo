//
//  ForgotPasswordViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tfCountryCode: UITextField!
    
    @IBOutlet weak var BtnSubmit: UIButton!
    
    @IBOutlet weak var viewCountryCode: UIView!
    
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var viewShowCountryList: UIView!
    
    @IBOutlet weak var tableViewMain: UITableView!
    var BlogCountryList: StateCity.CountryListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //////20AUG
        self.countryCodeSelected = "+1"
        self.countryIdSelected = "231"
        //////
        self.setUpUI()
    }
    func setUpUI()
    {
        self.viewPhone.layer.cornerRadius = 10.0
        self.viewPhone.clipsToBounds = true
        self.viewCountryCode.layer.cornerRadius = 10.0
        self.viewCountryCode.clipsToBounds = true
        self.BtnSubmit.layer.cornerRadius = 10.0
        self.BtnSubmit.clipsToBounds = true
       // self.viewPhone.layer.borderWidth = 1.0
        //self.viewPhone.layer.borderColor = UIColor.gray.cgColor
        tfPhone.delegate = self
        tfCountryCode.delegate = self
        
        tfPhone.keyboardType = .numberPad
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneAction));
        toolbar.setItems([spaceButton,nextButton], animated: false)
        tfPhone.inputAccessoryView = toolbar
        
    }
    
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func DoneAction(){
        tfPhone.resignFirstResponder()
    }
    
    @IBAction func ActionCutViewCountryList(_ sender: Any) {
        self.viewShowCountryList.isHidden = true
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
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
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
                    self.tableViewMain.delegate = self
                    self.tableViewMain.dataSource = self
                    self.tableViewMain.reloadData()
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

    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionSubmit(_ sender: Any) {
        
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
        
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .forgotPassword(countryCode: self.countryCodeSelected!, phoneNo: self.tfPhone.text!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
               
                if statusCode == 200
                {
                    self.funcGoToVerifyOTP()
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
        
    }
    func funcGoToVerifyOTP()
    {
        if  let otpVC : VerifyOTPViewController = self.storyboard!.instantiateViewController(withIdentifier: "verifyOTP") as? VerifyOTPViewController
        {
            otpVC.countryCode = self.countryCodeSelected
            otpVC.phone = self.tfPhone.text
            otpVC.fromForgotPassword = true
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
