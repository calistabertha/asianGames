//
//  AgendaFriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class AgendaFriendsViewController: UIViewController, UIGestureRecognizerDelegate {
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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var arr : [Int] = []
    var index = 0
    internal var agendasItems = [HistoryModel](){
        didSet{
            table.reloadData()
        }
    }
    
    var idUser = ""
    var childDelegate: FriendsOffsetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        self.table.isScrollEnabled = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        pan.delegate = self
        self.table.addGestureRecognizer(pan)
        self.table.isHidden = true
        setupData()
        
    }
    //MARK: Function
    func setupData() {
        PeopleController().getFriendsAgenda(id: idUser, onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.agendasItems = res
                
                res.forEach({ (model) in
                    self.arr.append(self.index)
                    self.index += 1 + model.agendas.count
                    print("model \(model.agendas.count)")
                })
                
                print("index \(self.index)")
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
    
    //MARK: - Gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            if let dir = swipeGesture.direction {
                switch dir {
                case PanDirection.down:
                    print("Swiped down")
                    print(self.table.contentOffset.y)
                    let status = self.table.contentOffset.y <= 0
                    self.table.isScrollEnabled = !status
                    childDelegate?.onSwipeUp(status: status)
                default:
                    break
                }
            }
        }
    }
}

extension AgendaFriendsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let i = self.arr.index(of: indexPath.row){
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as! HeaderTableViewCell
            let data = agendasItems[i]
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
        print("row \(row)")
        
        let item = agendasItems[row].agendas[indexPath.row - self.arr[row] - 1]
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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AgendaFriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.arr.index(of: indexPath.row){
            return 60
        }
        return 95
        
    }
}
