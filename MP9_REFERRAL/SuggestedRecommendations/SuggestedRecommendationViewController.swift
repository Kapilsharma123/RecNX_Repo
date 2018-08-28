//
//  SuggestedRecommendationViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SuggestedRecommendationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{

    var postId: Int?
    var surveyId: Int?
    var blogSurveyRecommendations: GetSurveyRecommendations?
    
    var showClosedSurveyBusinessQuestions = false
    var shoeClosedSurveyRecommendations = false
    var dictForUserClosedSurvey:UserClosedSurveyArray?
    var AcceptRecommResponse1: AcceptRecommResponse?
    
    @IBOutlet weak var imageNoData: UIImageView!
    
    @IBOutlet weak var viewEmailReceiveRounded: UIView!
    
    @IBOutlet weak var BtnOkEmailRec: UIButton!
    
    @IBOutlet weak var viewEmailReceived: UIView!
    
    @IBOutlet weak var labelEmailText: UILabel!
    
    @IBOutlet weak var viewChecKForDeals: UIView!
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var labelNoOfRecmc: UILabel!
    
    @IBOutlet weak var labelCheckForDeal: UILabel!
    
    @IBOutlet weak var BtnCheckFordeals: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelNoOfRecmc.isHidden = true
        self.labelCheckForDeal.text = "Check for Deals"
        self.viewEmailReceiveRounded.layer.cornerRadius = 8.0
        self.viewEmailReceiveRounded.clipsToBounds = true
        self.BtnOkEmailRec.layer.cornerRadius = 5.0
        self.BtnOkEmailRec.clipsToBounds = true
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            
        }
        else{
            labelCheckForDeal.font = UIFont.boldSystemFont(ofSize: 19.0)
            labelEmailText.font = labelEmailText.font.withSize(18)
            
        }
        self.funcNavigationSetUp()
        self.BtnCheckFordeals.layer.cornerRadius = 10.0
        self.BtnCheckFordeals.clipsToBounds = true
        tableViewMain.register(UINib(nibName: "SuggestedRecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewMain.estimatedRowHeight = 60.0 // 24AUG
        tableViewMain.rowHeight = UITableViewAutomaticDimension
        //////////////////////
        tableViewMain.setContentOffset(.zero, animated: true)
        
        if self.showClosedSurveyBusinessQuestions == true || self.shoeClosedSurveyRecommendations == true
        {
            self.viewChecKForDeals.isHidden = false//true
        }
       if(self.showClosedSurveyBusinessQuestions == true)
       {
        self.labelNoOfRecmc.text = "You received the following Recommendation"
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        self.tableViewMain.reloadData()
       }
       else
       {
        self.funcGetSuggestedRecommendations()
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
    
    
    @IBAction func ActionOKEmailReceived(_ sender: Any) {
        self.viewEmailReceived.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func funcGetSuggestedRecommendations()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
            self.showLoading()
            _=NetworkHelper().makeRequest(withAPIProvider: .GetSurveyRecommendations(userId: /*"102"*/String(GlobalLoginUSerDetail?.id ?? 0), postId: /*"2163"*/String(self.postId ?? 0), surveyId: /*"1"*/String(self.surveyId ?? 0) ), completion: { (error, responseBodyModel) in
                self.hideLoading()
                if let responseBodyModel = responseBodyModel {
                    let statusCode = responseBodyModel.statusCode
                    guard let data = responseBodyModel.bodyData else {
                        //self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                        self.imageNoData.isHidden = false
                        return
                    }
                    if statusCode == 200
                    {
                        guard let surveyRecomendations = try? JSONDecoder().decode(GetSurveyRecommendations.self, from: data) else {
                            print("Error: Couldn't decode data into Blog")
                            return
                        }
                        self.blogSurveyRecommendations = surveyRecomendations
                        let totalNoOfRecms = String(surveyRecomendations.data?.count ?? 0)
                        if(totalNoOfRecms == "0")
                        {
                            self.imageNoData.isHidden = false
                            return
                        }
                        self.labelNoOfRecmc.text = "You Received " + totalNoOfRecms + " Recommendation(s)"
                        self.labelNoOfRecmc.isHidden = false
                        self.tableViewMain.delegate = self
                        self.tableViewMain.dataSource = self
                        self.tableViewMain.reloadData()
                        
                        
                        
                    }else {
                        
                        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                    }
                    
                    
                } else {
                    
                }
            })
        
    }
    
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.showClosedSurveyBusinessQuestions == false)
        {
        return (self.blogSurveyRecommendations?.data?.count)!
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.showClosedSurveyBusinessQuestions == false)
        {
        let cell:SuggestedRecommendationTableViewCell = (tableViewMain.dequeueReusableCell(withIdentifier: "cell") as! SuggestedRecommendationTableViewCell?)!
        let dict = self.blogSurveyRecommendations?.data![indexPath.row]
        cell.recommendedBy.text = (dict?.recommendBy)! + "'s Recommendation"
        cell.labelBusinessAndCatName.text = /*(dict?.categoryName)! + " ," + */ (dict?.businessName)!
       // cell.labelRating.text = dict?.totalRating
        cell.BtnAccept.tag = indexPath.row
        cell.BtnAccept.addTarget(self, action: #selector(self.ButtonAcceptPressed(_:)), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = .none
        cell.cellView.layer.cornerRadius = 5.0
        cell.cellView.clipsToBounds = true
        cell.cellView.layer.borderWidth = 2.0
        cell.cellView.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        
        let nib = UINib(nibName: "SuggestedCollectionViewCell", bundle:nil)
        cell.cellCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        var cellSize = CGSize(width: cell.cellCollectionView.frame.size.width - 10  , height:56)
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
                cellSize = CGSize(width: cell.cellCollectionView.frame.size.width - 40  , height:56)
         }
       
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        cell.cellCollectionView.setCollectionViewLayout(layout, animated: true)
       
        cell.cellCollectionView.tag = indexPath.row
        cell.cellCollectionView.delegate = self
        cell.cellCollectionView.dataSource = self
        cell.cellCollectionView.reloadData()
        cell.cellCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
        
        cell.viewOfferDetail.isHidden = true
       
        cell.labelBusinessNameOffer.text = dict?.businessName
            if !(dict?.offer is NSNull || dict?.offer == nil)
            {
                cell.labelOfferName.text = dict?.offer?.title
                cell.labelOfferDesc.text = dict?.offer?.description
                cell.labelActualPrice.text =  "$" + (dict?.offer?.actualPrice)!
                cell.labelDiscountPrice.text = "$" + (dict?.offer?.disCountedPrice)!
                cell.labelExpiryDate.text = "Expiry Date: " + (dict?.offer?.endDate)!//15AUG
                
                let textRange = NSMakeRange(0, (cell.labelActualPrice.text?.count)!)
                let attributedText = NSMutableAttributedString(string: cell.labelActualPrice.text!)
                attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                            value: NSUnderlineStyle.styleSingle.rawValue,
                                            range: textRange)
                cell.labelActualPrice.attributedText = attributedText
                
                if dict?.offer?.actualPrice == ""
                {
                    cell.labelActualPrice.text = ""
                }
                if dict?.offer?.disCountedPrice == ""
                {
                    cell.labelDiscountPrice.text = ""
                }
            }
            else
            {
                cell.labelOfferName.text = "No Offers Available !"
                cell.labelOfferDesc.text = ""
                cell.labelActualPrice.text =  ""
                cell.labelDiscountPrice.text = ""
                cell.labelExpiryDate.text = ""
            }
       
            if(self.shoeClosedSurveyRecommendations == true)
            {
                 cell.BtnAccept.isHidden = true
            }
            
            cell.labelComment.isHidden = true
            cell.labelSetComment.isHidden = true
            if labelCheckForDeal.text == "Hide Deals"
            {
                cell.viewOfferDetail.isHidden = false
               
            }
            else
            {
                cell.labelComment.isHidden = false
                if  dict?.comment != ""
                {
                    cell.labelComment.text = "Comments:"
                    cell.heightConstLabelComment.constant = 20
                    cell.verticalGapBtwnSetCoommentAndBottomBtn.constant = 15
                    cell.labelSetComment.isHidden = false
                    cell.labelSetComment.text = dict?.comment
                }
                else
                {
                    cell.labelComment.text = "No Comments:"
                    cell.heightConstLabelComment.constant = 0
                    cell.verticalGapBtwnSetCoommentAndBottomBtn.constant = 0
                }
                cell.heightConstraintCollectionView.constant = CGFloat(((dict?.questions?.count)! ) * 50)
                cell.heightConstraintCollectionView.priority = UILayoutPriority(rawValue: 1000)
                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()
            }
            
        
       
        return cell
        }
        
        else{
            let cell:SuggestedRecommendationTableViewCell = (tableViewMain.dequeueReusableCell(withIdentifier: "cell") as! SuggestedRecommendationTableViewCell?)!
            
            cell.recommendedBy.text = (self.dictForUserClosedSurvey?.recommendBy)! + "'s Recommendation"
            cell.labelBusinessAndCatName.text = /*(self.dictForUserClosedSurvey?.categoryName)! + " ," + */  (self.dictForUserClosedSurvey?.businessName)!
            cell.BtnAccept.isHidden = true
            
            cell.selectionStyle = .none
            cell.cellView.layer.cornerRadius = 5.0
            cell.cellView.clipsToBounds = true
            cell.cellView.layer.borderWidth = 2.0
            cell.cellView.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
            
            let nib = UINib(nibName: "SuggestedCollectionViewCell", bundle:nil)
            cell.cellCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
            var cellSize = CGSize(width: cell.cellCollectionView.frame.size.width - 10  , height:56)
            if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
                cellSize = CGSize(width: cell.cellCollectionView.frame.size.width - 40  , height:56)
            }
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical //.horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 1.0
            layout.minimumInteritemSpacing = 1.0
            cell.cellCollectionView.setCollectionViewLayout(layout, animated: true)
            
            cell.cellCollectionView.tag = indexPath.row
            cell.cellCollectionView.delegate = self
            cell.cellCollectionView.dataSource = self
           
            cell.cellCollectionView.reloadData()
            cell.cellCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                 at: .top,
                                                 animated: true)
            
            cell.viewOfferDetail.isHidden = true
            cell.labelComment.isHidden = true
            cell.labelSetComment.isHidden = true
            if labelCheckForDeal.text == "Hide Deals"
            {
                cell.viewOfferDetail.isHidden = false
            }
            else
            {
                 cell.labelComment.isHidden = false
                if  self.dictForUserClosedSurvey?.comment != ""
                {
                    cell.labelComment.text = "Comments:"
                    cell.heightConstLabelComment.constant = 20
                    cell.verticalGapBtwnSetCoommentAndBottomBtn.constant = 15
                    cell.labelSetComment.isHidden = false
                    cell.labelSetComment.text = self.dictForUserClosedSurvey?.comment
                }
                else
                {
                    cell.labelComment.text = "No Comments:"
                    cell.heightConstLabelComment.constant = 0
                    cell.verticalGapBtwnSetCoommentAndBottomBtn.constant = 0
                }
               cell.heightConstraintCollectionView.constant =  CGFloat(((self.dictForUserClosedSurvey?.questions?.count)! ) * 50)
                cell.heightConstraintCollectionView.priority = UILayoutPriority(rawValue: 1000)
                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()
            }
            
            
            return cell
           
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if labelCheckForDeal.text == "Hide Deals"
        {
            return 285
        }
        else
        {
            return UITableViewAutomaticDimension
           /* if(self.showClosedSurveyBusinessQuestions == false)
            {
                let dict = self.blogSurveyRecommendations?.data![indexPath.row]
                if (dict?.questions?.count)! % 2 == 0
                {
                    return (  CGFloat(((dict?.questions?.count)! / 2) * 85)  ) + UITableViewAutomaticDimension
                }
                else
                {
                    return (  CGFloat((((dict?.questions?.count)! / 2) + 1) * 85)  ) + UITableViewAutomaticDimension
                    
                }
                
            }
            else{
                if (self.dictForUserClosedSurvey?.questions?.count)! % 2 == 0
                {
                    return (  CGFloat(((self.dictForUserClosedSurvey?.questions?.count)! / 2) * 85)  ) + UITableViewAutomaticDimension
                }
                else
                {
                    return (  CGFloat((((self.dictForUserClosedSurvey?.questions?.count)! / 2) + 1) * 85)  ) + UITableViewAutomaticDimension
                    
                }
                
            }*/
            
            
            
        }
        
       /* if labelCheckForDeal.text == "Hide Deals"
        {
            return 285
        }
        else
        {
            
            if(self.showClosedSurveyBusinessQuestions == false)
            {
                let dict = self.blogSurveyRecommendations?.data![indexPath.row]
                if (dict?.questions?.count)! % 2 == 0
                {
                    return (  CGFloat(((dict?.questions?.count)! / 2) * 85)  ) + 162
                }
                else
                {
                    return (  CGFloat((((dict?.questions?.count)! / 2) + 1) * 85)  ) + 162
                    
                }
                
            }
            else{
                if (self.dictForUserClosedSurvey?.questions?.count)! % 2 == 0
                {
                    return (  CGFloat(((self.dictForUserClosedSurvey?.questions?.count)! / 2) * 85)  ) + 162
                }
                else
                {
                    return (  CGFloat((((self.dictForUserClosedSurvey?.questions?.count)! / 2) + 1) * 85)  ) + 162
                    
                }
                
            }
            
        }*/
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.showClosedSurveyBusinessQuestions == false)
        {
        let dict = self.blogSurveyRecommendations?.data![collectionView.tag]
        return (dict?.questions?.count)!
        }
        else{
            return (self.dictForUserClosedSurvey?.questions?.count)!
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(self.showClosedSurveyBusinessQuestions == false)
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SuggestedCollectionViewCell
         let dict = self.blogSurveyRecommendations?.data![collectionView.tag]
        cell.labelQueName.text = dict?.questions![indexPath.row].question
        cell.labelrating.text = dict?.questions![indexPath.row].rating
       // cell.leadingConstLabelQuesName.constant = 10
        
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SuggestedCollectionViewCell
            
            cell.labelQueName.text = self.dictForUserClosedSurvey?.questions![indexPath.row].question
            cell.labelrating.text = self.dictForUserClosedSurvey?.questions![indexPath.row].rating
           // cell.leadingConstLabelQuesName.constant = 10
            
            return cell
        }
    }
    @objc func ButtonAcceptPressed(_ sender : UIButton)
    {
        
        let alertController = UIAlertController(title: "RecNX", message: "Are you sure you want to accept this recommendation?", preferredStyle: .alert)
        let btn1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            
            if Connectivity.isConnectedToInternet == false
            {
                self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
                return
            }
            let dict = self.blogSurveyRecommendations?.data![sender.tag]
            print("dict==\(dict)")
            self.showLoading()
            _=NetworkHelper().makeRequest(withAPIProvider: .AcceptRecommendation(userId: String(GlobalLoginUSerDetail?.id ?? 0), businessId: String(dict?.businessId ?? 0), recommendID: String(dict?.recommendId ?? 0)), completion: { (error, responseBodyModel) in
                self.hideLoading()
                if let responseBodyModel = responseBodyModel {
                    let statusCode = responseBodyModel.statusCode
                    guard let data = responseBodyModel.bodyData else {
                        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                        
                        return
                    }
                    
                    if statusCode == 200
                    {
                        guard let acceptRecmm = try? JSONDecoder().decode(AcceptRecommResponse.self, from: data)
                            else
                        {
                            print("Error: Couldn't decode data into Blog")
                            return
                        }
                        let application = UIApplication.shared
                        application.applicationIconBadgeNumber = acceptRecmm.badge!
                        
                        self.viewEmailReceived.isHidden = false
                        self.view.bringSubview(toFront: self.viewEmailReceived)
                        
                    }else {
                        
                        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                    }
                    
                    
                } else {
                    
                }
            })
            
            
            
        }
        let btn2 = UIAlertAction(title: "No", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the destructive");
            
        }
        alertController.addAction(btn1)
        alertController.addAction(btn2)
        self.present(alertController, animated: true, completion: nil)
        
       
    }
    @IBAction func ActionCheckForDeals(_ sender: Any) {
      
        if labelCheckForDeal.text == "Check for Deals"
        {
            labelCheckForDeal.text = "Hide Deals"
        }
        else{
             labelCheckForDeal.text = "Check for Deals"
        }
        self.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideLoading()
            self.tableViewMain.reloadData()
            
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
