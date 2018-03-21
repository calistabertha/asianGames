//
//  SignInViewController.swift
//  AseanGames
//
//  Created by Calista on 12/19/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewEmailLine: UIView!
    @IBOutlet weak var viewPasswordLine: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func showPassword(_ sender: Any) {
       // self.txtPassRegis.font = UIFont(name: "CitrixSans-Regular", size: 14)
        if (!self.txtPassword.isSecureTextEntry){
            self.txtPassword.isSecureTextEntry = true
            
        }else{
            self.txtPassword.isSecureTextEntry = false
            
        }
    }

    @IBAction func forgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.authentication, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Authentication.forgot) as! ForgotPasswordViewController
        
        self.present(vc, animated: true, completion: nil)
    }
  
    @IBAction func register(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.authentication, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Authentication.register) as! RegisterViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signIn(_ sender: Any) {
        AuthController().getToken(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if res != "" {
                AuthController().requestLogin(email: self.txtEmail.text!, password: self.txtPassword.text!,
                                              onSuccess: { (code, message, result) in
                                                guard let res = result else {return}
                                                
                                                if code == 200 {
                                                    let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
                                                    let vc = storyboard.instantiateInitialViewController()
                                                    self.present(vc!, animated: true, completion: nil)
                                    
                                    
                                                } else{
                                                    let alert = JDropDownAlert()
                                                    alert.alertWith("Sign in failed", message: message, topLabelColor:
                                                        UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(red:245/255, green:45/255, blue:90/255.0, alpha:1), image: nil)
                                                }
                                                print("data \(res)")
                                                print("msg \(message)")
                }, onFailed: { (message) in
                    print(message)
                    print("Do action when data failed to fetching here")
                }) { (message) in
                    print(message)
                    print("Do action when data complete fetching here")
                }
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
       
    }
}
