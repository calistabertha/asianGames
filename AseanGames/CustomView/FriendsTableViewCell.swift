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
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var viewSelect: UIView!
    
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
        guard let data = object as? RecipientModel else {return cell}
        cell.viewButton.isHidden = true
        cell.lblName.text = data.name
        cell.lblTitle.text = data.title
        guard let url = URL(string: data.photo) else { return cell }
        cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
            cell.imgProfile.layer.masksToBounds = true
        })
       // cell.viewBorder.dropShadow()
       // cell.viewBorder.layer.borderWidth = 1
//        let gray = UIColor(red: 159.0/255.0, green: 159.0/255.0, blue: 159.0/255.0, alpha: 1.0)
//        cell.viewBorder.layer.borderColor = gray.cgColor
        
        return cell
    }
}
