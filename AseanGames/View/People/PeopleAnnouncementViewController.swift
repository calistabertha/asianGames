//
//  PeopleAnnouncementViewController.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class PeopleAnnouncementViewController: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = ListTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: ListTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    var childDelegate: ChildOffsetDelegate?
    var idGroup = ""
    internal var announcementItems = [DataAnnouncement](){
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
    
    //MARK: Function
    func setupData(){
        PeopleController().getDetailGroup(id: idGroup, filter: "announcements", onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.announcementItems = res.announcement
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
                    print("watch Swiped down")
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

extension PeopleAnnouncementViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = announcementItems[indexPath.row]
        return ListTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        let data = announcementItems[indexPath.row]
        vc.idAnnouncement = data.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PeopleAnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
        
    }
}

extension PeopleAnnouncementViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            childDelegate?.scrollViewOffSet(offsetY: scrollView.contentOffset.y)
            childDelegate?.scrollOnScroll(scrollView: scrollView)
        }
    }
}
