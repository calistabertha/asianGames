//
//  PeopleViewController.swift
//  AseanGames
//
//  Created by Calista on 2/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var lblSmallPeople: UILabel!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = HeaderTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: HeaderTableViewCell.identifier)
            
            let xib2 = PeopleTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: PeopleTableViewCell.identifier)
            
            let xib3 = FriendsTableViewCell.nib
            table.register(xib3, forCellReuseIdentifier: FriendsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    @IBOutlet weak var viewBigPeople: UIView!
    @IBOutlet weak var constraintTopTable: NSLayoutConstraint!
    @IBOutlet weak var viewUnderline: UIView!
    @IBOutlet weak var viewTitleSmall: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    internal var dataSource: [(section: String, type: Int, data: [Any])] = [] {
        didSet {
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraintTopTable.constant = 50
        self.lblSmallPeople.alpha = 0
        self.viewUnderline.alpha = 0
      //  self.table.isHidden = true
        self.spinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewTitleSmall.backgroundColor = UIColor.clear
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            setupData()
        }else{
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            let alert = JDropDownAlert()
            alert.alertWith("Please Check Your Connection", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
        }
      
    }
    
    //MARK : Function
    func setupData() {
        PeopleController().getPeople(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
              //  self.table.isHidden = false
                self.dataSource = []
                
                if res.group.count > 0 {
                    self.dataSource.append((section: "Group", type: 0, data: res.group))
                    self.groupItems = res.group
                }
                
                if res.friends.count > 0 {
                    self.dataSource.append((section: "Friends", type: 1, data: res.friends))
                }
                
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
             
            }
        }, onFailed: { (message) in
            print(message)
          //  self.table.isHidden = true
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            print("Do action when data complete fetching here")
        }
    }
    
    func openSeeAll(sender : UIButton){
        let data = dataSource[sender.tag].section
        if sender.tag == 0 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.group) as! GroupViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.friends) as! FriendsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("see all \(sender.tag), \(data)")
    }
    
}

extension PeopleViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count //1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource[section].type == 0 {
            return 1
        }
        return dataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as! HeaderTableViewCell
        cell.lblHeader.text = dataSource[section].section
        cell.btnSeeAll.tag = section
        cell.btnSeeAll.addTarget(self, action: #selector(openSeeAll(sender:)), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section].data[indexPath.row]
        if dataSource[indexPath.section].type == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
            cell.context = self
            cell.peopleData = groupItems
         
            return cell
            
        }else if let data = data as? RecipientModel{
           return FriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
            
        }else{
            return UITableViewCell()
        }
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.section].data[indexPath.row]
        if let data = data as? RecipientModel {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detailFriends) as! DetailFriendsViewController
            vc.idUser = data.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PeopleViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataSource[indexPath.section]
        if data.type == 0 {
            return 182
        }else if data.type == 1 {
            return 64
        }else{
            return 0
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        table.reloadData()
        print("y \(scrollView.contentOffset.y)")
        if (scrollView.panGestureRecognizer.translation(in: scrollView.superview)).y < 0 {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.white
                self.viewBigPeople.alpha = 0
                self.lblSmallPeople.alpha = 1
                self.viewUnderline.alpha = 1
                self.constraintTopTable.constant = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.clear
                self.viewBigPeople.alpha = 1
                self.lblSmallPeople.alpha = 0
                self.viewUnderline.alpha = 0
                self.constraintTopTable.constant = 50
            })
        }
    }
}
