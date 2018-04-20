//
//  ParentSelectGroupViewController.swift
//  AseanGames
//
//  Created by Calista on 4/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import ICTabFragment

protocol ParentSelected : class {
    func guest(id: [String], name: [String])
    func group(id: [String], name: [String])
 
}

class ParentSelectGroupViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    var group:UIViewController!
    var guest:UIViewController!
    var currentViewController:UIViewController!
//    var guestt : [String]?
//    var guestName : [String]?
//    var groups : [String]?
//    var groupName : [String]?
    var delegate: ParentSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabs()
    }
    
    //MARK: -Function
    func setTabs() {
        group = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Agenda.group)
        guest = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Agenda.friend)
        
        let tabs = [
            ICTabModel(tabName: "Friends", tabView: guest!, isSelected: true),
            ICTabModel(tabName: "Group", tabView: group!, isSelected: false)
        ]
        
        if let pvc = guest as? ChildFriendsViewController {
            pvc.delegate = self
           // pvc.idUser = idUser
        }
        if let avc = group as? ChildGroupViewController{
            avc.delegate = self
           // avc.idUser = idUser
        }
 
        currentViewController = guest
        
        let tabFragment = ICTabFragmentViewController(context: self, tabs: tabs, tabView: viewMenu, containerView: viewContainer)
        tabFragment.indicatorColorSelected = UIColor.black
        tabFragment.indicatorHeight = 2
        tabFragment.indicatorTopSpace = 10
        tabFragment.textColorSelected = UIColor.black
        tabFragment.textColorUnselected = UIColor.black
        tabFragment.tabSize = ICTabSize.fit
        tabFragment.tabFitSize = 2
       // tabFragment.delegate = self
        tabFragment.create()
        
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ParentSelectGroupViewController: FriendsSelected{
    func guest(id: [String], name: [String]) {
//        self.guestt = id
//        self.guestName = name
//        print("parent \(guestt) \(guestName)")
        self.delegate?.guest(id: id, name: name)
    }
}

extension ParentSelectGroupViewController: GroupsSelected{
    func groups(id: [String], name: [String]) {
//        self.groups = id
//        self.groupName = name
        self.delegate?.group(id: id, name: name)
    }
}
