//
//  HomeViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 17/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,UINavigationControllerDelegate {
    
    
    

    @IBOutlet weak var viewRecommendation1: UIView!
    
    @IBOutlet weak var viewRecommendation2: UIView!
    
    
    @IBOutlet weak var labelGetRecm: UILabel!
    
    @IBOutlet weak var labelMyRecm: UILabel!
    
    
    @IBOutlet weak var TopConst1: NSLayoutConstraint!
    
    @IBOutlet weak var TopConst2: NSLayoutConstraint!
    
    
    @IBOutlet weak var TopConst3: NSLayoutConstraint!
    
    @IBOutlet weak var labelMyProfile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if UIScreen.main.sizeType == .iPhone4
         
         {
            TopConst1.constant = 10
            TopConst2.constant = 10
            TopConst3.constant = 10
            
         }
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
           
        }
        else{
            labelGetRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
           labelMyRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
           labelMyProfile.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        self.setUpUI()
        self.funcNavigationSetUp()
         let nc = NotificationCenter.default
         nc.addObserver(self, selector: #selector(funcUpdateFCMToken), name: Notification.Name("UserUpdateToken"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.funcGetNotificationInfo(_:)), name: NSNotification.Name(rawValue: "BusinessNotification"), object: nil)
    }
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @objc func funcGetNotificationInfo(_ notification: NSNotification) {
        
        if let postID = notification.userInfo!["post_id"] as? String {
            print("postID_Is==\(postID)")
        }
        
        
        if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
        {
            suggestedVC.postId = Int((notification.userInfo!["post_id"] as? String)!)
            suggestedVC.surveyId = Int((notification.userInfo!["survey_id"] as? String)!)
            self.navigationController?.pushViewController(suggestedVC, animated: true)
        }
        
        
        
        
    }
    @objc func funcUpdateFCMToken(_ notification:Notification)
    {
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .UpdateDeviceId(userId: String(GlobalLoginUSerDetail?.id ?? 0), savedDeviceID: String(GlobalLoginUSerDetail?.savedDeviceId ?? 0), deviceId: AuthToken.FCMToken), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {      
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil else {
                   // self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    print("")
                    
                }
                else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    
    @IBAction func ActionMyProfile(_ sender: Any) {
        if  let myProfileVC : MyProfileViewController = self.storyboard!.instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileViewController
        {
           
            self.navigationController?.pushViewController(myProfileVC, animated: true)
        }
    }
    
    func setUpUI()
    {
        addSlideMenuButton()
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.delegate = self
        self.viewRecommendation1.layer.cornerRadius = 8.0
        self.viewRecommendation1.clipsToBounds = true
        self.viewRecommendation2.layer.cornerRadius = 8.0
        self.viewRecommendation2.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 208/255, blue: 240/255, alpha: 1.0)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if (navigationController.viewControllers.count > 1)
        {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
        else
        {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    @IBAction func ActionRecommendations(_ sender: UIButton) {
        if(sender.tag == 1)
        {
         self.performSegue(withIdentifier: "toSelectCategory", sender: self)
        }
        else
        {
            if  let userSurveyList : GetUserSurveyViewController = self.storyboard!.instantiateViewController(withIdentifier: "UserSurveyList") as? GetUserSurveyViewController
            {
                self.navigationController?.pushViewController(userSurveyList, animated: true)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
