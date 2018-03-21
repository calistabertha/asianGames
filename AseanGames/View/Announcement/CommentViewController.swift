//
//  CommentViewController.swift
//  AseanGames
//
//  Created by Calista on 2/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import ASJExpandableTextView

class CommentViewController: UIViewController {
    @IBOutlet weak var txtComment: ASJExpandableTextView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var table: UITableView!{
        didSet{
            let xib = CommentTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: CommentTableViewCell.identifier)
            
            table.delegate = self
            table.dataSource = self
        }
    }
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnWriteComment: UIButton!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewHideKeyboard: UIView!
    
    var idAnnouncement : String?
    internal var commentItems = [CommentModel](){
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.isHidden = false
        viewEmpty.isHidden = true
        viewHideKeyboard.isHidden = true
        btnSend.isUserInteractionEnabled = false
        btnWriteComment.isHidden = false
        txtComment.placeholder = "Type something here"
        viewComment.layer.borderColor = UIColor.lightGray.cgColor
        viewComment.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDissappear(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
         let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapGesture))
        viewHideKeyboard.addGestureRecognizer(tap)
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 137
        
        setupData()
    }
    
    // MARK: - Keyboard Action
    func keyboardWillAppear(notif:NSNotification){
        let userInfo = notif.userInfo!
        if let animationCurveInt = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveInt<<16)
            var rect = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue
            let rect2 = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
            rect = rect2
            print("keyboard appear \(String(describing: rect)) \(String(describing: rect2))")
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
            viewComment.layoutIfNeeded()
            UIView.animate(withDuration: duration!, delay: 0, options: animationCurve, animations: {
                self.constraintBottom.constant = (rect?.size.height)!
                self.viewHideKeyboard.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                
            })
        }
    }
    
    func keyboardDidDissappear(notif:NSNotification){
        let userInfo = notif.userInfo!
        if let animationCurveInt = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveInt<<16)
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
            self.viewComment.clipsToBounds = false
            UIView.animate(withDuration: duration!, delay: 0, options: animationCurve, animations: {
                self.constraintBottom.constant = 0
                self.viewHideKeyboard.isHidden = true
              //  self.viewBG.isHidden = true
                self.view.layoutIfNeeded()
                
            }, completion: { (status) in
                
            })
        }
    }
    
    //MARK : Function
    func tableViewTapGesture(){
        self.txtComment.endEditing(true)
        viewHideKeyboard.isHidden = true
    }
    
    func setupData(){
        guard let id = idAnnouncement else {return}
        AnnouncementController().getComment(id: id, onSuccess: { (code, message, result) in
            if code == 200 {
                guard let res = result else {return}
                self.commentItems = res
                
            }
        }, onFailed: { (message) in
            print(message)
            print("Do action when data failed to fetching here")
        }) { (message) in
            print(message)
            print("Do action when data complete fetching here")
        }
    }
    
    //MARK : Action
    @IBAction func writeComment(_ sender: Any) {
        btnWriteComment.isHidden = true
        txtComment.text = ""
        txtComment.becomeFirstResponder()
        txtComment.maximumLineCount = 4
        btnSend.isUserInteractionEnabled = true
       
    }
    
    @IBAction func sendComment(_ sender: Any) {
        guard let id = idAnnouncement else {return}
        AnnouncementController().requestComment(id: id, comment: txtComment.text, onSuccess: { (code, message, result) in
            if code == 200 {
                let alert = JDropDownAlert()
                alert.alertWith("Success", message: result, topLabelColor:
                    UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                self.txtComment.text = ""
                self.table.reloadData()
                self.setupData()
                self.view.endEditing(true)
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

extension CommentViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = commentItems[indexPath.row]
        return CommentTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        
    }
    
}

extension CommentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
