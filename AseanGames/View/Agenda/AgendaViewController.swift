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
        
        setupData()
    }
    
    //MARK : Function
    func setupData() {
        AgendaController().getAgenda(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.table.isHidden = false
                self.upNextItems = res.upNext
                self.todayItems = res.today
                self.tomorrowItems = res.tomorrow
                self.table.isHidden = false
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                if res.isCreate {
                    self.btnCreateAgenda.isHidden = false
                }else{
                    self.btnCreateAgenda.isHidden = true
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

    override func viewWillAppear(_ animated: Bool) {
        self.viewTitleSmall.backgroundColor = UIColor.clear
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
        return 4 + todayItems.count + tomorrowItems.count// header, row in today and tomorrow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Up Next")
            
        }else if indexPath.row == 1 {
            let data = self.upNextItems
            return UpNextTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
            
        }else if indexPath.row == 2 {
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Today")
            
        }else if indexPath.row <= self.todayItems.count + 3{
            let data = todayItems[indexPath.row]
            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
       
        }else if indexPath.row == self.todayItems.count + 4{
            return HeaderTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "Tomorrow")
        }
        else if indexPath.row == self.tomorrowItems.count{
            let data = todayItems[indexPath.row - self.tomorrowItems.count ]
            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
        
        return UITableViewCell()
        /*else {
            let data = tomorrowItems[0]
            return ListAgendaTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
         */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
            
        } else if indexPath.row == 1 {
            return 224
            
        }else if indexPath.row == 2 {
            return 60
            
        }else {
            return 95
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
