//
//  AddAttachmentTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 3/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class AddAttachmentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AddAttachmentTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddAttachmentTableViewCell.identifier, for: indexPath) as! AddAttachmentTableViewCell
        return cell
    }
}
