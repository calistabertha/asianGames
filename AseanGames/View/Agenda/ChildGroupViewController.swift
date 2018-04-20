//
//  ChildGroupViewController.swift
//  AseanGames
//
//  Created by Calista on 4/6/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
protocol GroupsSelected : class {
    func groups(id: [String], name: [String])
}

class ChildGroupViewController: UIViewController {
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib2 = ListSelectGroupTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: ListSelectGroupTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var viewSelect: UIView!
    
    fileprivate var isSelectedAll = false
    var searchText = ""
    var idGroupSelected : [Int]?
    var delegate: GroupsSelected?
    
    internal var groupItems = [GroupModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSelect.isHidden = true
        self.viewSelect.layer.cornerRadius = self.viewSelect.frame.size.height*0.5
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
    
    func searchGroup() {
        PeopleController().getSearchGroup(keyword: searchText, onSuccess: { (code, message, result) in
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
    
    //MARK: -Action
    @IBAction func selectAllGuest(_ sender: Any) {
        self.isSelectedAll = !self.isSelectedAll
        self.groupItems.forEach {
            $0.isSelected = self.isSelectedAll
        }
        self.viewSelect.isHidden = !self.isSelectedAll
        self.table.reloadData()
    }
    
    @IBAction func selectGuest(_ sender: Any) {
        let selectedGroups = self.groupItems
            .filter {
                return $0.isSelected
            }.map {
                return "\($0.id)"
        }
        
        let groupsName =  self.groupItems
            .filter {
                return $0.isSelected
            }.map {
                return "\($0.name)"
        }
        
        self.delegate?.groups(id: selectedGroups, name: groupsName)
        self.navigationController?.popViewController(animated: true)
       // print(selectedGuest)
    }
}

extension ChildGroupViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchText = self.txtSearch.text!
            //.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.searchGroup()
        
        return true
    }
}

extension ChildGroupViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = groupItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListSelectGroupTableViewCell.identifier, for: indexPath) as! ListSelectGroupTableViewCell
        cell.viewSelected.layer.cornerRadius = cell.viewSelected.frame.size.height*0.5
        cell.lblGroupName.text = data.name
        
        if data.isSelected {
            cell.viewSelected.isHidden = false
        } else {
            cell.viewSelected.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = groupItems[indexPath.row]
        data.isSelected = !data.isSelected
        
        self.table.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ChildGroupViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
        
    }
}

