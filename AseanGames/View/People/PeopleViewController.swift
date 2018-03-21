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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraintTopTable.constant = 50
        self.lblSmallPeople.alpha = 0
        self.viewUnderline.alpha = 0
      //  self.table.isHidden = true
        self.spinner.startAnimating()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewTitleSmall.backgroundColor = UIColor.clear
      
    }
    
    //MARK : Function
    func setupData() {
        PeopleController().getPeople(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.groupItems = res.group
                self.friendsItems = res.friends
              //  self.table.isHidden = false
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
}

extension PeopleViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + self.friendsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Group")
            
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
            cell.context = self
            cell.peopleData = groupItems
            return cell
            
        }else if indexPath.row == 2 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Friends")
            
        }else {
            let data = friendsItems[indexPath.row - 3]
            return FriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 3{
            let data = friendsItems[indexPath.row - 3]
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detailFriends) as! DetailFriendsViewController
            vc.idUser = data.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PeopleViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
            
        } else if indexPath.row == 1 {
            return 182
            
        }else if indexPath.row == 2 {
            return 60
            
        }else {
            return 64
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
