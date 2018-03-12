//
//  AgendaFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class AgendaFriendsViewController: UIViewController {
    @IBOutlet weak var table: UITableView!{
        didSet{
            
        }
    }
    
    var childDelegate: FriendsOffsetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
