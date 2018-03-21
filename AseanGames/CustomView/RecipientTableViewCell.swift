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
    @IBOutlet weak var imgDropDown: UIImageView!
    
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
        
        if let data = object as? RecipientModel{
            cell.lblParticipant.isHidden = true
            cell.imgDropDown.isHidden = true
            cell.lblName.text = data.name
            cell.lblTitle.text = data.title
            
            guard let url = URL(string: data.photo) else { return cell}
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
                cell.imgProfile.layer.masksToBounds = true
            })
            
        }else if let data = object as? RSVPModel{
            cell.lblParticipant.isHidden = false
            cell.imgDropDown.isHidden = true
            cell.lblName.text = data.name
            cell.lblTitle.text = data.title
            
            guard let url = URL(string: data.photo) else { return cell}
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
                cell.imgProfile.layer.masksToBounds = true
            })
            
            if data.response == 0 {
                cell.lblParticipant.text = "Decline"
                cell.lblParticipant.textColor = UIColor(hexString:"F52D5A")
            }else {
                cell.lblParticipant.text = "Attend"
                cell.lblParticipant.textColor = UIColor(hexString:"1ABBA4")
            }
           
        }else {
            cell.lblParticipant.isHidden = true
            
        }
        return cell
    }
}
