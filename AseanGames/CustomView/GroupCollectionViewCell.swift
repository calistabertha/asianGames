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
        cell.viewBorder.dropShadow()
        return cell
    }
}
