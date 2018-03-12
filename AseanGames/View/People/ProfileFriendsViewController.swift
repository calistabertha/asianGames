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
    var childDelegate: FriendsOffsetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.estimatedRowHeight = 70
        self.table.isScrollEnabled = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        pan.delegate = self
        self.table.addGestureRecognizer(pan)
        
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
            return RoleTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
        }else if indexPath.row == 2 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Contact")
        }else if indexPath.row == 3 {
            return ContactTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
        }else if indexPath.row == 4 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Groups")
        }else {
            return GroupFriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
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
