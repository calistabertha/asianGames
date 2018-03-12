//
//  HeaderTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    var seeAll: ((UITableViewCell) -> Void)?
    
    @IBAction func seeAllSelected(_ sender: Any) {
         seeAll?(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HeaderTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as! HeaderTableViewCell
        guard let data = object as? String else { return cell }
        if data == "Pinned" || data == "Group" || data == "Friends"{
            cell.lblHeader.text = data
            cell.btnSeeAll.isHidden = false
            cell.imgArrow.isHidden = false
            
        }else if data == "Groups"{
            cell.lblHeader.text = "Group"
            cell.btnSeeAll.isHidden = true
            cell.imgArrow.isHidden = true
            
        }else  {
            cell.lblHeader.text = data
            cell.btnSeeAll.isHidden = true
            cell.imgArrow.isHidden = true
            
        }
        
        if data == "Pinned"{
            cell.seeAll = {
                (cells) in
                let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.list) as! ListAnnouncementViewController
                vc.idAnnouncement = 1
                context.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if data == "Group"{
            cell.seeAll = {
                (cells) in
                let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.group) as! GroupViewController
                context.navigationController?.pushViewController(vc, animated: true)
            }
        }else if data == "Friends"{
            cell.seeAll = {
                (cells) in
                let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.friends) as! FriendsViewController
                context.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
}
