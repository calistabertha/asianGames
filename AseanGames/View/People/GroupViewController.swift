//
//  GroupViewController.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            let xib = GroupCollectionViewCell.nib
            collectionView.register(xib, forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createGroup(_ sender: Any) {
    }
}

extension GroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.detail) as! DetailAnnouncemenViewController
        //        if let ctx = self.context {
        //            ctx.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
}

extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = ""
        
        return GroupCollectionViewCell.configure(context: self, collectionView: collectionView, indexPath: indexPath, object: data)
        
    }
}

extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height: 182)
    }
}
