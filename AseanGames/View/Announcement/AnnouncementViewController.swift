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
    
    @IBOutlet weak var lblNoAnnouncement: UILabel!
    
     var nextPage = 0
    
    internal var pinnedItems = [DataPinned](){
        didSet{
            table.reloadData()
        }
    }

    internal var dataSource: [(section: String, type: Int, data: [Any])] = [] {
        didSet {
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.isHidden = true
        self.constraintTopTable.constant = 50
        self.lblSmallAnnouncement.alpha = 0
        self.viewUnderline.alpha = 0
        self.viewTitleSmall.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.spinner.startAnimating()
        self.lblNoAnnouncement.isHidden = true
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
                self.dataSource = []
                
                if res.pinned.count > 0 {
                    self.dataSource.append((section: "Pinned", type: 0, data: res.pinned))
                    self.pinnedItems = res.pinned
                }
                
                if res.recent.count > 0 {
                    self.dataSource.append((section: "Recent", type: 1, data: res.recent))
//                    self.recentItems = res.recent
//                    self.setRecent(isInit: true, nextURL: 1)
                }
                
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
            self.table.isHidden = true
            self.lblNoAnnouncement.isHidden = false
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
//            self.table.isHidden = true
//            self.lblNoAnnouncement.isHidden = false
            print("Do action when data complete fetching here")
        }
        self.btnCreate.isHidden = false
    }
    
    func openSeeAll(sender : UIButton){
        let data = dataSource[sender.tag].section
        if sender.tag == 0 {
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.list) as! ListAnnouncementViewController
            vc.idAnnouncement = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("see all \(sender.tag), \(data)")
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource[section].type == 0 {
            return 1
        }
        return dataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as! HeaderTableViewCell
        cell.lblHeader.text = dataSource[section].section
        if section == 1 {
            cell.imgArrow.isHidden = true
            cell.btnSeeAll.isHidden = true
            cell.btnSeeAll.isUserInteractionEnabled = false
        }
        cell.btnSeeAll.tag = section
        cell.btnSeeAll.addTarget(self, action: #selector(openSeeAll(sender:)), for: .touchUpInside)
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section].data[indexPath.row]
        if dataSource[indexPath.section].type == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as! AnnouncementTableViewCell
            cell.context = self
            cell.pinnedData = pinnedItems
            return cell
            
        }else if let data = data as? DataAnnouncement{
            return ListTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object:data)
            
        }else{
            return UITableViewCell()
        }
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        
        let data = dataSource[indexPath.section].data[indexPath.row]
        if let data = data as? DataPinned {
            vc.idAnnouncement = String(data.id)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let data = data as? DataAnnouncement {
            vc.idAnnouncement = String(data.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
}

extension AnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let data = dataSource[indexPath.section]
        if data.type == 0 {
            return 270
        }else if data.type == 1 {
            return 166
        }else{
            return 0
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
