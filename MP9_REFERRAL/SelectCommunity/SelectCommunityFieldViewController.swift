//
//  SelectCommunityFieldViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SelectCommunityFieldViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var BtnContinue: UIButton!
    
    @IBOutlet weak var imageNoData: UIImageView!
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var labelChooseMax: UILabel!
    
    var catName:String?
    var BlogCatQuestionsList: CategoryQuestionList?
    var arraySelectedQuestions = [Questions]()
    var categoryId:String?
    var subCatId : String?
    var intMaxSelection:Int?
    
    var ArrayCommunityFields = ["Treatment Afforability", "Chairside Personality", "Staff Friendliness","Schedule Flexiblity", "Treatment Discomfort","Treatment Financing","Treatment Satisfaction"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableViewMain.register(UINib(nibName: "SubCatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewMain.setContentOffset(.zero, animated: true)
        
        self.funcGetSurveyList()
       
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
    
    @IBAction func ActionOfBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func funcGoNext()
    {
        if  let socialShareVC : SocialSharingViewController = self.storyboard!.instantiateViewController(withIdentifier: "SocialShareVC") as? SocialSharingViewController
        {
            
            socialShareVC.surveyParams.categoryId = self.categoryId
            socialShareVC.surveyParams.subCategoryId = self.subCatId
            socialShareVC.surveyParams.surveyId = String(self.BlogCatQuestionsList?.survey[0].id ?? 0)
            socialShareVC.surveyParams.userId = String(GlobalLoginUSerDetail?.id ?? 0)
            var strQuestionsId = ""
            for dict in (self.BlogCatQuestionsList?.survey[0].questions)!
            {
                if dict.checked == 1
                {
                    strQuestionsId = strQuestionsId + String(dict.id ?? 0) + ","
                    self.arraySelectedQuestions.append(dict)
                }
            }
            let lastChar = strQuestionsId.last
            if lastChar == ","
            {
                strQuestionsId.removeLast()
            }
            socialShareVC.surveyParams.questionsId = strQuestionsId
            socialShareVC.catName = self.catName
            
            self.navigationController?.pushViewController(socialShareVC, animated: true)
        }
        
    }
    
    @IBAction func ActionOfNext(_ sender: Any) {
        
        for dicView in (self.BlogCatQuestionsList?.survey[0].questions)!
        {
            if dicView.checked == 1
            {
                self.funcGoNext()
                return
                
            }
        }
        self.showAlert(withMessage: "Please Select atleast one question !")
        return
       
    }
    
    
    func funcGetSurveyList()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .getSurveyByCategory(categoryId: self.categoryId!, subCategoryId: self.subCatId!), completion: { (error, responseBodyModel) in
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
                    guard let catQuestionDetail = try? JSONDecoder().decode(CategoryQuestionList.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.BlogCatQuestionsList = catQuestionDetail
                    let strMaxQuestions = (self.BlogCatQuestionsList?.survey[0])!.maximum
                    self.intMaxSelection = Int(strMaxQuestions!)
                    self.labelChooseMax.isHidden = false
                    self.labelChooseMax.text = "(Choose a max. of " + strMaxQuestions! + ")"
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
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.BlogCatQuestionsList?.survey[0])!.questions.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:SubCatTableViewCell = (tableViewMain.dequeueReusableCell(withIdentifier: "cell") as! SubCatTableViewCell?)!
        let dict = (self.BlogCatQuestionsList?.survey[0])!.questions[indexPath.row]
        
        cell.labelSubCatName.text = dict.question
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            cell.labelSubCatName.font = UIFont.boldSystemFont(ofSize: 15.0)
        }
        else{
            
            cell.labelSubCatName.font = UIFont.boldSystemFont(ofSize: 19.0)
        }
        if(dict.checked == 0)
        {
            cell.imgCheckBox.image = UIImage(named:"checkbox_3x")
        }
        else{
            cell.imgCheckBox.image = UIImage(named:"checkbox_checked_3x")
        }
        cell.viewINsideCell.layer.cornerRadius = 4.0
        cell.viewINsideCell.clipsToBounds = true
        cell.viewINsideCell.layer.borderWidth = 2.0
        cell.viewINsideCell.layer.borderColor = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
       
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            return 64
        }
        else{
            return 74
            //labelGetRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = ((self.BlogCatQuestionsList?.survey[0])!.questions[indexPath.row] )
        
        var count : Int?
        count = 0
        for dicView in (self.BlogCatQuestionsList?.survey[0].questions)!
        {
            if dicView.checked == 1
            {
                count = count! + 1
            }
        }
        if( count == self.intMaxSelection && dict.checked == 0)
        {
           self.showAlert(withMessage: "You have exceeded the maximum number of criteria for this category.")
            return
        }
        
        if(dict.checked == 0)
        {
            self.BlogCatQuestionsList?.survey[0].questions[indexPath.row].checked = 1
            self.funcShowTableFooter(count: count! + 1)
        }
        else
        {
            self.BlogCatQuestionsList?.survey[0].questions[indexPath.row].checked = 0
            self.funcShowTableFooter(count: count! - 1)
        }
        
        self.tableViewMain.reloadData()
    }
    
    func funcShowTableFooter(count:Int)
    {
        let customView = UIView(frame: CGRect(x: 20, y: 20, width: tableViewMain.frame.size.width - 40, height: 50))
        customView.backgroundColor = UIColor.clear
        let label = UILabel(frame:  CGRect(x: 0, y: 0, width: tableViewMain.frame.size.width - 40, height: 50))
        
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        customView.addSubview(label)
        
        let main_string = "You Have Chosen: " + String(count)
        let string_to_color = String(count)
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
        label.attributedText = attribute
        
        tableViewMain.tableFooterView = customView
        
        
    }
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
