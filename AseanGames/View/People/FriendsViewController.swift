//
//  FriendsViewController.swift
//  AseanGames
//
//  Created by Calista on 2/26/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = FriendsTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: FriendsTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    internal var friendsItems = [RecipientModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }
    
    //MARK : Function
    func setupData() {
        PeopleController().getFriends(onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                self.friendsItems = res
                self.table.isHidden = false
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
    
    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension FriendsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let data = friendsItems[indexPath.row]
        return FriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = friendsItems[indexPath.row]
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.detailFriends) as! DetailFriendsViewController
        vc.idUser = data.id
        print("user select \(data.id)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return 64
        
    }
}
