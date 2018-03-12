//
//  SettingsTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
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

extension SettingsTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.viewBorder.layer.borderWidth = 1
        let gray = UIColor(red: 159.0/255.0, green: 159.0/255.0, blue: 159.0/255.0, alpha: 1.0)
        cell.viewBorder.layer.borderColor = gray.cgColor
        
        guard let data = object as? Int else {return cell}
        if data == 0 {
            cell.lblTitle.text = "Profile"
        }else if data == 1 {
            cell.lblTitle.text = "Help"
        }else if data == 2 {
            cell.lblTitle.text = "Change Password"
        }else{
            cell.lblTitle.text = "Logout"
        }
        
        guard let datas = object as? String else {return cell}
        if datas == "Help0"{
            cell.lblTitle.text = "FAQ"
        }else {
            cell.lblTitle.text = "Support"
        }
        return cell
    }
}
