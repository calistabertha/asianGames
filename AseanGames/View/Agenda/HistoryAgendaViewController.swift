//
//  HistoryAgendaViewController.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class HistoryAgendaViewController: UIViewController {
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = ListAgendaTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: ListAgendaTableViewCell.identifier)
            
            let xib2 = HeaderTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: HeaderTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    var arr : [Int] = []
    var index = 0
    internal var historyItems = [HistoryModel](){
        didSet{
            table.reloadData()
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }
    
    func setupData() {
        AgendaController().getHistory(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.historyItems = res
        
                res.forEach({ (model) in
                    self.arr.append(self.index)
                    self.index += 1 + model.agendas.count
                })
                
                self.table.reloadData()
                
                 print("array \(self.arr)")
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
    
    func detailAgenda(sender: UIButton){
        var row = 0
        
        for var i in 0...self.arr.count-1{
            if self.arr[i] > sender.tag {
                break
            }
            row = i
        }
        
        let item = historyItems[row].agendas[sender.tag - self.arr[row] - 1]
        
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
        vc.idAgenda = String(item.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryAgendaViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let i = self.arr.index(of: indexPath.row){
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as! HeaderTableViewCell
            let data = historyItems[i]
            cell.lblHeader.text = data.date
            cell.btnSeeAll.isHidden = true
            cell.imgArrow.isHidden = true
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListAgendaTableViewCell.identifier, for: indexPath) as! ListAgendaTableViewCell
        var row = 0
        
        for var i in 0...self.arr.count-1{
            if self.arr[i] > indexPath.row {
                break
            }
            row = i
        }
        
        let item = historyItems[row].agendas[indexPath.row - self.arr[row] - 1]
        cell.lblTitle.text = item.title
        cell.lblLocation.text = item.location
        cell.lblTimeStart.text = item.timeStart
        cell.lblTimeEnd.text = item.timeEnd
        if item.response >= 1 {
            cell.imgStripe.isHidden = true
        }else {
            cell.imgStripe.isHidden = false
        }
        
        if (item.timeEnd.range(of: "pm") != nil){
            cell.lblTimeEnd.text = item.timeEnd.replacingOccurrences(of: "pm", with: " ")
            cell.lblAMPM.text = "pm"
        }else{
            cell.lblTimeEnd.text = item.timeEnd.replacingOccurrences(of: "am", with: " ")
            cell.lblAMPM.text = "am"
        }
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(detailAgenda(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
//        vc.idAnnouncement = String(data.id)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HistoryAgendaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 95
        
    }
}
