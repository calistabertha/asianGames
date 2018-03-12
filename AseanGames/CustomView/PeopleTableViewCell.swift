//
//  PeopleTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    internal var context: UIViewController?
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            let xib = GroupCollectionViewCell.nib
            collectionView.register(xib, forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
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

extension PeopleTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        
        cell.context = context
        
        return cell
    }
}

extension PeopleTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detail) as! DetailGroupViewController
        if let ctx = self.context {
            ctx.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PeopleTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = ""
        
        if let ctx = self.context {
            return GroupCollectionViewCell.configure(context: ctx, collectionView: collectionView, indexPath: indexPath, object: data)
        } else {
            return UICollectionViewCell()
        }
        
    }
}

extension PeopleTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: 182)
    }
}
