//
//  BaseCellProtocol.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/7/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit

protocol BaseCellProtocol {
    
}

extension BaseCellProtocol {
    static var identifier: String {
        return String(describing: self).lowercased()
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

protocol CollectionViewCellProtocol: BaseCellProtocol {
    static func configure<T>(context: UIViewController, collectionView: UICollectionView, indexPath: IndexPath, object: T) -> UICollectionViewCell
}

protocol TableViewCellProtocol: BaseCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell
}

