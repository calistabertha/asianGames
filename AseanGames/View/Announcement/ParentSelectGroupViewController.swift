//
//  ParentSelectGroupViewController.swift
//  AseanGames
//
//  Created by Calista on 4/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import ICTabFragment

class ParentSelectGroupViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var constraintTopView: NSLayoutConstraint!
    
    @IBOutlet weak var constraintBottomHeader: NSLayoutConstraint!
    var idTitle : Int?
    var group:UIViewController!
    var guest:UIViewController!
    var currentViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         group = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Announcement.selectGroup)
        
        if idTitle == 0{
            lblTitle.text = "Select Group"
            viewMenu.isHidden = true
            constraintTopView.constant = 0
            viewContainer.addSubview(group.view)
            self.loadViewIfNeeded()
        }else{
             lblTitle.text = "Select Guest"
             viewMenu.isHidden = false
            setTabs()
        }
    }
    
    //MARK: -Function
    func setTabs() {
        group = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Announcement.selectGroup)
        guest = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.Agenda.selectGuest)
        
        let tabs = [
            ICTabModel(tabName: "Friends", tabView: guest!, isSelected: true),
            ICTabModel(tabName: "Group", tabView: group!, isSelected: false)
        ]
        
/*        if let pvc = guest as? SelectGuestViewController {
          //  pvc.childDelegate = self
           // pvc.idUser = idUser
        }
        if let avc = group as? ParentSelectGroupViewController{
           // avc.childDelegate = self
           // avc.idUser = idUser
        }
 */
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
