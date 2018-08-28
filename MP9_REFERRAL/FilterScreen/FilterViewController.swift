//
//  FilterViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit
class FilterViewController: UIViewController,FBSDKSharingDelegate, UITextViewDelegate,UIGestureRecognizerDelegate {
   
    @IBOutlet weak var VIEWROUNDRECNXCONGRATS: UIView!
    
    @IBOutlet weak var viewInsideScrollHeight: UIView!
    
    @IBOutlet weak var heightConstViewINsideScroll: NSLayoutConstraint!
    
    @IBOutlet weak var viewInsideScrollVericalCenter: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewPost: UIView!
    
    @IBOutlet weak var viewBlackishTermsCond: UIView!
    
    @IBOutlet weak var viewTermsCond: UIView!
    
    @IBOutlet weak var viewHavingTermsText: UIView!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    
    @IBOutlet weak var labelTermsCond: UILabel!
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var viewRECNXCongrats: UIView!
    
    @IBOutlet weak var labelYouMayEdit: UILabel!
    
    @IBOutlet weak var labelAcceptRecmFor: UILabel!
    
    @IBOutlet weak var textViewHelpText: UITextView!
    
    @IBOutlet weak var viewHelpText: UIView!
    
    @IBOutlet weak var labelHelpText: UILabel!
    
    @IBOutlet weak var viewHours1: UIView!
    
    @IBOutlet weak var viewHours2: UIView!
     var catName:String?
    var PostDateSelected:String?
    var postID:Int?
    var postURL:String?
    var didPostedOnFacebook:String?
    var didPostedOnTwitter:String?
    
    var intFacebookSelected:Int?
    var intTwtrSelected:Int?
    var surveyParams = SurveyParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        didPostedOnFacebook = "0"
        didPostedOnTwitter = "0"
        self.VIEWROUNDRECNXCONGRATS.layer.cornerRadius = 8.0
        self.VIEWROUNDRECNXCONGRATS.clipsToBounds = true
        self.btnOK.layer.cornerRadius = 5.0
        self.btnOK.clipsToBounds = true
        PostDateSelected = ""
        var strHelpText = "Can anyone recommend a good "
        strHelpText = strHelpText + String(self.catName ?? "") + " in or around " + String(self.surveyParams.postCity ?? "")
        strHelpText = strHelpText + ". Here are a couple of things that are important to me " + ". Any help is appreciated."
        self.textViewHelpText.delegate = self
        self.textViewHelpText.text = strHelpText
        self.labelHelpText.text = String(self.postURL ?? "")
        self.viewHelpText.layer.cornerRadius = 4.0
        self.viewHelpText.clipsToBounds = true
        self.viewHelpText.layer.borderWidth = 2.0
        self.viewHelpText.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        
        self.viewHavingTermsText.layer.cornerRadius = 5.0
        self.viewHavingTermsText.clipsToBounds = true
        
