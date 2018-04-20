//
//  ListAgendaTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ListAgendaTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var lblAMPM: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var imgStripe: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    var attend: ((UITableViewCell) -> Void)?
    var decline: ((UITableViewCell) -> Void)?
    var select: ((UITableViewCell) -> Void)?
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBAction func attendSelected(_ sender: Any) {
        attend?(self)
    }
    
    @IBAction func declineSelected(_ sender: Any) {
        decline?(self)
    }
    
    @IBAction func cellSelected(_ sender: Any) {
        select?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

}

extension ListAgendaTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListAgendaTableViewCell.identifier, for: indexPath) as! ListAgendaTableViewCell
        guard let data = object as? DataAgenda else {return cell}
        cell.lblTitle.text = data.title
        cell.lblLocation.text = data.location.replacingOccurrences(of: "#", with: ", ")
        cell.lblTimeStart.text = data.timeStart
        cell.lblTimeEnd.text = data.timeEnd
        if (data.timeEnd.range(of: "pm") != nil){
            cell.lblTimeEnd.text = data.timeEnd.replacingOccurrences(of: "pm", with: " ")
            cell.lblAMPM.text = "pm"
        }else{
            cell.lblTimeEnd.text = data.timeEnd.replacingOccurrences(of: "am", with: " ")
            cell.lblAMPM.text = "am"
        }
        
        if data.response <= 1 {
            cell.imgStripe.isHidden = false
        }else {
            cell.imgStripe.isHidden = true
        }
        //cell.viewBorder.dropShadow()
        
        cell.select = {
            (cells) in
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
            vc.idAgenda = String(data.id)
            context.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}
