//
//  SelectGroupViewController.swift
//  AseanGames
//
//  Created by Calista on 4/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class SelectGroupViewController: UIViewController {
        @IBOutlet weak var table: UITableView!{
            didSet{
                let xib = RecipientTableViewCell.nib
                table.register(xib, forCellReuseIdentifier: RecipientTableViewCell.identifier)
                
                let xib2 = ListSelectGroupTableViewCell.nib
                table.register(xib2, forCellReuseIdentifier: ListSelectGroupTableViewCell.identifier)
                
                table.dataSource = self
                table.delegate = self
            }
        }
        
        @IBOutlet weak var spinner: UIActivityIndicatorView!
        @IBOutlet weak var txtSearch: UITextField!{
            didSet{
                txtSearch.delegate = self
            }
        }
        
        @IBOutlet weak var btnSelect: CheckBox!
        @IBOutlet weak var btnSelectGuest: UIButton!
        
        var idTitle = 0
        var isSelectAll = false
        var isGroupSelect = false
        var searchText = ""
        
        internal var groupItems = [GroupModel](){
            didSet{
                table.reloadData()
            }
        }
        
        internal var friendsItems = [RecipientModel](){
            didSet{
                table.reloadData()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            if idTitle == 0{
//                lblTitle.text = "Select Group"
//                btnSelectGuest.titleLabel?.text = "Select Group"
//            }else {
//                lblTitle.text = "Select Guest"
//                btnSelectGuest.titleLabel?.text = "Select Guest"
//            }
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.spinner.startAnimating()
            setupGroup()
        }
        
        //MARK: -Function
        func setupGroup() {
            PeopleController().getGroup(onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if code == 200 {
                    self.groupItems = res
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
        
        func setupFriends() {
            func setupData() {
                PeopleController().getFriends(onSuccess: { (code, message, result) in
                    guard let res = result else {return}
                    if code == 200 {
                        self.friendsItems = res
                        self.table.isHidden = false
                        
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
        
        func searchGroup() {
            PeopleController().getSearchGroup(keyword: searchText, onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if code == 200 {
                    //self.table.reloadData()
                    self.groupItems = res
                    //self.table.isHidden = false
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
        
        //MARK: -Action
        
        @IBAction func selectedtAll(_ sender: Any) {
        }
        
    }
    
    extension SelectGroupViewController: UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            searchText = self.txtSearch.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            self.searchGroup()
            
            return true
        }
    }
    
    extension SelectGroupViewController: UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if idTitle == 0 {
                return groupItems.count
            }
            return friendsItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if idTitle == 0 {
                let data = groupItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: ListSelectGroupTableViewCell.identifier, for: indexPath) as! ListSelectGroupTableViewCell
                cell.viewSelected.layer.cornerRadius = cell.viewSelected.frame.size.height*0.5
                cell.lblGroupName.text = data.name
                if self.isGroupSelect {
                    cell.viewSelected.isHidden = false
                    
                }else{
                    cell.viewSelected.isHidden = true
                    
                }
                return cell
                
            }else{
                let data = friendsItems[indexPath.row]
                return RecipientTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
            }
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
        
    }
    
    extension SelectGroupViewController: UITableViewDelegate{
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 54
            
        }
}


