//
//  ListCollectionViewCell.swift
//  AseanGames
//
//  Created by Calista on 1/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import AlamofireImage

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAttachment: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension ListCollectionViewCell: CollectionViewCellProtocol{
    static func configure<T>(context: UIViewController, collectionView: UICollectionView, indexPath: IndexPath, object: T) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as! ListCollectionViewCell
        guard let data = object as? DataPinned else {return cell}
        cell.lblTitle.text = data.title
        cell.lblDesc.text = data.description
        cell.lblName.text = data.user
        cell.lblDivision.text = data.assignment
        cell.lblDate.text = data.createAt
        if data.attachment == 0 {
            cell.lblAttachment.text = "Attachment : 0 File"
        } else if data.attachment == 1 {
            cell.lblAttachment.text = "Attachment : 1 File"
        }else {
            cell.lblAttachment.text = "Attachment : \(data.attachment) Files"
        }
        
       // cell.viewCollection.dropShadow()
        
        guard let url = URL(string: data.photo) else { return cell }

            cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
                cell.imgProfile.layer.masksToBounds = true
            })
        
       
        
        return cell
    }
}
