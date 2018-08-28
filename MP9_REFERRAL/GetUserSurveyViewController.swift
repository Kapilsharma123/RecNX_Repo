//
//  GetUserSurveyViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class GetUserSurveyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var blogUsersSurveyList: UsersSurvey?
    var blogUserClosedSurveyList: UserClosedSurvey?
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    @IBOutlet weak var imageNoData: UIImageView!
    
    @IBOutlet weak var viewActiveClosed: UIView!
    
    @IBOutlet weak var BtnActive: UIButton!
    
    @IBOutlet weak var BtnClosed: UIButton!
    var selectedStattus:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedStattus = 1
        viewActiveClosed.layer.borderWidth = 2.0
        viewActiveClosed.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        BtnActive.backgroundColor = UIColor(red:4/255, green: 83/255, blue: 170/255, alpha: 1.0)
        BtnClosed.backgroundColor = UIColor.clear
        
        TableViewMain.register(UINib(nibName: "PostedSurveyDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        TableViewMain.setContentOffset(.zero, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.TableViewMain.isHidden = true
        if self.selectedStattus == 1
        {
            self.funcGetUserSurveyList()
        }
        else
        {
             self.funcGetUserClosedSurvey()
        }
        
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionActiveBtn(_ sender: Any) {
        BtnActive.backgroundColor = UIColor(red:4/255, green: 83/255, blue: 170/255, alpha: 1.0)
        BtnClosed.backgroundColor = UIColor.clear
        self.TableViewMain.isHidden = true
        self.funcGetUserSurveyList()
       
    }
    
    @IBAction func ActionClosedBtn(_ sender: Any) {
        BtnClosed.backgroundColor = UIColor(red:4/255, green: 83/255, blue: 170/255, alpha: 1.0)
        BtnActive.backgroundColor = UIColor.clear
        self.TableViewMain.isHidden = true
        self.funcGetUserClosedSurvey()
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //GetUsersClosedSurvey
    func funcGetUserSurveyList()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .GetUsersSurvey(userId: /*"102"*/String(GlobalLoginUSerDetail?.id ?? 0)), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                   // self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    self.imageNoData.isHidden = false
                    return
                }
                if statusCode == 200
                {
                    guard let userSurveyList = try? JSONDecoder().decode(UsersSurvey.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.imageNoData.isHidden = true
                    self.blogUsersSurveyList = userSurveyList
                    self.selectedStattus = 1
                    if((self.blogUsersSurveyList?.data?.count)! > 0)
                    {
                        self.TableViewMain.isHidden = false
                    }
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    self.TableViewMain.setContentOffset(.zero, animated: true)
                   
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    
    func funcGetUserClosedSurvey()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .GetUsersClosedSurvey(userId: /*"102"*/String(GlobalLoginUSerDetail?.id ?? 0)), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                   // self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    self.imageNoData.isHidden = false
                    return
                }
                if statusCode == 200
                {
                    guard let userSurveyList = try? JSONDecoder().decode(UserClosedSurvey.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.imageNoData.isHidden = true
                    self.blogUserClosedSurveyList = userSurveyList
                    self.selectedStattus = 2
                    if((self.blogUserClosedSurveyList?.data?.count)! > 0)
                    {
                        self.TableViewMain.isHidden = false
                    }
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    self.TableViewMain.setContentOffset(.zero, animated: true)
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
               
            } else {
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.selectedStattus == 1)
        {
        return (self.blogUsersSurveyList?.data?.count)!
        }
        else
        {
            return (self.blogUserClosedSurveyList?.data?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PostedSurveyDetailTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as! PostedSurveyDetailTableViewCell?)!
        
        cell.labelBusinessName.isHidden = false
        cell.BtnBusinessName.isHidden = false
        cell.BtnBusinessName.isUserInteractionEnabled = true
    
        cell.BtnBusinessName.tag = indexPath.row
        cell.BtnBusinessName.addTarget(self, action: #selector(self.ButtonBusinessPressed(_:)), for: UIControlEvents.touchUpInside)
        cell.BtnViewNow.tag = indexPath.row
        cell.BtnViewNow.addTarget(self, action: #selector(self.ButtonViewNowPressed(_:)), for: UIControlEvents.touchUpInside)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
        
        if(self.selectedStattus == 1)
        {
        let dict = self.blogUsersSurveyList?.data![indexPath.row]
            cell.labelCategory.text = dict?.categoryName
            cell.labelSubCategory.text = dict?.SubCategoriesNames ?? "--"
            cell.labelCity.text = dict?.city
            cell.labelEndDate.text = dict?.endDate ?? ""
            cell.labelPostDate.text = dict?.postDate ?? ""
            cell.labelNoOfRecomm.text = String(dict?.noOfRecomm ?? 0)
           
            cell.labelBusinessName.isHidden = true
            cell.BtnBusinessName.isHidden = true
            
            let EndDate = inputFormatter.date(from: dict?.endDate ?? "")
            inputFormatter.dateFormat = "MMM dd yyyy, h:mm a"
            
            if (EndDate != nil)
            {
                let EndDateString = inputFormatter.string(from: EndDate! )
                cell.labelEndDate.text = EndDateString
            }
           
            inputFormatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
            let PostDate = inputFormatter.date(from: dict?.postDate ?? "")
            inputFormatter.dateFormat = "MMM dd yyyy, h:mm a"
            if (PostDate != nil)
            {
                let PostDateString = inputFormatter.string(from: PostDate! )
                cell.labelPostDate.text = PostDateString
            }
          
        }
        else{
             let dict = self.blogUserClosedSurveyList?.data![indexPath.row]
            cell.labelCategory.text = dict?.categoryName
            cell.labelSubCategory.text = dict?.SubCategoriesNames ?? "--"
            cell.labelCity.text = dict?.city
            cell.labelEndDate.text = dict?.endDate ?? ""
            cell.labelPostDate.text = dict?.postDate ?? ""
            cell.labelNoOfRecomm.text = String(dict?.noOfRecomm ?? 0)
            cell.labelBusinessName.text = dict?.businessName
            if cell.labelBusinessName.text == "" || dict?.noOfRecomm == 0
            {
                cell.labelBusinessName.text = "N/A"
                cell.BtnBusinessName.isUserInteractionEnabled = false
            }
            let EndDate = inputFormatter.date(from: dict?.endDate ?? "")
            inputFormatter.dateFormat = "MMM dd yyyy, h:mm a"
            
            if (EndDate != nil)
            {
                let EndDateString = inputFormatter.string(from: EndDate! )
                cell.labelEndDate.text = EndDateString
            }
            
            inputFormatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
            let PostDate = inputFormatter.date(from: dict?.postDate ?? "")
            inputFormatter.dateFormat = "MMM dd yyyy, h:mm a"
            if (PostDate != nil)
            {
                let PostDateString = inputFormatter.string(from: PostDate! )
                cell.labelPostDate.text = PostDateString
            }
        
        }
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            cell.labelCategory.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.labelSubCategory.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.labelPostDate.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.labelEndDate.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.labelNoOfRecomm.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.labelCity.font = UIFont.boldSystemFont(ofSize: 13.0)
        }
        else{
            cell.labelCategory.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.labelSubCategory.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.labelPostDate.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.labelEndDate.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.labelNoOfRecomm.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.labelCity.font = UIFont.boldSystemFont(ofSize: 16.0)
            
        }
        cell.labelNoOfRecomm.layer.cornerRadius = 4.0
        cell.labelNoOfRecomm.clipsToBounds = true
        
        
        cell.viewInsideZCell.layer.cornerRadius = 6.0
        cell.viewInsideZCell.clipsToBounds = true
        cell.viewInsideZCell.layer.borderWidth = 2.0
        cell.viewInsideZCell.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4{
            cell.labelBusinessName.font = cell.labelBusinessName.font.withSize(14)
        }
        else{
           
            cell.labelBusinessName.font = cell.labelBusinessName.font.withSize(16)
            
        }
        cell.selectionStyle = .none
        return cell
    }
    @objc func ButtonViewNowPressed(_ sender : UIButton)
    {
        if(self.selectedStattus == 1)
        {
            let dict = self.blogUsersSurveyList?.data![sender.tag]
            if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
            {
                suggestedVC.postId = dict?.postId
                suggestedVC.surveyId = dict?.surveyId
                self.navigationController?.pushViewController(suggestedVC, animated: true)
            }
        }
        else
        {
            let dict = self.blogUserClosedSurveyList?.data![sender.tag]
           // if  dict?.businessName != ""
            //{
                if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
                {
                    suggestedVC.postId = dict?.postId
                    suggestedVC.surveyId = dict?.surveyId
                    suggestedVC.shoeClosedSurveyRecommendations = true
                    self.navigationController?.pushViewController(suggestedVC, animated: true)
                }
            //}
        }
    }
    @objc func ButtonBusinessPressed(_ sender : UIButton)
    {
        let dict = self.blogUserClosedSurveyList?.data![sender.tag]
        if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
        {
            suggestedVC.showClosedSurveyBusinessQuestions = true
            suggestedVC.dictForUserClosedSurvey = dict
            self.navigationController?.pushViewController(suggestedVC, animated: true)
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(self.selectedStattus == 1)
        {
        return tableView.frame.size.height/1.6 + 50//305
        }
        else{
            return (tableView.frame.size.height/1.6) + 50 + 50//345
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if(self.selectedStattus == 1)
        {
            let dict = self.blogUsersSurveyList?.data![indexPath.row]
            if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
            {
                suggestedVC.postId = dict?.postId
                suggestedVC.surveyId = dict?.surveyId
                self.navigationController?.pushViewController(suggestedVC, animated: true)
            }
        }
        else
        {
            let dict = self.blogUserClosedSurveyList?.data![indexPath.row]
           // if  dict?.businessName != ""
           // {
                if  let suggestedVC : SuggestedRecommendationViewController = self.storyboard!.instantiateViewController(withIdentifier: "SuggestedRecommendationVC") as? SuggestedRecommendationViewController
                {
                    suggestedVC.postId = dict?.postId
                    suggestedVC.surveyId = dict?.surveyId
                    suggestedVC.shoeClosedSurveyRecommendations = true
                    self.navigationController?.pushViewController(suggestedVC, animated: true)
                }
            //}
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
