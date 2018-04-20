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
    
    internal var dataSource: [(section: String, type: Int, data: [Any])] = [] {
        didSet {
            self.table.reloadData()
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
        self.spinner.startAnimating()
        AgendaController().getAgenda(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.dataSource = []

                if let nextAgenda = res.upNext {
                    self.dataSource.append((section: "Up Next", type: 0, data: [nextAgenda]))
                }
                
                if res.today.count > 0 {
                    self.dataSource.append((section: "Today", type: 1, data: res.today))
                }
                
                if res.tomorrow.count > 0 {
                    self.dataSource.append((section: "Tomorrow", type: 2, data: res.tomorrow))
                }
                
                self.table.isHidden = false
                self.lblNoAgenda.isHidden = true
                
                if res.isCreate {
                    self.btnCreateAgenda.isHidden = false
                }else{
                    self.btnCreateAgenda.isHidden = true
                }
                
            }
        }, onFailed: { (code, message) in
            if code == 202 {
                print(message)
                self.lblNoAgenda.isHidden = false
                self.table.isHidden = true
                self.btnCreateAgenda.isHidden = true
            } else {
                print(message)
                print("Do action when data failed to fetching here")
            }
        }, onComplete: { (code, message, result) in
            print(message)
            guard let res = result else {return}
            self.lblNoAgenda.isHidden = false
            self.table.isHidden = true
            if res.isCreate {
                self.btnCreateAgenda.isHidden = false
            }else{
                self.btnCreateAgenda.isHidden = true
            }
            print("Do action when data complete fetching here")
        })

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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as! HeaderTableViewCell
        cell.lblHeader.text = dataSource[section].section
        cell.btnSeeAll.isHidden = true
        cell.imgArrow.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section].data[indexPath.row]
        if let data = data as? DataUpNext {
            return UpNextTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        } else if let data = data as? DataAgenda {
            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         let data = dataSource[indexPath.section]
        if data.type > 0 {
            return true
        }else{
            return false
        }
       
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let data = dataSource[indexPath.section].data[indexPath.row]
       
        let decline = UITableViewRowAction(style: .normal, title: "Decline") { (action, indexPath) in
            if let data = data as? DataAgenda{
                AgendaController().requestRespond(id: String(data.id), respond: "0", onSuccess: { (code, message, result) in
                    guard let res = result else {return}
                    if res == 200 {
                        let alert = JDropDownAlert()
                        alert.alertWith("Decline", message: "You can change response by clicking button below.", topLabelColor:
                            UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "F52D5A"), image: nil)
                        self.setupData()
                    }
                }, onFailed: { (message) in
                    print(message)
                    print("Do action when data failed to fetching here")
                }) { (message) in
                    print(message)
                    print("Do action when data complete fetching here")
                }
            }
            print("decline")
            // delete item at indexPath
        }
    
        let attend = UITableViewRowAction(style: .normal, title: "Attend") { (action, indexPath) in
            if let data = data as? DataAgenda{
                AgendaController().requestRespond(id: String(data.id), respond: "1", onSuccess: { (code, message, result) in
                    guard let res = result else {return}
                    if res == 200 {
                        let alert = JDropDownAlert()
                        alert.alertWith("Attend", message: "You can change response by clicking button below.", topLabelColor:
                            UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                        self.setupData()
                        
                    }
                }, onFailed: { (message) in
                    print(message)
                    print("Do action when data failed to fetching here")
                }) { (message) in
                    print(message)
                    print("Do action when data complete fetching here")
                }
            }
        
            print("attend")
            // share item at indexPath
        }
        
        decline.backgroundColor = UIColor(hexString: "f52d5a")
        attend.backgroundColor = UIColor(hexString: "1abba4")
    
        return [decline, attend]
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
//        
//        let data = dataSource[indexPath.section].data[indexPath.row]
//        if let data = data as? DataAgenda {
//            vc.idAgenda = String(data.id)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}

extension AgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataSource[indexPath.section]
        if data.type == 0 {
            return 224
        } else if data.type == 1 {
            return 95
        } else if data.type == 2 {
            return 95
        } else {
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
