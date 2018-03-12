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

        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
