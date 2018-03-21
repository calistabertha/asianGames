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
        guard let data = object as? CommentModel else {return cell}
        cell.lblComment.text = data.comment
        cell.lblName.text = "\(data.user) - \(data.title)"
        cell.lblTime.text = data.createAt
        
        guard let url = URL(string: data.photo) else { return cell}
        cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
            cell.imgProfile.layer.masksToBounds = true
        })
        return cell
    }
}
