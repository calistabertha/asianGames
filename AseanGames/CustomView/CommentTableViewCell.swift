//
//  CommentTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/15/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CommentTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        return cell
    }
}
