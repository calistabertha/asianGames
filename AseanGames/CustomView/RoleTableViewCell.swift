//
//  RoleTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class RoleTableViewCell: UITableViewCell {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDivision: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RoleTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoleTableViewCell.identifier, for: indexPath) as! RoleTableViewCell
        cell.txtTitle.isUserInteractionEnabled = false
        cell.txtDivision.isUserInteractionEnabled = false
        return cell
    }
}
