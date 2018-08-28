//
//  GiveRecommendationViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 02/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit


class GiveRecommendationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,ClassRecommendationTableDelegate,UITextViewDelegate{

    var surveyParams = SurveyParams()
    @IBOutlet weak var tfFirstName: UITextField!
    
    
    @IBOutlet weak var tvComment: UITextView!
    
    @IBOutlet weak var BtnContinue: UIButton!
    
    @IBOutlet weak var tfLastName: UITextField!
    
    @IBOutlet weak var searchBarMain: UISearchBar!
    
    @IBOutlet weak var TableViewMain: UITableView!
    
   
     var BlogQuestionsForRecommendation: QuestionsForRecommendation?
    var selectedBusinessFullINfo = placeFullInfo()
    var arraySubmitQuesForRecommendation = [SubmitQuesForRecommendation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.BtnContinue.layer.cornerRadius = 8.0
        self.BtnContinue.clipsToBounds = true
        self.tvComment.layer.cornerRadius = 8.0
        self.tvComment.clipsToBounds = true
        self.tvComment.layer.borderColor = UIColor.lightGray.cgColor
        self.tvComment.layer.borderWidth = 1.0
        self.tvComment.delegate = self
        self.searchBarMain.delegate = self
        tfFirstName.delegate = self
        tfLastName.delegate = self
       
        
        TableViewMain.register(UINib(nibName: "RecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
       
        TableViewMain.setContentOffset(.zero, animated: true)
        
        
        self.funcGetQuestions()
       
        
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
     public func textViewDidBeginEditing(_ textView: UITextView)
     {
        if(textView.text == "Your Comments...")
        {
            textView.text = ""
        }
    }
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
           
            return false
        }
        return true
    }
    
    func setTheRating(index: Int, rating: Int)
    {
       
        self.BlogQuestionsForRecommendation?.questions![index].ratings = rating
        TableViewMain.reloadData()
    }
    
    func funcGetQuestions()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .getQuestions(postID: self.surveyParams.postId!, userID: self.surveyParams.userId!), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    guard let QuesListDetail = try? JSONDecoder().decode(QuestionsForRecommendation.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.BlogQuestionsForRecommendation = QuesListDetail
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                   
                    
                }
                else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        print("placeFullInfo===\(GlobalConstants.GooglePLACEAPi.placeFullInfo)")
        if (GlobalConstants.GooglePLACEAPi.placeFullInfo != nil)
        {
        self.searchBarMain.text = GlobalConstants.GooglePLACEAPi.placeFullInfo?.name
        }
    }
      public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) 
    {
        if  let VC : SearchGooglePlaceViewController = self.storyboard!.instantiateViewController(withIdentifier: "SearchGooglePlaceVC") as? SearchGooglePlaceViewController
        {
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
   
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.BlogQuestionsForRecommendation?.questions?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RecommendationTableViewCell = (TableViewMain.dequeueReusableCell(withIdentifier: "cell") as! RecommendationTableViewCell?)!
        cell.delegate = self
        let dict = self.BlogQuestionsForRecommendation?.questions![indexPath.row]
        cell.labelName.text = dict?.question
        cell.tag = indexPath.row
        
        for buttonRating in cell.viewStars.subviews
        {
            if buttonRating is UIButton && buttonRating.tag <= (dict?.ratings)!
            {
                (buttonRating as! UIButton).setBackgroundImage(UIImage(named:"star_2"), for: .normal)
            }
            else
            {
                (buttonRating as! UIButton).setBackgroundImage(UIImage(named:"star"), for: .normal)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewMain.frame.size.height/3.5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func FuncJsonString(ArrayPass:Array<Any>) -> String {
        guard let data1 = try? JSONSerialization.data(withJSONObject: ArrayPass, options: [])
            else{
                return ""
        }
        let jsonStringDeals =  String(data: data1, encoding: String.Encoding.utf8)
        return jsonStringDeals!
    }
    
    @IBAction func ActionSubmitZRecommend(_ sender: Any) {
        
        if tfFirstName.text == nil || tfFirstName.text == ""
        {
            //self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterName)
            return
        }
        if tfLastName.text == nil || tfLastName.text == ""
        {
          //  self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterName)
            return
        }
        if self.searchBarMain.text == nil || self.searchBarMain.text == ""
        {
            self.showAlert(withMessage: GlobalConstants.FillAllDetails.pleaseEnterBusiness)
            return
        }
        if tvComment.text == "" || tvComment.text == nil
        {
            tvComment.text = ""
        }
        
        var ArraySubmitQuestions = [[String : Any]]()
        for dict in (self.BlogQuestionsForRecommendation?.questions)!
        {
          // var dicSubmit = SubmitQuesForRecommendation()
          //  dicSubmit.id = String(dict.id ?? 0)
           // dicSubmit.ratings = String(dict.ratings ?? 0)
            
            var dictParam = [String:Any]()
            dictParam["id"] =     String(dict.id ?? 0)
            dictParam["rating"] = String(dict.ratings ?? 0)
            ArraySubmitQuestions.append(dictParam)
           // self.arraySubmitQuesForRecommendation.append(dicSubmit)
        }
       
       let jsonStrSubmitQuestionRating: String = self.FuncJsonString(ArrayPass: ArraySubmitQuestions)
       
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .CommunityRecommendation(AppUserID: self.surveyParams.userId!, postID: self.surveyParams.postId!, SurveyID: self.surveyParams.surveyId!, CategoryID: self.surveyParams.categoryId!, SubCatID: self.surveyParams.subCategoryId!, FirstName: self.tfFirstName.text!, LastName: self.tfLastName.text!, Comment: self.tvComment.text, QuestionRating: jsonStrSubmitQuestionRating, plaeFullInfo: GlobalConstants.GooglePLACEAPi.placeFullInfo!), completion: { (error, responseBodyModel) in
            self.hideLoading()
                if let responseBodyModel = responseBodyModel {
                    let statusCode = responseBodyModel.statusCode
                    guard responseBodyModel.bodyData != nil else {
                        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                        return
                    }
                    if statusCode == 200
                    {
                        self.showAlert(withMessage: responseBodyModel.responseMessage ?? "")
                        
                    }else {
                        
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
