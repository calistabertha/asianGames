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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListAgendaTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListAgendaTableViewCell.identifier, for: indexPath) as! ListAgendaTableViewCell
        guard let data = object as? DataAgenda else {return cell}
        cell.lblTitle.text = data.title
        cell.lblLocation.text = data.location
        cell.lblTimeStart.text = data.timeStart
        cell.lblTimeEnd.text = data.timeEnd
        if (data.timeEnd.range(of: "pm") != nil){
            cell.lblTimeEnd.text = data.timeEnd.replacingOccurrences(of: "pm", with: " ")
            cell.lblAMPM.text = "pm"
        }else{
            cell.lblTimeEnd.text = data.timeEnd.replacingOccurrences(of: "am", with: " ")
            cell.lblAMPM.text = "am"
        }
        cell.viewBorder.dropShadow()
        return cell
    }
}
