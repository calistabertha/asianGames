//
//  GroupCollectionViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblTotalMember: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension GroupCollectionViewCell: CollectionViewCellProtocol{
    static func configure<T>(context: UIViewController, collectionView: UICollectionView, indexPath: IndexPath, object: T) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier, for: indexPath) as! GroupCollectionViewCell
        guard let data = object as? GroupModel else {return cell}
        cell.lblGroupName.text = data.name
        if data.member < 2 {
            cell.lblTotalMember.text = "\(data.member) Member"
        }else {
            cell.lblTotalMember.text = "\(data.member) Members"
        }
        
        var url : URL
        if data.image == "" {
            url = URL(string: data.photo)!
        }else {
            url = URL(string: data.image)!
        }
  
        cell.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height*0.5
            cell.imgProfile.layer.masksToBounds = true
        })
        cell.viewBorder.dropShadow()
        return cell
    }
}
