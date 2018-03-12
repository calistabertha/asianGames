//
//  HistoryViewController.swift
//  AseanGames
//
//  Created by Calista on 1/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ListAnnouncementViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = ListTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: ListTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    var idAnnouncement : Int = 0
    internal var historyItems = [DataAnnouncement](){
        didSet{
            table.reloadData()
        }
    }
    
    internal var pinnedItems = [DataAnnouncement](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if idAnnouncement == 0 {
            lblTitle.text = "History"
        }else{
            lblTitle.text = "Pinned"
        }
    }
    
    //MARK: Function
    func setupData() {
        if idAnnouncement == 0 {
            AnnouncementController().getHistory(onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if code == 200 {
                    self.historyItems = res
                    self.table.isHidden = false
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }else {
            AnnouncementController().getPinned(onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if code == 200 {
                    self.pinnedItems = res
                    self.table.isHidden = false
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
        
    }
    
    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ListAnnouncementViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if idAnnouncement == 0 {
            return historyItems.count
        }else{
            return pinnedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data : DataAnnouncement
        if idAnnouncement == 0 {
            data = self.historyItems[indexPath.row]
        }else{
            data = self.pinnedItems[indexPath.row]
        }
        
        return ListTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        var data : DataAnnouncement
        if idAnnouncement == 0 {
            data = self.historyItems[indexPath.row]
        }else{
            data = self.pinnedItems[indexPath.row]
        }
        vc.idAnnouncement = data.id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ListAnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
        
    }
}


