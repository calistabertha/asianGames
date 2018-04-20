//
//  ChangePasswordViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let old = txtCurrentPass.text else {return}
        guard let new = txtNewPass.text else {return}
        guard let confirm = txtConfirmPass.text else {return}
        
        SettingController().requestChangePassword(old: old, new: new, confirm: confirm,  onSuccess: { (code, message, result) in
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                if code == 200 {
                    let alert = JDropDownAlert()
                    alert.alertWith("Success", message: result, topLabelColor:
                        UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                let alert = JDropDownAlert()
                alert.alertWith("Please Check Your Connection", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
            }

        }, onFailed: { (message) in
            print(message)
            let alert = JDropDownAlert()
            alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
            
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
        
    }
    
    @IBAction func currentPassword(_ sender: Any) {
        if (!self.txtCurrentPass.isSecureTextEntry){
            self.txtCurrentPass.isSecureTextEntry = true
        }else{
            self.txtCurrentPass.isSecureTextEntry = false
        }
    }
    
    @IBAction func newPassword(_ sender: Any) {
        if (!self.txtNewPass.isSecureTextEntry){
            self.txtNewPass.isSecureTextEntry = true
        }else{
            self.txtNewPass.isSecureTextEntry = false
        }
    }
    
    @IBAction func confirmPassword(_ sender: Any) {
        if (!self.txtConfirmPass.isSecureTextEntry){
            self.txtConfirmPass.isSecureTextEntry = true
        }else{
            self.txtConfirmPass.isSecureTextEntry = false
        }
    }
    
}
