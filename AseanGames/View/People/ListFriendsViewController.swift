//
//  ListFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ListFriendsViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = FriendsTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: FriendsTableViewCell.identifier)
            
            let xib2 = HeaderFriendsTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: HeaderFriendsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    var childDelegate: ChildOffsetDelegate?
    var idGroup = ""
    internal var friendsItems = [RecipientModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.isScrollEnabled = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        pan.delegate = self
        self.table.addGestureRecognizer(pan)
        setupData()
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

    //MARK: Function
    func setupData(){
        PeopleController().getDetailGroup(id: idGroup, filter: "friends", onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.friendsItems = res.friends
                self.table.isHidden = false
                //                self.spinner.stopAnimating()
                //                self.spinner.isHidden = true
                
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

extension ListFriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        
        return 64
    }
}

extension ListFriendsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let data = friendsItems.count
            return HeaderFriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
        
        let data = friendsItems[indexPath.row - 1]
        return FriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detailFriends) as! DetailFriendsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListFriendsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            childDelegate?.scrollViewOffSet(offsetY: scrollView.contentOffset.y)
            childDelegate?.scrollOnScroll(scrollView: scrollView)
        }
    }
}
