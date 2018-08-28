//
//  ExtnUIViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
extension UIViewController
{
    func showAlertOK(withMessage message: String, title: String? = nil, actionTitle: String? = nil, completion: (()-> ())? = nil) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: .cancel, handler: { _ in
            completion?()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(withMessage message: String, title: String? = nil, actionTitle: String? = nil, completion: (()-> ())? = nil) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: .cancel, handler: { _ in
            completion?()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertPopToLogin(withMessage message: String, title: String? = nil, actionTitle: String? = nil, completion: (()-> ())? = nil) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: .cancel, handler: { _ in
            completion?()
            for vc in (self.navigationController?.viewControllers)!
            {
                if vc is LoginViewController
                {
                     self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showLoading()
    {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.gray//init(red: 209.0/255.0, green: 72.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        hud.bezelView.style = .solidColor
        hud.bezelView.layer.cornerRadius = 10.0
    }
    func hideLoading()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func UIDatePickerTemp(picker : UIDatePicker , textfield : UITextField)
    {
        picker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        textfield.inputAccessoryView = toolbar
        picker.removeFromSuperview()
        textfield.inputView = picker
    }
    func donedatePicker(picker1 : UIDatePicker , textfield1 : UITextField){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        textfield1.text = formatter.string(from: picker1.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
