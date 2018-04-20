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
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            setupData()
        }else{
//            self.spinner.stopAnimating()
//            self.spinner.isHidden = true
            let alert = JDropDownAlert()
            alert.alertWith("Please Check Your Connection", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
        }
    }
    
    func setupData(){
        guard let user = UserDefaults.standard.getUserProfile() else {return}
        if user.firstName == ""{
            self.lblName.text = "Unknown User"
        }else{
             self.lblName.text = "\(user.firstName) \(user.lastName)"
        }
        self.lblDivision.text = user.department.name
        guard let url = URL(string: user.photo) else { return }
        self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height*0.5
            self.imgProfile.layer.masksToBounds = true
        })
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
        return  3 //4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return SettingsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.profile) as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
//        else if indexPath.row == 1 {
//            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.help) as! HelpViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        else if indexPath.row == 1 { //2
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Settings.change) as! ChangePasswordViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2 { //3
            let alert = UIAlertController(title: nil, message: "Do you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
               
                //UserDefaults.standard.removeUserProfile()
                if let bundle = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundle)
                }
                
                let vc = UIStoryboard(name: StoryboardReferences.authentication, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Authentication.login)
                self.present(vc, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil )
        }
     
    }
}
