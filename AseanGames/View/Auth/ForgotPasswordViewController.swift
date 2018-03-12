//
//  ForgotPasswordViewController.swift
//  AseanGames
//
//  Created by Calista on 12/21/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var viewHideKeyboard: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func forgotPassword(_ sender: Any) {
        
    }

}
