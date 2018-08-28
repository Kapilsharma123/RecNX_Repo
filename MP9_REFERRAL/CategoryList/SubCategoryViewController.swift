//
//  SubCategoryViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 26/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var btnCategoryName: UIButton!
    
    @IBOutlet weak var imageNoData: UIImageView!
    
    @IBOutlet weak var TableViewMain: UITableView!
     var BlogSubCategoryList: SubCategoryList?
     var categoryId: String?
    var catName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCategoryName.setTitle(catName, for: UIControlState.normal)

       // TableViewMain.register(UINib(nibName: "SubCatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
         TableViewMain.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryListCell")
        TableViewMain.setContentOffset(.zero, animated: true)
       
        self.GetAllSubCategories()
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
    
    @IBAction func ActionNext(_ sender: Any) {
        
        for dicView in (self.BlogSubCategoryList?.subCategories)!
        {
            if dicView.selected == 1
            {
                self.funcGoToNext()
                return
                
            }
        }
        self.showAlert(withMessage: "Please Select atleast one SubCategory !")
        return
        
    }
    func funcGoToNext()
    {
        var strSubCatId = ""
        for dict in (self.BlogSubCategoryList?.subCategories)!
        {
            if dict.selected == 1
            {
                strSubCatId = strSubCatId + String(dict.id ?? 0) + ","
                //self.arraySelectedQuestions.append(dict)
            }
        }
        let lastChar = strSubCatId.last
        if lastChar == ","
        {
            strSubCatId.removeLast()
        }
        
        
         if  let selecCommunityVC : SelectCommunityFieldViewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectCommunityVC") as? SelectCommunityFieldViewController
         {
         selecCommunityVC.categoryId = self.categoryId
         selecCommunityVC.subCatId = strSubCatId
         selecCommunityVC.catName = self.catName
         self.navigationController?.pushViewController(selecCommunityVC, animated: true)
         }
        
    }
    
    func GetAllSubCategories()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .getSubCategories(categoryId: self.categoryId!), completion: { (error, responseBodyModel) in
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
                    guard let subCategoryListDetail = try? JSONDecoder().decode(SubCategoryList.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                }
                    self.BlogSubCategoryList = subCategoryListDetail
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BlogSubCategoryList!.subCategories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:CategoryListTableViewCell = (TableViewMain.dequeueReusableCell(withIdentifier: "categoryListCell") as! CategoryListTableViewCell?)!
        let dict = self.BlogSubCategoryList?.subCategories[indexPath.row]
        cell.labelCategoryName.text = dict?.name
        if(dict?.selected == 0)
        {
             cell.imgCatBG.image = UIImage(named:"button_blue")
           
        }
        else{
             cell.imgCatBG.image = UIImage(named:"button_orange_large_3x"/*"get_recommendation_btn_3x"*/)
        }
        
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            cell.labelCategoryName.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
        else{
            cell.labelCategoryName.font = UIFont.boldSystemFont(ofSize: 21.0)
            
        }
      //  let cell:SubCatTableViewCell = (TableViewMain.dequeueReusableCell(withIdentifier: "cell") as! SubCatTableViewCell?)!
        
       /* if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
             cell.labelSubCatName.font = UIFont.boldSystemFont(ofSize: 15.0)
        }
        else{
          
            cell.labelSubCatName.font = UIFont.boldSystemFont(ofSize: 19.0)
        }
        cell.viewINsideCell.layer.cornerRadius = 4.0
        cell.viewINsideCell.clipsToBounds = true
        cell.viewINsideCell.layer.borderWidth = 2.0
        cell.viewINsideCell.layer.borderColor  = UIColor(red:0/255, green: 28/255, blue: 175/255, alpha: 1.0).cgColor
        if(dict?.selected == 0)
        {
            cell.imgCheckBox.image = UIImage(named:"checkbox_3x")
        }
        else{
            cell.imgCheckBox.image = UIImage(named:"checkbox_checked_3x")
        }*/
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       /* if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            return 64
        }
        else{
            return 74
            //labelGetRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
        }*/
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            return 70
        }
        else{
            return 84
            //labelGetRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var intLocalIndex = 0
        for dict in (self.BlogSubCategoryList?.subCategories)!
        {
            print(dict)
            if(intLocalIndex == indexPath.row)
            {
                self.BlogSubCategoryList?.subCategories[intLocalIndex].selected = 1
            }
            else
            {
                self.BlogSubCategoryList?.subCategories[intLocalIndex].selected = 0
            }
            intLocalIndex = intLocalIndex + 1
        }
        
         self.TableViewMain.reloadData()
         let dict = self.BlogSubCategoryList?.subCategories[indexPath.row]
        if  let selecCommunityVC : SelectCommunityFieldViewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectCommunityVC") as? SelectCommunityFieldViewController
        {
            selecCommunityVC.categoryId = self.categoryId
            selecCommunityVC.subCatId = String(dict?.id ?? 0)
            selecCommunityVC.catName = self.catName
            self.navigationController?.pushViewController(selecCommunityVC, animated: true)
        }
     
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
