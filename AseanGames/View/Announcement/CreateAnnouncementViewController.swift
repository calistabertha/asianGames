//
//  CreateAnnouncementViewController.swift
//  AseanGames
//
//  Created by Calista on 2/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import MobileCoreServices
import TPKeyboardAvoiding

class CreateAnnouncementViewController: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var table: TPKeyboardAvoidingTableView!{
        didSet{
            let xib = AddAttachmentTableViewCell.nib
            table.register(xib, forCellReuseIdentifier: AddAttachmentTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtDate.delegate = self
        self.txtDate.inputView = self.datePicker
        self.datePicker.isHidden = true
        self.txtDate.clearButtonMode = UITextFieldViewMode.never
        
        self.txtTime.delegate = self
        self.txtTime.inputView = self.datePicker
        self.datePicker.removeFromSuperview()
        self.txtTime.clearButtonMode = UITextFieldViewMode.never
        
    }

    //MARK: -Attachment
    func addAttachment(){
        let picker = UIDocumentMenuViewController(documentTypes: [(kUTTypePDF) ,(kUTTypeJPEG), (kUTTypeVideo), (kUTTypeMovie),(kUTTypePNG) ,(kUTTypeSpreadsheet) ,(kUTTypeText) ,(kUTTypeContent)] as [String], in: .import )
        picker.modalPresentationStyle = .formSheet
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

    
        print("picked \(url)")
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
        print("pickeds \(urls)")
    }
    
    //MARK: -Function
    func datePickerChanged(sender: UIDatePicker) {
        self.datePicker.isHidden = false
        self.datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/YYYY"
        self.txtDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    func timePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        self.txtTime.text = dateFormatter.string(from: sender.date)
        
    }
    

    //MARK: -Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openGroup(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.parent) as! ParentSelectGroupViewController
        vc.idTitle = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeDate(_ sender: Any) {
        self.datePicker.isHidden = false
        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: UIControlEvents.valueChanged)
        self.datePicker.maximumDate = NSDate.init(timeIntervalSinceNow: TimeInterval(0)) as Date
        
    }
    
    @IBAction func changeTime(_ sender: Any) {
        self.datePicker.isHidden = false
        self.datePicker.datePickerMode = .time
        self.datePicker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: UIControlEvents.valueChanged)
       
    }
    
    @IBAction func createAnnouncement(_ sender: Any) {
        //        AnnouncementController().requestAnnouncement(title: "", description: "",files:[url], group: [], date: "", time: "", onSuccess: { (code,respon, error) in
        //
        //        }, onFailed: { (respon) in
        //
        //        }) { (respon) in
        //
        //        }
    }
    
}

extension CreateAnnouncementViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        return AddAttachmentTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addAttachment()
    }
    
}

extension CreateAnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
        
    }
}
