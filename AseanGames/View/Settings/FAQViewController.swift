//
//  FAQViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

class FAQViewController: CollapsibleTableSectionViewController {
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = SettingsTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: SettingsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FAQViewController: CollapsibleTableSectionDelegate{
    func numberOfSections(_ tableView: UITableView) -> Int {
        return 4
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SettingsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Help\(indexPath.row)")
    }
    
}


