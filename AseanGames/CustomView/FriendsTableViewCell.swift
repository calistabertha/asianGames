//
//  FriendsTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
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

extension FriendsTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
        cell.viewBorder.dropShadow()
        return cell
    }
}
