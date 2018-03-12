//
//  ContactTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/28/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ContactTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        cell.txtEmail.isUserInteractionEnabled = false
        cell.txtPhone.isUserInteractionEnabled = false
        return cell
    }
}
