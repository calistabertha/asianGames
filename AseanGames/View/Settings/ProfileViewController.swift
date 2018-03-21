//
//  ProfileViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    //MARK: Function
    func setupData(){
        guard let user = UserDefaults.standard.getUserProfile() else {return}
        if user.firstName == ""{
            self.lblName.text = "Unknown User"
        }else{
            self.lblName.text = "\(user.firstName) \(user.lastName)"
        }
        self.lblDivision.text = user.assignment.name
        self.lblEmail.text = user.email
        self.lblPhone.text = user.phone
        self.lblTitle.text = user.department.name
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
