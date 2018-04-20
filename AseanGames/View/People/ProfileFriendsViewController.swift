//
//  ProfileFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ProfileFriendsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = RoleTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: RoleTableViewCell.identifier)
            
            let xib2 = HeaderTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: HeaderTableViewCell.identifier)
            
            let xib3 = ContactTableViewCell.nib
            table.register(xib3, forCellReuseIdentifier: ContactTableViewCell.identifier)
            
            let xib4 = GroupFriendsTableViewCell.nib
            table.register(xib4, forCellReuseIdentifier: GroupFriendsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var childDelegate: FriendsOffsetDelegate?
    var idUser = ""
    var dataUser : UserModel?
    internal var groupItems = [GroupModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        self.table.estimatedRowHeight = 70
        self.table.isScrollEnabled = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        pan.delegate = self
        self.table.addGestureRecognizer(pan)
        self.table.isHidden = true
        setupData()
        print("user \(idUser)")
    }
    
    //MARK : Function
    func setupData() {
        PeopleController().getFriendsProfile(id: idUser,onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.table.isHidden = false
                self.dataUser = res
                self.setupGroup()
                self.table.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                
            }
        }, onFailed: { (message) in
            print(message)
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            print("Do action when data complete fetching here")
        }
    }
  
    func setupGroup() {
        PeopleController().getFriendsGroup(id: idUser,onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.table.isHidden = false
                self.groupItems = res
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    //MARK: - Gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            if let dir = swipeGesture.direction {
                switch dir {
                case PanDirection.down:
                    print("Swiped down")
                    print(self.table.contentOffset.y)
                    let status = self.table.contentOffset.y <= 0
                    self.table.isScrollEnabled = !status
                    childDelegate?.onSwipeUp(status: status)
                default:
                    break
                }
            }
        }
    }
    
}

extension ProfileFriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4{
            return 60
        } else if indexPath.row == 1 || indexPath.row == 3 {
            return 137
        }else {
            return UITableViewAutomaticDimension
        }
    }
}

extension ProfileFriendsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        view1.backgroundColor = UIColor.clear
        self.view.addSubview(view1)
        
        return view1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Role")
            
        } else if indexPath.row == 1 {
            return RoleTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: self.dataUser)
            
        }else if indexPath.row == 2 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Contact")
            
        }else if indexPath.row == 3 {
            return ContactTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: self.dataUser)
            
        }else if indexPath.row == 4 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Groups")
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupFriendsTableViewCell.identifier, for: indexPath) as! GroupFriendsTableViewCell
            cell.context = self
            cell.groupItems = groupItems
            cell.collectionView.reloadData()
            cell.collectionView.layoutIfNeeded()
            cell.constraintHeightCollection.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
           
            return cell
           // return GroupFriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
        }
    }

}

extension ProfileFriendsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            childDelegate?.scrollViewOffSet(offsetY: scrollView.contentOffset.y)
            childDelegate?.scrollOnScroll(scrollView: scrollView)
        }
    }
}
