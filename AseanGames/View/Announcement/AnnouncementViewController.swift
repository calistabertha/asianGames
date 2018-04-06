//
//  AnnouncementViewController.swift
//  AseanGames
//
//  Created by Calista on 1/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class AnnouncementViewController: UIViewController {
    @IBOutlet weak var lblSmallAnnouncement: UILabel!
    @IBOutlet weak var viewBigAnnouncement: UIView!
    @IBOutlet weak var viewUnderline: UIView!
    @IBOutlet weak var constraintTopTable: NSLayoutConstraint!
    @IBOutlet weak var viewTitleSmall: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = HeaderTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: HeaderTableViewCell.identifier)
            
            let xib2 = AnnouncementTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: AnnouncementTableViewCell.identifier)
            
            let xib3 = ListTableViewCell.nib
            table.register(xib3, forCellReuseIdentifier: ListTableViewCell.identifier)
        
            table.dataSource = self
            table.delegate = self
        }
    }
    internal var pinnedItems = [DataAnnouncement](){
        didSet{
            table.reloadData()
        }
    }
    
    internal var recentItems = [DataAnnouncement]() {
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        self.table.isHidden = true
        self.constraintTopTable.constant = 50
        self.lblSmallAnnouncement.alpha = 0
        self.viewUnderline.alpha = 0
        self.viewTitleSmall.backgroundColor = UIColor.clear
        self.btnCreate.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.spinner.startAnimating()
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
        AnnouncementController().getAnnouncement(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.pinnedItems = res.pinned
                self.recentItems = res.recent
                self.table.isHidden = false
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                if res.isCreate {
                    self.btnCreate.isHidden = false
                }else{
                    self.btnCreate.isHidden = true
                }
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
    
    //MARK : Action
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.list) as! ListAnnouncementViewController
        vc.idAnnouncement = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func createAnnouncement(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.create) as! CreateAnnouncementViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AnnouncementViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + self.recentItems.count // 3 = 2 header + 1 collectionPinned
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Pinned")
            
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as! AnnouncementTableViewCell
            cell.context = self
            cell.pinnedData = self.pinnedItems
            return cell
            
        }else if indexPath.row == 2 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Recent")
            
        }else {
            return ListTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: self.recentItems[indexPath.row-3])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        let data = self.recentItems[indexPath.row-3]
        vc.idAnnouncement = data.id
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
}

extension AnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
            
        } else if indexPath.row == 1 {
            return 270
            
        }else if indexPath.row == 2 {
            return 60
            
        }else {
            return 175
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        table.reloadData()
    //    print("y \(scrollView.contentOffset.y)")
        if (scrollView.panGestureRecognizer.translation(in: scrollView.superview)).y < 0 {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.white
                self.viewBigAnnouncement.alpha = 0
                self.lblSmallAnnouncement.alpha = 1
                self.viewUnderline.alpha = 1
                self.constraintTopTable.constant = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.clear
                self.viewBigAnnouncement.alpha = 1
                self.lblSmallAnnouncement.alpha = 0
                self.viewUnderline.alpha = 0
                self.constraintTopTable.constant = 50
            })
        }
    }
}
