//
//  ViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 208/255, blue: 240/255, alpha: 1.0)
    }
    
    @IBAction func ActionSignIn(_ sender: Any) {
        if  let loginVC : LoginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
            {
            
            self.navigationController?.pushViewController(loginVC, animated: true)
        }

    }
    
    @IBAction func ActionSignUp(_ sender: Any) {
         self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

