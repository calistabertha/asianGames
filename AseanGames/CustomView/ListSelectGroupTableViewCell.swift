//
//  ListSelectGroupTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 4/4/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ListSelectGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var imgCheckbox: UIImageView!
    @IBOutlet weak var viewSelected: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListSelectGroupTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListSelectGroupTableViewCell.identifier, for: indexPath) as! ListSelectGroupTableViewCell
       
        
        return cell
    }
}
