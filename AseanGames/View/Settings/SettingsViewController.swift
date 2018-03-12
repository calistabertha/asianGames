//
//  SettingsViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
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

}

extension SettingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 65
    }
}

extension SettingsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return SettingsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.profile) as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.help) as! HelpViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.change) as! ChangePasswordViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
}
