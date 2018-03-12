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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension FriendsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        return FriendsTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.People.friends) as! FriendsViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return 64
        
    }
}
