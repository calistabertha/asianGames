//
//  DetailFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import ICTabFragment

protocol FriendsOffsetDelegate : class {
    func scrollViewOffSet(offsetY: CGFloat)
    func scrollOnScroll(scrollView:UIScrollView)
    func onSwipeUp(status:Bool)
}

class DetailFriendsViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var scroll: SubClassScrollView!{
        didSet{
            scroll.delegate = self
            scroll.bounces = false
            scroll.panGestureRecognizer.addTarget(self, action: #selector(respondToSwipeGesture(gesture:)))
        }
    }
    
    var profile:UIViewController!
    var agenda:UIViewController!
    var idUser = ""
    var currentViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupData()
    }
    
    
    func setTabs() {
        profile = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.People.profile)
        agenda = UIStoryboard(name: StoryboardReferences.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerID.People.agenda)
        
        let tabs = [
            ICTabModel(tabName: "Profile", tabView: profile!, isSelected: true),
            ICTabModel(tabName: "Agenda", tabView: agenda!, isSelected: false)
        ]
        
        if let pvc = profile as? ProfileFriendsViewController {
            pvc.childDelegate = self
            pvc.idUser = idUser
        }
        if let avc = agenda as? AgendaFriendsViewController{
            avc.childDelegate = self
            avc.idUser = idUser
        }
        
        currentViewController = profile
        
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
    
    //MARK : Function
    func setupData() {
        PeopleController().getFriendsProfile(id: idUser,onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.lblName.text = "\(res.firstName) \(res.lastName)"
                if res.photo == ""{
                    self.imgProfile.image = #imageLiteral(resourceName: "img-placeholder")
               
                }else{
                    guard let url = URL(string: res.photo) else { return }
                    self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                        print("eror \(String(describing: error)) \(type)")
                        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height*0.5
                        self.imgProfile.layer.masksToBounds = true
                    })
                }
              
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailFriendsViewController: UIScrollViewDelegate, ICTabFragmentDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y >= 222 {
            scrollView.isScrollEnabled = false
            scrollView.contentOffset.y = 222
        }
        
        if currentViewController == profile {
            let p = profile as! ProfileFriendsViewController
            p.table.isScrollEnabled = true
        }
        if currentViewController == agenda {
            let a = agenda as! AgendaFriendsViewController
            a.table.isScrollEnabled = true
        }
    }
    
    //    scrolview
    func currentViewController(_ viewController: UIViewController) {
        self.currentViewController = viewController
        print("currentViewController")
        if currentViewController == profile {
            let p = profile as! ProfileFriendsViewController
            if p.table.contentOffset.y <= 0 {
                scroll.isScrollEnabled = true
            }
            p.table.isScrollEnabled = !scroll.isScrollEnabled
        }
        if currentViewController == agenda {
            let a = agenda as! AgendaFriendsViewController
            if a.table.contentOffset.y <= 0 {
                scroll.isScrollEnabled = true
            }
            a.table.isScrollEnabled = !scroll.isScrollEnabled
        }
    }
}

extension DetailFriendsViewController: FriendsOffsetDelegate {
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

