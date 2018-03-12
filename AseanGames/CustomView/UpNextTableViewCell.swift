//
//  UpNextTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class UpNextTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewGoing: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func attendSelected(_ sender: Any) {
    }
    
    @IBAction func declineSelected(_ sender: Any) {
    }
}

extension UpNextTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpNextTableViewCell.identifier, for: indexPath) as! UpNextTableViewCell
        guard let data = object as? DataUpNext else {return cell}
        cell.lblTitle.text = data.title
        cell.lblTime.text = data.time
        cell.lblDate.text = data.date
        cell.lblLocation.text = data.location
        cell.lblAddress.text = data.address
        cell.lblName.text = data.user
        cell.lblDivision.text = data.assignment
        
        guard let url = URL(string: data.photo) else { return cell }
        cell.imgProfile.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
            cell.imgProfile.layer.masksToBounds = true
        })

        
        cell.viewGoing.layer.cornerRadius = cell.viewGoing.frame.size.height*0.5
        cell.viewBorder.dropShadow()
        return cell
    }
}
