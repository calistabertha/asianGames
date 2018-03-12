//
//  HelpViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
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

extension HelpViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
}

extension HelpViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return SettingsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Help\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.FAQ) as! FAQViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
