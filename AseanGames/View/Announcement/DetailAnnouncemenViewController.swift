//
//  DetailAnnouncemenViewController.swift
//  AseanGames
//
//  Created by Calista on 1/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class DetailAnnouncemenViewController: UIViewController {
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblValid: UILabel!
    @IBOutlet weak var btnSeeComment: UIButton!
    @IBOutlet weak var viewOthers: UIView!
    @IBOutlet weak var viewRecipient: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = RecipientTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: RecipientTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    var idAnnouncement: String?
    var recipientItem = [RecipientModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnDownload.layer.cornerRadius = 2
        btnSeeComment.layer.cornerRadius = 2
        lblValid.layer.cornerRadius = 2
        viewOthers.layer.cornerRadius = viewOthers.frame.size.height*0.5
        viewRecipient.isHidden = true
        setupData()
    }
    
    //MARK: Function
    func setupData(){
        guard let id = idAnnouncement else {return}
        AnnouncementController().getDetailAnnouncement(id: id, onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.lblTitle.text = res.title
                self.lblDesc.font = UIFont(name: "OpenSans-Regular", size: 13)
                self.lblDesc.text = res.description
                self.lblDate.text = res.creatAt
                self.lblValid.text = res.date
                self.lblOthers.text = ("+\(res.recipient.more)")
                self.lblName.text = res.user
                self.lblDivision.text = res.assigment
                guard let url = URL(string: res.photo) else { return }
                self.imgProfile.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, completed: { (img, error, type, url) in
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
    
    func setupRecipient(){
        guard let id = idAnnouncement else {return}
        AnnouncementController().getRecipient(id: id, onSuccess: { (code, message, result) in
            if code == 200 {
                guard let res = result else {return}
                self.recipientItem = res
                
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
    
    @IBAction func closeRecipient(_ sender: Any) {
        viewRecipient.isHidden = true
    }
    
    //MARK : Action
    @IBAction func openRecipient(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
            
        }, completion: { (done) in
            self.viewRecipient.isHidden = false
        })
    }
    @IBAction func seeComment(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.comment) as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension DetailAnnouncemenViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipientItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return RecipientTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "announcement")
        
    }
    
}

extension DetailAnnouncemenViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
