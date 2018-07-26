//
//  DetailAgendaViewController.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class DetailAgendaViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewGoing: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAgenda: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCreateAgenda: UILabel!
    @IBOutlet weak var lblMoreRSVP: UILabel!
    @IBOutlet weak var btnAttendDecline: UIButton!
    @IBOutlet weak var viewBtnOption: UIView!
    @IBOutlet weak var btnAttend: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var viewRSVP: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableRSVP: UITableView!{
        didSet{
            let xib = RecipientTableViewCell.nib
            tableRSVP.register(xib, forCellReuseIdentifier: RecipientTableViewCell.identifier)
            
            tableRSVP.dataSource = self
            tableRSVP.delegate = self
        }
    }
    @IBOutlet weak var viewResponsRSVP: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnOpenRSVP: UIButton!
    @IBOutlet var imageCollection: [UIImageView]!
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var constraintHeightRSVP: NSLayoutConstraint!
    
    var decision = 0
    var idAgenda: String?
    var recipientItem = [RSVPModel](){
        didSet{
            tableRSVP.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGoing.layer.cornerRadius = viewGoing.frame.size.height*0.5
        btnAttendDecline.isHidden = true
        btnAttend.layer.cornerRadius = 3
        btnDecline.layer.cornerRadius = 3
        btnAttendDecline.layer.cornerRadius = 3
        viewRSVP.isHidden = true
        spinner.startAnimating()
        table.isHidden = true
        setupData()
       
    }
    
    //MARK: Function
    func setupData(){
        guard let id = idAgenda else {return}
        AgendaController().getDetail(id: id, onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.table.isHidden = false
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.lblTitle.text = res.title
                self.lblDate.text = res.date
                self.lblTime.text = res.time
                self.lblLocation.text = res.location
                self.lblAddress.text = res.address
                self.lblAgenda.text = res.description
                self.lblName.text = res.user
                self.lblDivision.text = res.assignment
                self.lblCreateAgenda.text = res.createAt
               
                if res.attendants.count == 0{
                    self.viewResponsRSVP.isHidden = true
                    self.constraintHeightRSVP.constant = 0
                    self.btnOpenRSVP.isUserInteractionEnabled = false
                    self.btnOpenRSVP.isHidden = true
                    
                } else if res.attendants.count < 5 {
                    if res.more == 0 {
                        self.viewGoing.isHidden = true
                        self.lblGoing.isHidden = true
                    }else {
                        self.viewGoing.isHidden = false
                        self.lblGoing.isHidden = false
                        self.lblMoreRSVP.text = String(res.more)
                    }
                    
                } else {
                    self.viewGoing.isHidden = false
                    self.lblGoing.isHidden = false
                    self.lblMoreRSVP.text = String(res.more)
                }
                
                if res.respond == 0{
                    self.viewBtnOption.isHidden = true
                    self.btnAttendDecline.isHidden = false
                    self.decision = 0
                    if res.isPast{
                        self.btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "C5C5C5")
                        self.btnAttendDecline.setTitleColor(UIColor(hexString: "9F9F9F"), for: UIControlState.normal)
                        
                    }else {
                        self.btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "F52D5A")
                       self.btnAttendDecline.setTitleColor(UIColor.white, for: UIControlState.normal)
                    }
                }else if res.respond == 1{
                    self.viewBtnOption.isHidden = true
                    self.btnAttendDecline.isHidden = false
                    self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                    self.btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
                    self.decision = 1
                    
                    if res.isPast{
                        self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "C5C5C5")
                        self.btnAttendDecline.setTitleColor(UIColor(hexString: "9F9F9F"), for: UIControlState.normal)
                        
                    }else {
                        self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
                        self.btnAttendDecline.setTitleColor(UIColor.white, for: UIControlState.normal)
                    }
                    
                }else if res.respond == 2{
                    self.viewBtnOption.isHidden = false
                    self.btnAttendDecline.isHidden = true
                    
                    if res.isPast{
                        self.btnDecline.backgroundColor = UIColor(hexString: "C5C5C5")
                        self.btnDecline.setTitleColor(UIColor(hexString: "9F9F9F"), for: UIControlState.normal)
                        self.btnDecline.isUserInteractionEnabled = false
                        
                        self.btnAttend.backgroundColor = UIColor(hexString: "C5C5C5")
                        self.btnAttend.setTitleColor(UIColor(hexString: "9F9F9F"), for: UIControlState.normal)
                        self.btnAttend.isUserInteractionEnabled = false
                        
                    }else {
                        self.btnAttend.backgroundColor = UIColor(hexString: "1ABBA4")
                        self.btnAttend.setTitleColor(UIColor.white, for: UIControlState.normal)
                        
                        self.btnDecline.backgroundColor = UIColor(hexString: "F52D5A")
                        self.btnDecline.setTitleColor(UIColor.white, for: UIControlState.normal)
                    }
                
                    
                }
                
                guard let url = URL(string: res.photo) else { return }
                self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height*0.5
                    self.imgProfile.layer.masksToBounds = true
                })
                
                if res.attendants.count > 0 {
                    for var i in 0...res.attendants.count-1{
                        let image = self.imageCollection[i]
                        image.isHidden = false
                        
                        guard let url = URL(string: res.attendants[i]) else { return }
                        image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                            image.layer.cornerRadius = image.frame.size.height*0.5
                            image.layer.masksToBounds = true
                        })
                    }
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
    
    func getRSVP(){
        guard let id = idAgenda else {return}
        AgendaController().getRecipient(id: id, onSuccess: { (code, message, result) in
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
    
    @IBAction func openRSVP(_ sender: Any) {
        getRSVP()
        viewRSVP.isHidden = false
    }
    
    @IBAction func closeMe(_ sender: Any) {
        viewRSVP.isHidden = true
    }
    
    @IBAction func attendOption(_ sender: Any) {
        guard let id = idAgenda else {return}
        AgendaController().requestRespond(id: id, respond: "1", onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if res == 200 {
                let alert = JDropDownAlert()
                alert.alertWith("Attend", message: "You can change response by clicking button below.", topLabelColor:
                    UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                
                self.viewBtnOption.isHidden = true
                self.btnAttendDecline.isHidden = false
                self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                self.btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
                self.decision = 1
                self.table.reloadData()
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    @IBAction func declineOption(_ sender: Any) {
        guard let id = idAgenda else {return}
        AgendaController().requestRespond(id: id, respond: "0", onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if res == 200 {
                let alert = JDropDownAlert()
                alert.alertWith("Decline", message: "You can change response by clicking button below.", topLabelColor:
                    UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "F52D5A"), image: nil)
                
                self.viewBtnOption.isHidden = true
                self.btnAttendDecline.isHidden = false
                self.btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
                self.btnAttendDecline.backgroundColor = UIColor(hexString: "F52D5A")
                self.decision = 0
                self.table.reloadData()
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    @IBAction func attendDecline(_ sender: Any) {
        var desc = ""
        if self.decision == 0 {
            desc = "Decline"
        }else{
            desc = "Attend"
        }
        
        guard let id = idAgenda else {return}
        let alert = UIAlertController(title: "Change Availability", message: "Want to change availability? Current :\(desc) ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.default, handler: { action in
            var dec = ""
            if self.decision == 0{
                dec = "1"
            }else{
                dec = "0"
            }
            AgendaController().requestRespond(id: id, respond: dec, onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if res == 200 {
                    if self.decision == 1 {
                        self.decision = 0
                        self.btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "F52D5A")
                        
                    }else {
                        self.decision = 1
                        self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                        self.btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
                    }
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
            
           
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil )
        
        
        
        
        
    }
    
}

extension DetailAgendaViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipientItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = recipientItem[indexPath.row]
        return RecipientTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
    }
    
}

extension DetailAgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
