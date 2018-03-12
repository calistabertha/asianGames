//
//  AnnouncementTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 1/22/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    internal var context: UIViewController?
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            let xib = ListCollectionViewCell.nib
            collectionView.register(xib, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self

        }
    }
    
    internal var pinnedData = [DataAnnouncement]() {
        didSet {
            self.collectionView.reloadData()
        }
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

extension AnnouncementTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as! AnnouncementTableViewCell
        cell.context = context
//        guard let data = object as? DataAnnouncement else { return cell }
//        
//        cell.pinnedData.append(data)
        return cell
    }
}

extension AnnouncementTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        let data = pinnedData[indexPath.row]
        vc.idAnnouncement = data.id
        if let ctx = self.context {
            ctx.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AnnouncementTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinnedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = pinnedData[indexPath.row]
        
        if let ctx = self.context {
            return ListCollectionViewCell.configure(context: ctx, collectionView: collectionView, indexPath: indexPath, object: data)
        } else {
            return UICollectionViewCell()
        }
        
    }
}

extension AnnouncementTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-90, height: collectionView.frame.size.height)
    }
}
