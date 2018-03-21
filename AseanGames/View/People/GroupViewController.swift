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
    
    internal var groupItems = [GroupModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }

    //MARK : Function
    func setupData() {
        PeopleController().getPeople(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.groupItems = res.group
//                self.spinner.stopAnimating()
//                self.spinner.isHidden = true
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 
}

extension GroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detail) as! DetailGroupViewController
        let data = groupItems[indexPath.row]
        vc.idGroup = String(data.id)
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    
}

extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = groupItems[indexPath.row]
        
        return GroupCollectionViewCell.configure(context: self, collectionView: collectionView, indexPath: indexPath, object: data)
        
    }
}

extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width/2 , height: 182)
    }//collectionView.frame.size.width/2
}
