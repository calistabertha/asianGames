//
//  DetailGroupViewController.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import ICTabFragment

protocol ChildOffsetDelegate : class {
    func scrollViewOffSet(offsetY: CGFloat)
    func scrollOnScroll(scrollView:UIScrollView)
    func onSwipeUp(status:Bool)
}

class DetailGroupViewController: UIViewController {
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var scroll: SubClassScrollView!{
        didSet{
            scroll.delegate = self
            scroll.bounces = false
            scroll.panGestureRecognizer.addTarget(self, action: #selector(respondToSwipeGesture(gesture:)))
        }
    }
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var friends:UIViewController!
    var announcement:UIViewController!
    var idGroup = ""
    var currentViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setTabs()
    }

    func setTabs() {
        friends = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.People.listFriends)
        announcement = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.People.announcement)
        
        let tabs = [
            ICTabModel(tabName: "Friends", tabView: friends!, isSelected: true),
            ICTabModel(tabName: "Announcement", tabView: announcement!, isSelected: false)
        ]
        currentViewController = friends
        
        if let fvc = friends as? ListFriendsViewController {
            fvc.idGroup = idGroup
            fvc.childDelegate = self
        }
        if let ann = announcement as? PeopleAnnouncementViewController{
            ann.idGroup = idGroup
            ann.childDelegate = self
        }
        
        let tabFragment = ICTabFragmentViewController(context: self, tabs: tabs, tabView: viewMenu, containerView: viewContainer)
        tabFragment.indicatorColorSelected = UIColor.black
        tabFragment.indicatorHeight = 2
        tabFragment.indicatorTopSpace = 10
        tabFragment.textColorSelected = UIColor.black
        tabFragment.textColorUnselected = UIColor.black
        tabFragment.tabSize = ICTabSize.fit
        tabFragment.tabFitSize = 2
        tabFragment.delegate = self
        tabFragment.create()
      
    }
    
    //MARK: Function
    func setupData(){
        PeopleController().getDetailGroup(id: idGroup, filter: "friends", onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.lblName.text = res.group.name
                guard let url = URL(string: res.group.photo) else { return }
                self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                   
                    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height*0.5
                    self.imgProfile.layer.masksToBounds = true
                })
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            if let dir = swipeGesture.direction {
                switch dir {
                case PanDirection.down:
                    print("Swiped down")
                    let status = self.scroll.contentOffset.y <= 0
                    self.scroll.isScrollEnabled = !status
                    
                default:
                    break
                }
            }
        }
    }
    
    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

public enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}

extension UIPanGestureRecognizer {
    
    public var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = fabs(velocity.y) > fabs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
        
    }
}

extension DetailGroupViewController: UIScrollViewDelegate, ICTabFragmentDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y >= 222 {
            scrollView.isScrollEnabled = false
            scrollView.contentOffset.y = 222
        }
        
        if currentViewController == friends {
            let f = friends as! ListFriendsViewController
            f.table.isScrollEnabled = true
        }
        if currentViewController == announcement {
            let a = announcement as! PeopleAnnouncementViewController
            a.table.isScrollEnabled = true
        }
    }
    
    //    scrolview
    func currentViewController(_ viewController: UIViewController) {
        self.currentViewController = viewController
        print("currentViewController")
        if currentViewController == friends {
            let f = friends as! ListFriendsViewController
            if f.table.contentOffset.y <= 0 {
                scroll.isScrollEnabled = true
            }
            f.table.isScrollEnabled = !scroll.isScrollEnabled
        }
        if currentViewController == announcement {
            let a = announcement as! PeopleAnnouncementViewController
            if a.table.contentOffset.y <= 0 {
                scroll.isScrollEnabled = true
            }
            a.table.isScrollEnabled = !scroll.isScrollEnabled
        }
    }
}

extension DetailGroupViewController: ChildOffsetDelegate {
    func scrollViewOffSet(offsetY: CGFloat) {
        if offsetY <= 0 {
            scroll.isScrollEnabled = true
        }
    }
    
    func scrollOnScroll(scrollView: UIScrollView) {
        
    }
    
    func onSwipeUp(status: Bool) {
        self.scroll.isScrollEnabled = status
    }
}

