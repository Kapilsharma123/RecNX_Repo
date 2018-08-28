//
//  BusinessOffersViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class BusinessOffersViewController: UIViewController {
    var BusinessId:Int?
    var blogBusinessOffers:BusinessOffer?

    
    @IBOutlet weak var TableViewMain: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // TableViewMain.register(UINib(nibName: "OfferDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
      //  TableViewMain.setContentOffset(.zero, animated: true)
       // self.funcGetBusinessOffers()
    }
    
   /* func funcGetBusinessOffers()
    {
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .GetBusinessOffers(businessID: String(self.BusinessId ?? 0)), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    guard let offersList = try? JSONDecoder().decode(BusinessOffer.self, from: data) else {
                        print("Error: Couldn't decode data into Blog")
                        return
                    }
                    self.blogBusinessOffers = offersList
                    self.TableViewMain.delegate = self
                    self.TableViewMain.dataSource = self
                    self.TableViewMain.reloadData()
                    
                    
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }*/
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  /*  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return //4(self.blogBusinessOffers?.offers?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OfferDetailTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferDetailTableViewCell?)!
        let dict = self.blogBusinessOffers?.offers![indexPath.row]
        cell.labelDesc.text = dict?.description
        cell.labelOfferName.text = ""
        cell.labelActualPrice.text = dict?.actualPrice
        cell.labelDiscountedPrice.text = dict?.disCountedPrice
        cell.labelPostEndDate.text = dict?.endDate
        cell.BtnAccept.tag = indexPath.row
        cell.BtnAccept.addTarget(self, action: #selector(self.ButtonAcceptPressed(_:)), for: UIControlEvents.touchUpInside)
       
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewMain.frame.size.height/2.6
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    @objc func ButtonAcceptPressed(_ sender : UIButton)
    {
         let dict = self.blogBusinessOffers?.offers![sender.tag]
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .AcceptOffer(userId: String(GlobalLoginUSerDetail?.id ?? 0), businessId: String(dict?.businessId ?? 0), offerId: String(dict?.offerId ?? 0), categoryId: String(dict?.categoryId ?? 0)), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard let data = responseBodyModel.bodyData else {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                   
                    
                }else {
                    
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
                
            } else {
                
            }
        })
    }*/
}