        if UIScreen.main.sizeType == .iPhone5 ||  UIScreen.main.sizeType == .iPhone4 {
            if  UIScreen.main.sizeType == .iPhone4
            {
                self.heightConstViewINsideScroll.constant = 430
                self.heightConstViewINsideScroll.priority = UILayoutPriority(rawValue: 1000)
                self.viewInsideScrollVericalCenter.priority = UILayoutPriority(rawValue: 250)
            }
        }
        else{
            
            self.heightConstViewINsideScroll.priority = UILayoutPriority(rawValue: 250)
            self.viewInsideScrollVericalCenter.priority = UILayoutPriority(rawValue: 1000)
            
            
            textViewHelpText.font = textViewHelpText.font?.withSize(17)
            labelAcceptRecmFor.font = labelAcceptRecmFor.font.withSize(19)
            labelYouMayEdit.font = UIFont.boldSystemFont(ofSize: 15.0)
            
        }
        self.labelTermsCond.text = "Because many businesses may want to thank you for providng this recommendation we may share some or all of the information you provided.  By click this box you consent to allow us to share this review for the betterment of the business you have mention."
        self.labelTermsCond.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGest))
        tap.delegate = self // This is not required
        viewBlackishTermsCond.addGestureRecognizer(tap)
       
    }
    @objc func handleTapGest(sender: UITapGestureRecognizer? = nil) {
        self.viewTermsCond.isHidden = true
    }
    override func viewDidLayoutSubviews() {
       self.labelTermsCond.sizeToFit()
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
    
    
    @IBAction func ActionCheckBox(_ sender: Any) {
        if self.imgCheckBox.image == UIImage(named:"checkbox_3x")
        {
            self.imgCheckBox.image = UIImage(named:"checkbox_checked_3x")
        }
        else{
            self.imgCheckBox.image = UIImage(named:"checkbox_3x")
        }
    }
    
    
    
    @IBAction func ActionDonePost(_ sender: Any) {
        if self.imgCheckBox.image == UIImage(named:"checkbox_3x")
        {
            self.showAlert(withMessage: "Please Check the Terams and Conditions!")
            return
        }
        self.viewTermsCond.isHidden = true
       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func ActionRECNXCongrats(_ sender: Any) {
        self.viewRECNXCongrats.isHidden = true
        self.viewPost.isHidden = true
        //let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        //let navController = UINavigationController(rootViewController: dashBoardNav)
       // navController.navigationBar.isHidden = true
       // self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func HoursAction(_ sender: Any) {
        for btn in self.viewHours1.subviews
        {
            if btn is UIButton && btn.tag == (sender as! UIButton).tag{
                (btn as! UIButton).backgroundColor = UIColor(red:254/255, green: 61/255, blue: 2/255, alpha: 1.0)
                PostDateSelected = (btn as! UIButton).currentTitle
            }
            else{
                (btn as! UIButton).backgroundColor = UIColor(red:0/255, green: 33/255, blue: 170/255, alpha: 1.0)
            }
        }
        /////////////
        for btn in self.viewHours2.subviews
        {
            if btn is UIButton && btn.tag == (sender as! UIButton).tag{
                (btn as! UIButton).backgroundColor = UIColor(red:254/255, green: 61/255, blue: 2/255, alpha: 1.0)
                 PostDateSelected = (btn as! UIButton).currentTitle
            }
            else{
                (btn as! UIButton).backgroundColor = UIColor(red:0/255, green: 33/255, blue: 170/255, alpha: 1.0)
            }
        }
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ActionOfPOST(_ sender: Any) {
        if(PostDateSelected == "")
        {
            self.showAlert(withMessage: "Please Select Time")
            return
        }
        if textViewHelpText.text == ""
        {
            self.showAlert(withMessage: "Please enter the message to share !")
            return
        }
        self.funcCheckForSocialShare()
       
    }
    
    func funcFacebookShare()
    {
        let strLinkToShare = self.postURL! + "&pf=101"
        print("urlFB===\(strLinkToShare)")
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
       // content.quote = textViewHelpText.text
        content.contentURL = NSURL(string: strLinkToShare)! as URL
        //let img :UIImage = self.textToImage(drawText: "text written on Image", inImage: UIImage(named:"get_recommendation_3x"), atPoint: CGPoint(x: 10, y: 20))
        
        
        let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        
        let application = UIApplication.shared
        if application.canOpenURL(NSURL(string: "fb://")! as URL)
        {
            self.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideLoading()
                
            }
            shareDialog.mode = .feedWeb
            shareDialog.show()
        }
        else
        {
            shareDialog.mode = .feedWeb
            shareDialog.show()
        }
    }
    
   func funcCheckForSocialShare()
   {
    
    if(self.intFacebookSelected == 1)
    {
        self.funcFacebookShare()
        
    }
    else if(self.intTwtrSelected == 1)
    {
        self.funcShareONTwitter()
    }
    
    else{
        self.viewRECNXCongrats.isHidden = false
    }
   
    }
    func funcShareONTwitter()
    {
        
        let composer = TWTRComposer()
         let strLinkToShare = self.postURL! + "&pf=202"
        composer.setText(textViewHelpText.text)
        composer.setURL(NSURL(string: strLinkToShare)! as URL)
      //  composer.setImage(UIImage(named: "fabric"))
        
        // Called from a UIViewController
        composer.show(from: self) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
                self.didPostedOnTwitter = "0"
                if ( self.didPostedOnFacebook == "0")
                {
                    self.funcShowSurveyPostCancelled()
                }
                else
                {
                    self.viewRECNXCongrats.isHidden = false
                }
            }
            else {
                print("Sending tweet!")
                self.didPostedOnTwitter = "1"
                self.funcShareUpdateStatus(strFacebook:self.didPostedOnFacebook!, strTwtr: self.didPostedOnTwitter!)
            }
        }
        
        
      /* DispatchQueue.main.async {
        
        let application = UIApplication.shared
        if application.canOpenURL(NSURL(string: "twitter://")! as URL)
        {
        self.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideLoading()
            
        }
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let strLinkToShare = self.postURL! + "&pf=202"
        let urlToShare = NSURL(string: strLinkToShare)! as URL
        vc?.add(urlToShare)
            
            vc?.setInitialText(self.textViewHelpText.text)
        
        self.present(vc!, animated: true, completion: nil)
        vc?.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
            switch result {
                case SLComposeViewControllerResult.cancelled:
                print("Cancelled")
                self.didPostedOnTwitter = "0"
                if ( self.didPostedOnFacebook == "0")
                {
                 self.funcShowSurveyPostCancelled()
                }
                else
                {
                self.viewRECNXCongrats.isHidden = false
                }
                
                break
            case SLComposeViewControllerResult.done:
                self.didPostedOnTwitter = "1"
                self.funcShareUpdateStatus(strFacebook:self.didPostedOnFacebook!, strTwtr: self.didPostedOnTwitter!)
                
            }
            
        }
            
        }
        
        
        else
        {
            self.showAlert(withMessage: "Please Install the Twitter App !")
        }
        }*/
    }
    
    
   //////////FB DELEGATE METHODS
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("FBShareREsponse==\(results)")
        self.didPostedOnFacebook = "1"
        self.funcShareUpdateStatus(strFacebook:self.didPostedOnFacebook!, strTwtr: self.didPostedOnTwitter!)
        
    }
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("FBError=\(error.localizedDescription)")
         self.funcFacebookShare()
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("FBCancel")
        self.didPostedOnFacebook = "0"
        if(self.intTwtrSelected == 1)
        {
            self.funcShareONTwitter()
        }
        else
        {
            self.funcShowSurveyPostCancelled()
        }
    }
    
    func funcShowSurveyPostCancelled()
    {
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: "RecNX", message: "Your survey post has been cancelled !", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
           
                //let dashBoardNav = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                //let navController = UINavigationController(rootViewController: dashBoardNav)
               // navController.navigationBar.isHidden = true
               // self.navigationController?.present(navController, animated: true, completion: nil)
        }
        
        alertController.addAction(OKAction)
       
        self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func funcShareUpdateStatus(strFacebook:String, strTwtr:String)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        print("postIDGot=\(String(self.postID ?? 0))")
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .UpdatePostSharedStatus(userID: String(GlobalLoginUSerDetail?.id ?? 0), postID: String(self.postID ?? 0), facebook: strFacebook, twitter: strTwtr, RECNXCommunity: "0",postDate: PostDateSelected ?? "",socialMessage: textViewHelpText.text), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    if(strTwtr == "0")
                    {
                        if(self.intTwtrSelected == 1)
                        {
                            self.funcShareONTwitter()
                        }
                        else
                        {
                            self.viewRECNXCongrats.isHidden = false
                        }
                    }
                    else
                    {
                        self.viewRECNXCongrats.isHidden = false
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
