//
//  AgendaViewController.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController {
    @IBOutlet weak var lblAgendaSmall: UILabel!
    @IBOutlet weak var viewAgendaBig: UIView!
    @IBOutlet weak var viewUnderline: UIView!
    @IBOutlet weak var constraintTopTable: NSLayoutConstraint!
    @IBOutlet weak var btnCreateAgenda: UIButton!
    @IBOutlet weak var viewTitleSmall: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lblNoAgenda: UILabel!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = HeaderTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: HeaderTableViewCell.identifier)
            
            let xib2 = UpNextTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: UpNextTableViewCell.identifier)
            
            let xib3 = ListAgendaTableViewCell.nib
            table.register(xib3, forCellReuseIdentifier: ListAgendaTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    internal var upNextItems : DataUpNext?
    internal var todayItems = [DataAgenda](){
        didSet{
            table.reloadData()
        }
    }
    
    internal var tomorrowItems = [DataAgenda](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constraintTopTable.constant = 50
        self.lblAgendaSmall.alpha = 0
        self.viewUnderline.alpha = 0
        self.spinner.startAnimating()
        self.table.isHidden = true
        self.lblNoAgenda.isHidden = true
        self.spinner.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewTitleSmall.backgroundColor = UIColor.clear
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
        AgendaController().getAgenda(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                if res.today.count == 0 && res.tomorrow.count == 0 {
                    self.lblNoAgenda.isHidden = false
                    self.table.isHidden = true
                    self.btnCreateAgenda.isHidden = true
                    
                }else{
                    self.table.isHidden = false
                    self.upNextItems = res.upNext
                    self.todayItems = res.today
                    self.tomorrowItems = res.tomorrow
                    self.table.isHidden = false
                    self.lblNoAgenda.isHidden = true
                    
                    if res.isCreate {
                        self.btnCreateAgenda.isHidden = false
                    }else{
                        self.btnCreateAgenda.isHidden = true
                    }
                }
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
        
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }

    //MARK: Action
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.history) as! HistoryAgendaViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAgenda(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.create) as! CreateAgendaViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AgendaViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + todayItems.count + tomorrowItems.count//(4) header, upnext, row in today and tomorrow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Up Next")
            
        }else if indexPath.row == 1 {
            let data = self.upNextItems
            return UpNextTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
            
        }else if indexPath.row == 2 {
            var title = ""
            if todayItems.count == 0 {
                title = "Tommorow"
            }else {
                title = "Today"
            }
            
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: title)
            
        }
//        else if indexPath.row <= self.todayItems.count {
//            let data = todayItems[indexPath.row-3]
//            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
//       
//        }else if indexPath.row <= self.todayItems.count + 1{
//            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Tomorrow")
//        }
        else if indexPath.row <= self.tomorrowItems.count + self.todayItems.count + 1 {
            let data = todayItems[indexPath.row-3] //tomorrowItems[indexPath.row-3]
            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
        
        return UITableViewCell()
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
        var id = ""
        if indexPath.row == 1 {
            guard let data = self.upNextItems else {return}
            id = String(data.id)
        }else if indexPath.row <= self.tomorrowItems.count + self.todayItems.count + 1 {
            let data = tomorrowItems[indexPath.row-3]
            id = String(data.id)
        }
        vc.idAgenda = id
        self.navigationController?.pushViewController(vc, animated: true)
    }

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row > 2 {
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//     
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//        }
//        
//        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//        
//        share.backgroundColor = UIColor.blue
//        
//        return [delete, share]
//    }
}

extension AgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
            
        } else if indexPath.row == 1 {
            return 224
            
        }else if indexPath.row == 2 {
            return 60
            
        }else if indexPath.row <= self.todayItems.count  || indexPath.row <= self.todayItems.count + 1 || indexPath.row <= self.tomorrowItems.count + self.todayItems.count + 1{
            return 95
            
        }else{
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        table.reloadData()
       // print("y \(scrollView.contentOffset.y)")
        if (scrollView.panGestureRecognizer.translation(in: scrollView.superview)).y < 0 {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.white
                self.viewAgendaBig.alpha = 0
                self.lblAgendaSmall.alpha = 1
                self.viewUnderline.alpha = 1
                self.constraintTopTable.constant = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                
            }, completion: { (done) in
                self.viewTitleSmall.backgroundColor = UIColor.clear
                self.viewAgendaBig.alpha = 1
                self.lblAgendaSmall.alpha = 0
                self.viewUnderline.alpha = 0
                self.constraintTopTable.constant = 50
            })
        }
    }
}
