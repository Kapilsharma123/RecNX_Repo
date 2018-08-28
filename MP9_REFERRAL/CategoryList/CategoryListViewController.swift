//
//  CategoryListViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 17/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableViewMain: UITableView!
    var intSelectedIndex:Int = -1
     var BlogCategoryList: CategoryList?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryListCell")
        tableViewMain.setContentOffset(.zero, animated: true)
        self.funcNavigationSetUp()
        self.GetAllCategories()
       
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
    
    @IBAction func ActionOfNext(_ sender: Any) {
        
        if(intSelectedIndex == -1)
        {
            self.showAlert(withMessage: "Please Select Category!")
            return
        }
         let dict = self.BlogCategoryList?.categories[intSelectedIndex]
        if(dict?.subCatStatus == 1)
        {
            if  let subCatVC : SubCategoryViewController = self.storyboard!.instantiateViewController(withIdentifier: "SubCategoryVC") as? SubCategoryViewController
            {
                subCatVC.categoryId = String(dict?.id ?? 0)
                subCatVC.catName = dict?.name
                self.navigationController?.pushViewController(subCatVC, animated: true)
            }
        }
            
        else{//go toQuestionScreen
            if  let selecCommunityVC : SelectCommunityFieldViewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectCommunityVC") as? SelectCommunityFieldViewController
            {
                selecCommunityVC.categoryId = String(dict?.id ?? 0)
                selecCommunityVC.subCatId = ""
                selecCommunityVC.catName = dict?.name
                self.navigationController?.pushViewController(selecCommunityVC, animated: true)
            }
        }
    }
    
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func GetAllCategories()
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .getAllCategories(), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    guard let categoryListDetail = try? JSONDecoder().decode(CategoryList.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.BlogCategoryList = categoryListDetail
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
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BlogCategoryList!.categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CategoryListTableViewCell = (tableViewMain.dequeueReusableCell(withIdentifier: "categoryListCell") as! CategoryListTableViewCell?)!
        let dict = self.BlogCategoryList?.categories[indexPath.row]
        cell.labelCategoryName.text = dict?.name
        if(indexPath.row == intSelectedIndex)
        {
            cell.imgCatBG.image = UIImage(named:"button_orange_large_3x"/*"get_recommendation_btn_3x"*/)
        }
        else{
             cell.imgCatBG.image = UIImage(named:"button_blue")
        }
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
             cell.labelCategoryName.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
        else{
            cell.labelCategoryName.font = UIFont.boldSystemFont(ofSize: 21.0)
           
        }
        
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UIScreen.main.sizeType == .iPhone5 || UIScreen.main.sizeType == .iPhone4 {
            return 70
        }
        else{
            return 84
            //labelGetRecm.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        intSelectedIndex = indexPath.row
        tableView.reloadData()
        
        let dict = self.BlogCategoryList?.categories[indexPath.row]
        if(dict?.subCatStatus == 1)
        {
            if  let subCatVC : SubCategoryViewController = self.storyboard!.instantiateViewController(withIdentifier: "SubCategoryVC") as? SubCategoryViewController
            {
                subCatVC.categoryId = String(dict?.id ?? 0)
                subCatVC.catName = dict?.name
                self.navigationController?.pushViewController(subCatVC, animated: true)
            }
        }
            
        else{//go toQuestionScreen
            if  let selecCommunityVC : SelectCommunityFieldViewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectCommunityVC") as? SelectCommunityFieldViewController
            {
                selecCommunityVC.categoryId = String(dict?.id ?? 0)
                selecCommunityVC.subCatId = ""
                selecCommunityVC.catName = dict?.name
                self.navigationController?.pushViewController(selecCommunityVC, animated: true)
            }
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
