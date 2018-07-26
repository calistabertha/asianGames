//
//  ChildFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 4/6/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
protocol FriendsSelected : class {
    func guest(id: [String], name: [String])
}

class ChildFriendsViewController: UIViewController {
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = FriendsTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: FriendsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    @IBOutlet weak var viewSelect: UIView!
    fileprivate var isSelectedAll = false
    var searchText = ""
    
    internal var friendsItems = [RecipientModel](){
        didSet{
            table.reloadData()
        }
    }
    var delegate: FriendsSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSelect.isHidden = true
        self.viewSelect.layer.cornerRadius = self.viewSelect.frame.size.height*0.5
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.spinner.startAnimating()
        setupData()
    }
    
    //MARK: Function
    func setupData(){
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
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func searchFriends() {
        PeopleController().getSearchFriends(keyword: searchText, onSuccess: { (code, message, result) in
            print("keyword \(self.searchText)")
            guard let res = result else {return}
            if code == 200 {
                self.friendsItems = res
//                for value in res {
//                    self.friendsItems.append(value)
//                }
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
           
            print("Do action when data complete fetching here")
        }
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    //MARK: Action
    @IBAction func selectAllGuest(_ sender: Any) {
        self.isSelectedAll = !self.isSelectedAll
        
        self.friendsItems.forEach {
            $0.isSelected = self.isSelectedAll
        }
        self.viewSelect.isHidden = !self.isSelectedAll
        self.table.reloadData()
        
    }
    
    @IBAction func selectGuest(_ sender: Any) {
        let selectedGuest = self.friendsItems
            .filter {
                return $0.isSelected
            }.map {
                return "\($0.id)"
        }
    
        let friendsName =  self.friendsItems
            .filter {
                return $0.isSelected
            }.map {
                return "\($0.name)"
        }
     
        self.delegate?.guest(id: selectedGuest, name: friendsName)
        self.navigationController?.popViewController(animated: true)
        print(selectedGuest)
    }
    
}
extension ChildFriendsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.txtSearch.text == "" {
            self.view.endEditing(true)
        }else {
            self.view.endEditing(true)
            searchText = self.txtSearch.text!
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            self.viewSelect.isHidden = true
            self.isSelectedAll = !self.isSelectedAll
            self.searchFriends()
        }
        
        return true
    }
}

extension ChildFriendsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
        let data = friendsItems[indexPath.row]
        cell.viewSelect.isHidden = true
        cell.viewSelect.layer.cornerRadius = cell.viewSelect.frame.size.height*0.5
        cell.lblName.text = data.name
        cell.lblTitle.text = data.title
     
        if data.isSelected {
            cell.viewSelect.isHidden = false
        } else {
            cell.viewSelect.isHidden = true
        }
        
        guard let url = URL(string: data.photo) else { return cell }
        cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
            cell.imgProfile.layer.masksToBounds = true
        })
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = friendsItems[indexPath.row]
        data.isSelected = !data.isSelected
        
        self.table.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ChildFriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
        
    }
}
