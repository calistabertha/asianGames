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
    @IBOutlet weak var lblMoreRSVP: UILabel!
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet var imageCollection: [UIImageView]!
    @IBOutlet weak var imgStripe: UIImageView!
    
    var attend: ((UITableViewCell) -> Void)?
    var decline: ((UITableViewCell) -> Void)?
    var select: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func attendSelected(_ sender: Any) {
        attend?(self)
    }
    
    @IBAction func declineSelected(_ sender: Any) {
         decline?(self)
    }
    
    @IBAction func cellSelected(_ sender: Any) {
        select?(self)
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
        
        if data.attendants.count > 0 {
            for var i in 0...data.attendants.count-1{
                let image = cell.imageCollection[i]
                image.isHidden = false
                
                guard let url = URL(string: data.attendants[i]) else { return cell}
                image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                    image.layer.cornerRadius = image.frame.size.height*0.5
                    image.layer.masksToBounds = true
                })
            }
        }
        
        if data.response <= 1 {
            cell.viewButton.isHidden = true
        }
        
        if data.attendants.count < 5 {
            cell.viewGoing.isHidden = true
            cell.lblGoing.isHidden = true
            cell.lblMoreRSVP.text = String(data.more)
            
        }else {
            cell.viewGoing.isHidden = false
            cell.lblGoing.isHidden = false
        }
        
        if let url = URL(string: data.photo) {
            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
                cell.imgProfile.layer.masksToBounds = true
            })
        }

        cell.viewGoing.layer.cornerRadius = cell.viewGoing.frame.size.height*0.5
      //  cell.viewBorder.dropShadow()
        
        cell.attend = {
            (cells) in
            AgendaController().requestRespond(id: String(data.id), respond: "1", onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if res == 200 {
                    let alert = JDropDownAlert()
                    alert.alertWith("Attend", message: "You can change response by clicking button below.", topLabelColor:
                        UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                    cell.imgStripe.isHidden = false
                    cell.viewButton.isHidden = true
                    
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
        
        cell.decline = {
            (cells) in
            AgendaController().requestRespond(id: String(data.id), respond: "0", onSuccess: { (code, message, result) in
                guard let res = result else {return}
                if res == 200 {
                    let alert = JDropDownAlert()
                    alert.alertWith("Decline", message: "You can change response by clicking button below.", topLabelColor:
                        UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "F52D5A"), image: nil)
                    cell.imgStripe.isHidden = false
                    cell.viewButton.isHidden = true
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
        
        cell.select = {
            (cells) in
            let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.detail) as! DetailAgendaViewController
            vc.idAgenda = String(data.id)
            context.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
}
