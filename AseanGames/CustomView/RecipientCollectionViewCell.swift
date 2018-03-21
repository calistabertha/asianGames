//
//  RecipientCollectionViewCell.swift
//  AseanGames
//
//  Created by Calista on 3/15/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class RecipientCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgRecipient: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension RecipientCollectionViewCell: CollectionViewCellProtocol{
    static func configure<T>(context: UIViewController, collectionView: UICollectionView, indexPath: IndexPath, object: T) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipientCollectionViewCell.identifier, for: indexPath) as! RecipientCollectionViewCell
        guard let data = object as? DataImage else {return cell}
        guard let url = URL(string: data.image) else { return cell }
        cell.imgRecipient.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img-placeholder"), options: .progressiveDownload, completed: { (img, error, type, url) in
            cell.imgRecipient.layer.cornerRadius = cell.imgRecipient.frame.size.height*0.5
            cell.imgRecipient.layer.masksToBounds = true
        })
            
        return cell
    }
}
