//
//  RecipientTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/15/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class RecipientTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblParticipant: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecipientTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipientTableViewCell.identifier, for: indexPath) as! RecipientTableViewCell
        guard let data = object as? String else { return cell }
        if data == "announcement"{
            cell.lblParticipant.isHidden = true
            
        }else if data == "agenda" {
            cell.lblParticipant.isHidden = false
          
            if indexPath.row % 2 == 0 {
                cell.lblParticipant.text = "Attend"
                cell.lblParticipant.textColor = UIColor(hexString:"1ABBA4")
            }else{
                cell.lblParticipant.text = "Decline"
                cell.lblParticipant.textColor = UIColor(hexString:"F52D5A")
            }
        }else {
            cell.lblParticipant.isHidden = true
            
        }
        return cell
    }
}
