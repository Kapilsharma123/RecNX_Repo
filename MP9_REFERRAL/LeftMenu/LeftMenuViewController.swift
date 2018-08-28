//
//  LeftMenuViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
import Alamofire
enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}
protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}
class LeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate  {

    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var viewTransparent: UIView!
     @IBOutlet var btnCloseMenuOverlay : UIButton!
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    var ArrayLeftMenu = ["Home", "Profile", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewMain.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTap))
        tap.delegate = self
        self.viewTransparent.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        self.tableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableViewMain.separatorColor = UIColor.darkGray
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        self.tableViewMain.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.funcNavigationSetUp()
    }
    func funcNavigationSetUp()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(0)
            
            index = -1
            
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ArrayLeftMenu.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableViewMain.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = ArrayLeftMenu[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 65
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < 2)
        {
            let btn = UIButton(type: UIButtonType.custom)
            btn.tag = indexPath.row
            self.onCloseMenuClick(btn)
        }
        else
        {
            self.funcLogOut()
            
        }
    }
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    func funcLogOut()//26july
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        self.showLoading()
        _=NetworkHelper().makeRequest(withAPIProvider: .logOut(userId: String(GlobalLoginUSerDetail?.id ?? 0), savedDeviceID: String(GlobalLoginUSerDetail?.savedDeviceId ?? 0)), completion: { (error, responseBodyModel) in
            self.hideLoading()
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                
                if statusCode == 200
                {
                    let defaults = UserDefaults.standard
                     defaults.removeObject(forKey: "loginUserDetail")
                     defaults.synchronize()
                     let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VC") as! ViewController
                     let navController = UINavigationController(rootViewController: viewController)
                     self.navigationController?.present(navController, animated: true, completion: nil)
                    
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
