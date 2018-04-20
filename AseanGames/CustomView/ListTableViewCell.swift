//
//  ListTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 1/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SDWebImage

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var imgPinned: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        if let data = object as? DataAnnouncement{
            cell.lblTitle.text = data.title
            cell.lblDesc.text = data.description
            cell.lblName.text = data.user
            cell.lblDivision.text = data.assignment
            if data.createAt == ""{
                cell.lblDate.text = data.date
            }else{
                cell.lblDate.text = data.createAt
            }
            
            if data.pinned {
                cell.imgPinned.isHidden = false
            }else{
                cell.imgPinned.isHidden = true
            }
            
            guard let url = URL(string: data.photo) else { return cell }
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
                cell.imgProfile.layer.masksToBounds = true
            })
        }
       
        
        //cell.viewList.dropShadow()
        
        return cell
    }
}
