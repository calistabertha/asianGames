//
//  DetailAgendaViewController.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class DetailAgendaViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
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
    @IBOutlet weak var btnAttendDecline: UIButton!
    @IBOutlet weak var viewBtnOption: UIView!
    @IBOutlet weak var btnAttend: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var viewRSVP: UIView!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = RecipientTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: RecipientTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    var decision = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGoing.layer.cornerRadius = viewGoing.frame.size.height*0.5
        btnAttendDecline.isHidden = true
        btnAttend.layer.cornerRadius = 3
        btnDecline.layer.cornerRadius = 3
        btnAttendDecline.layer.cornerRadius = 3
        viewRSVP.isHidden = true
    }

    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openRSVP(_ sender: Any) {
        viewRSVP.isHidden = false
    }
    
    @IBAction func closeMe(_ sender: Any) {
        viewRSVP.isHidden = true
    }
    
    @IBAction func attendOption(_ sender: Any) {
        viewBtnOption.isHidden = true
        btnAttendDecline.isHidden = false
        btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
        btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
        decision = "Attend"
    }
    
    @IBAction func declineOption(_ sender: Any) {
        viewBtnOption.isHidden = true
        btnAttendDecline.isHidden = false
        btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
        btnAttendDecline.backgroundColor = UIColor(hexString: "F52D5A")
        decision = "Decline"
    }
    
    @IBAction func attendDecline(_ sender: Any) {
        let alert = UIAlertController(title: "Change Availability", message: "Want to change availability? Current :\(decision) ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.default, handler: { action in
           
            if self.decision == "Attend" {
                self.decision = "Decline"
                self.btnAttendDecline.setTitle("DECLINE", for: UIControlState.normal)
                self.btnAttendDecline.backgroundColor = UIColor(hexString: "F52D5A")
                
            }else {
                self.decision = "Attend"
                self.btnAttendDecline.setTitle("ATTEND", for: UIControlState.normal)
                self.btnAttendDecline.backgroundColor = UIColor(hexString: "1ABBA4")
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return RecipientTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "agenda")
    }
    
}

extension DetailAgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
