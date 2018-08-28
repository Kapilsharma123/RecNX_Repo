//
//  SocialSharingViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 31/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class SocialSharingViewController: UIViewController,FBSDKSharingDelegate,FBSDKLoginButtonDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
   
    

     var surveyParams = SurveyParams()
     var catName:String?
    var BlogStatesList: StateCity.StatesListing?
    var BlogCitiesList: StateCity.CitiesListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    var stateIdSelected : String?
    var cityIdSelected : String?
    
    @IBOutlet weak var viewShowCountryList: UIView!
    
    @IBOutlet weak var labelSelectCountry: UILabel!
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    
    @IBOutlet weak var BtnFacebook: UIButton!
    
    @IBOutlet weak var labelLookingForCat: UILabel!
    
    @IBOutlet weak var viewcity: UIView!
    
    @IBOutlet weak var BtnTwitter: UIButton!
    
    @IBOutlet weak var BtnRECNXCommunity: UIButton!
    
    @IBOutlet weak var tfCityName: UITextField!
    
    
    @IBOutlet weak var viewState: UIView!
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var viewFacebook: UIView!
    
    @IBOutlet weak var imgCheckFacebook: UIImageView!
    
    @IBOutlet weak var viewTwitter: UIView!
    
    @IBOutlet weak var imgCheckTwtr: UIImageView!
    var postID:Int?
    var postURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.countryIdSelected = GlobalLoginUSerDetail?.countryId
        self.countryCodeSelected = GlobalLoginUSerDetail?.countryCode
        self.stateIdSelected = String(GlobalLoginUSerDetail?.state?.id ?? 0)
        self.cityIdSelected = String(GlobalLoginUSerDetail?.city?.id ?? 0)
        if self.countryIdSelected == nil || self.countryIdSelected == ""
        {
            self.countryIdSelected = "231"
            self.countryCodeSelected = "+1"
        }
        
        self.imgCheckFacebook.image = UIImage(named:"checkbox_3x")
        self.imgCheckTwtr.image = UIImage(named:"checkbox_3x")
        if GlobalLoginUSerDetail?.city?.name != ""
        {
             self.tfCityName.text = GlobalLoginUSerDetail?.city?.name
        }
        if GlobalLoginUSerDetail?.state?.name != ""
        {
        self.tfState.text = GlobalLoginUSerDetail?.state?.name
        }
        
        self.tfState.delegate = self
        self.tfCityName.delegate = self
        self.viewFacebook.layer.cornerRadius = 4.0
        self.viewFacebook.clipsToBounds = true
        self.viewFacebook.layer.borderWidth = 2.0
         self.viewFacebook.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        
        self.viewcity.layer.cornerRadius = 4.0
        self.viewcity.clipsToBounds = true
        self.viewcity.layer.borderWidth = 2.0
        self.viewcity.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        self.viewState.layer.cornerRadius = 4.0
        self.viewState.clipsToBounds = true
        self.viewState.layer.borderWidth = 2.0
        self.viewState.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        
        self.viewTwitter.layer.cornerRadius = 4.0
        self.viewTwitter.clipsToBounds = true
        self.viewTwitter.layer.borderWidth = 2.0
        self.viewTwitter.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        self.labelLookingForCat.text = "Okay, you're looking for a new " + self.catName! + "? " + "Lets get help from your friends."//"Okay, you're looking for a new dentist? Lets get help from your friends."
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            
        }
        else{
        self.labelLookingForCat.font = self.labelLookingForCat.font.withSize(17)
        }
        
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
    
    
    @IBAction func ActionCutCountryList(_ sender: Any) {
        self.viewShowCountryList.isHidden = true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        
        case tfState:
            
            self.funcGetAllStatesByCountryId()
           
            return false
        case tfCityName:
            if(self.stateIdSelected != nil && self.stateIdSelected != "" && self.stateIdSelected != "0")
            {
            self.funcGetAllCitiesByStateId()
            }
            else
            {
                self.showAlert(withMessage: "Please select State first")
            }
            
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
    
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                    self.TableViewMain.tag = 2
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    self.viewShowCountryList.isHidden = false
                    self.labelSelectCountry.text = "Select State"
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
                    self.labelSelectCountry.text = "Select City"
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
            self.tfCityName.text = ""
        }
        else
        {
            let dic = BlogCitiesList?.cities[indexPath.row]
            self.cityIdSelected = String((dic?.id)!)
            self.tfCityName.text = dic?.name
        }
        self.viewShowCountryList.isHidden = true
    }
    
    @IBAction func ActionOfNext(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        if self.tfCityName.text == nil || self.tfCityName.text == ""
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseAddCity)
            return
        }
        if self.imgCheckTwtr.image == UIImage(named:"checkbox_3x") && self.imgCheckFacebook.image == UIImage(named:"checkbox_3x")
        {
            self.showAlert(withMessage: "Please Select Facebook share to proceed !")
            return
        }
        
        surveyParams.postId = ""
        surveyParams.facebook = "0"
        surveyParams.twitter = "0"
        surveyParams.postCity = tfCityName.text
        surveyParams.RECNXCommunity = "0"
        print("SurveyParameters==\(surveyParams)")
        
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .PostSurvey(withSurvey: surveyParams), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                
                if statusCode == 200
                {
                    
                    if  let filterVC : FilterViewController = self.storyboard!.instantiateViewController(withIdentifier: "FilterVC") as? FilterViewController
                    {
                        guard let blog = try? JSONDecoder().decode(PostSurveyResponse.self, from: responseBodyModel.bodyData!)
                            else
                        {
                            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                            return
                        }
                        filterVC.postID = blog.postID
                        filterVC.postURL = blog.postURL
                        self.surveyParams.postId  = String(blog.postID ?? 0)
                        filterVC.surveyParams = self.surveyParams
                        
                        filterVC.intFacebookSelected = 0
                        filterVC.intTwtrSelected = 0
                        filterVC.catName = self.catName
                        if self.imgCheckFacebook.image == UIImage(named:"checkbox_checked_3x")
                        {
                            filterVC.intFacebookSelected = 1
                        }
                        if self.imgCheckTwtr.image == UIImage(named:"checkbox_checked_3x")
                        {
                            filterVC.intTwtrSelected = 1
                        }
                        
                        self.navigationController?.pushViewController(filterVC, animated: true)
                    }
                }
                else
                {
                    
                }
                
            } else {
                
            }
        })
        
    }
    

    @IBAction func ActionFBShare(_ sender: Any) {
       /* let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        //var deeplinkUrl =  "https://www.google.com"//self.dictOffer!["offer_id"] as? String
       // deeplinkUrl =  AppInfo.BaseUrl + "/Sharer/kolforce/" + deeplinkUrl!
        content.contentURL = NSURL(string: "https://www.google.com")! as URL
        let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        shareDialog.show()*/
        
       /* if (FBSDKAccessToken.current() != nil)
        {
            self.getFacebookUserPosts()
            return
        }
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends", "user_posts"]
        loginView.delegate = self*/
        
        if self.imgCheckFacebook.image == UIImage(named:"checkbox_3x")
        {
            self.imgCheckFacebook.image = UIImage(named:"checkbox_checked_3x")
        }
        else{
            self.imgCheckFacebook.image = UIImage(named:"checkbox_3x")
        }
       
        
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("result==\(result)")
        if (FBSDKAccessToken.current() != nil)
        {
            self.getFacebookUserPosts()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
   
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("FBShareREsponse==\(results)")
      
        self.imgCheckFacebook.image = UIImage(named:"checkmark")
        self.BtnFacebook.isUserInteractionEnabled = false
        self.BtnRECNXCommunity.isHidden = false
        
         // FBSDKAccessToken.current().userID
       // if((FBSDKAccessToken.currentAccessToken()) != nil){
           // FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
              //  if (error == nil){
                 //   println(result)
              //  }
           // })
      //  }
        // http://ashishkakkad.com/2016/04/get-reactions-from-timeline-post-via-facebook-graph-api-swift-ios/
        
      
    }
    
   
    func getFacebookUserPosts() {
        var strGraphPath : String = ""
        
        FBSDKGraphRequest(graphPath: "/me/posts", parameters: nil, httpMethod: "GET").start(completionHandler: { (connection, result, error) in
            if (error == nil){
                print(result)
                let data = (result as! [String : Any])["data"] as! [[String : Any]]
                if(data.count > 0) {
                    let strId = data[0]["id"] as! String
                    strGraphPath = "/"+strId+"/reactions"
                    self.getReactions(strGraphPath)
                }
            }
            else{
                print("error==\(error)")
            }
        })
    }
    func getReactions(_ strGraphPath:String) {
        FBSDKGraphRequest(graphPath: strGraphPath, parameters: ["fields":"id, name, type", "summary":"total_count, viewer_reaction"], httpMethod: "GET").start(completionHandler: { (connection, result, error) in
            if (error == nil){
                print(result)
            }
        })
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("FBError")
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("FBCancel")
    }
   
   
    
    @IBAction func ActionTwtrShare(_ sender: Any) {
        if self.imgCheckTwtr.image == UIImage(named:"checkbox_3x")
        {
            self.imgCheckTwtr.image = UIImage(named:"checkbox_checked_3x")
        }
        else{
            self.imgCheckTwtr.image = UIImage(named:"checkbox_3x")
        }
    }
   
    
    @IBAction func ActionRECNXCommunity(_ sender: Any) {
        
    if  let RecmVC : GiveRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "GiveRecommendationVC") as? GiveRecommendationViewController
        {
            RecmVC.surveyParams = self.surveyParams
            self.navigationController?.pushViewController(RecmVC, animated: true)
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
