//
//  HeaderFriendsTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/27/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class HeaderFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTotalFriends: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HeaderFriendsTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderFriendsTableViewCell.identifier, for: indexPath) as! HeaderFriendsTableViewCell
        guard let data = object as? Int else {return cell}
        if data >= 2 {
            cell.lblTotalFriends.text = "\(data) Friends"
        }else{
            cell.lblTotalFriends.text = "\(data) Friend"
        }
        
        return cell
    }
}
