//
//  ListAttachementTableViewCell.swift
//  AseanGames
//
//  Created by Calista on 4/9/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class ListAttachementTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListAttachementTableViewCell: TableViewCellProtocol {
    static func configure<T>(context: UIViewController, tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListAttachementTableViewCell.identifier, for: indexPath) as! ListAttachementTableViewCell
        guard  let data = object as? URL else {return cell}
        cell.lblFileName.text = "\(data.lastPathComponent)"
        
        let filePath = data.path
        var fileSize : UInt64
        
        do {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            let size = Double(fileSize)/1048576
            let sizee = String(format: "%.1f", ceil(size))
            cell.lblSize.text = "\(sizee) MB"
        } catch {
            print("Error: \(error)")
        }
        
        return cell
    }
}
