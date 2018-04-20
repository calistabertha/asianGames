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
            
            let xib2 = ListAttachementTableViewCell.nib
            table.register(xib2, forCellReuseIdentifier: ListAttachementTableViewCell.identifier)
            
            table.dataSource = self
            table.delegate = self
        }
    }
    
    @IBOutlet weak var viewHideKeyboard: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var txtDesc: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var timePicker: UIDatePicker!
    fileprivate var fileDataSource = [URL]() {
        didSet {
            self.table.reloadData()
        }
    }
    var url : URL?
    var grouped : [String]?
    var groupName : [String]?
    var date : String?
    var size = 0
    var totSize : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtDesc.delegate = self
        self.viewPicker.isHidden = true
        
        self.txtDate.delegate = self
        self.txtDate.inputView = self.datePicker
        self.datePicker.isHidden = true
        self.txtDate.clearButtonMode = UITextFieldViewMode.never
        
        self.txtTime.delegate = self
        self.txtTime.inputView = self.datePicker
        self.timePicker.isHidden = true
        self.txtTime.clearButtonMode = UITextFieldViewMode.never
        
        self.timePicker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: UIControlEvents.valueChanged)
        
         self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: UIControlEvents.valueChanged)
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.viewHideKeyboard.addGestureRecognizer(tap)
        self.viewHideKeyboard.isHidden = true
       // self.txtDesc.textContainer.maximumNumberOfLines = 4
        self.spinner.isHidden = true
       
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
        self.fileDataSource.append(url)
        self.url = url
      
        print("picked \(url)")
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
        urls.forEach {
            self.fileDataSource.append($0)
            
            let index = fileDataSource.count-1
            let filePath = fileDataSource[index].path
            var fileSize : UInt64
            
            do {
                //return [FileAttributeKey : Any]
                let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                fileSize = attr[FileAttributeKey.size] as! UInt64
                
                //if you convert to NSDictionary, you can get file size old way as well.
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
                let size = Double(fileSize)/1048576
                let siz = ceil(size)
                let si = Int(siz)
                
                self.size = self.size + si
                print("size \(self.size)")
            } catch {
                print("Error: \(error)")
            }
            
        }

        
        print("pickeds \(urls)")
    }
    
    //MARK: -Picker Changed
    func datePickerChanged(sender: UIDatePicker) {
        self.datePicker.isHidden = false
        self.timePicker.isHidden = true
        self.datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        self.txtDate.text = dateFormatter.string(from: sender.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "YYYY-MM-dd"
        self.date = dateFormatter2.string(from: sender.date)
    }
    
    func timePickerChanged(sender: UIDatePicker) {
        self.timePicker.isHidden = false
        self.datePicker.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.txtTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    //MARK: Function
    func hideKeyboard() {
        self.viewHideKeyboard.isHidden = true
        print("tap")
        self.viewPicker.isHidden = true
        self.view.endEditing(true)
    }
    
    

    //MARK: -Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openGroup(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Announcement.selectGroup) as! SelectGroupViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeDate(_ sender: Any) {
        self.viewHideKeyboard.isHidden = false
        self.viewPicker.isHidden = false
        self.datePicker.isHidden = false
        self.timePicker.isHidden = true
        self.datePicker.minimumDate = NSDate.init(timeIntervalSinceNow: TimeInterval(0)) as Date
        
    }
    
    @IBAction func changeTime(_ sender: Any) {
        self.viewHideKeyboard.isHidden = false
        self.viewPicker.isHidden = false
        self.timePicker.isHidden = false
        self.datePicker.isHidden = true
        self.timePicker.datePickerMode = .time
    }
    
    @IBAction func createAnnouncement(_ sender: Any) {
        if self.size >= 25 {
            let alert = JDropDownAlert()
            alert.alertWith("Sorry", message: "Maximum file size is 25 MB", topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
        }else {
            guard let group = grouped else {return}
            AnnouncementController().requestAnnouncement(title: txtTitle.text!, description: txtDesc.text,files:fileDataSource, group:group, date: self.date!, time: txtTime.text!, onSuccess: { (code,respon, error) in
                print("codeee \(code)")
                print("responseee \(respon)")
                if code == 200 {
                    let alert = JDropDownAlert()
                    alert.alertWith("Success", message: respon, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }, onFailed: { (message) in
                print(message)
                print("Do action when data failed to fetching here")
            }) { (message) in
                print(message)
                print("Do action when data complete fetching here")
            }
        }
    }
    
}

extension CreateAnnouncementViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == fileDataSource.count{
            return AddAttachmentTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: url)
            
        }else{
            let data = fileDataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ListAttachementTableViewCell.identifier, for: indexPath) as! ListAttachementTableViewCell
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
            
            //return ListAttachementTableViewCell.configure(context: self, tableView: tableView, indexPath: indexPath, object: data)
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == fileDataSource.count{
            self.addAttachment()
        
        }else {
            let alert = UIAlertController(title: nil, message: "Are you sure to delete this attachment?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                self.fileDataSource.remove(at: indexPath.row)
                self.table.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil )
        }
        
    }
    
}

extension CreateAnnouncementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == fileDataSource.count{
            return 87
        }
        return 55
        
    }
}

extension CreateAnnouncementViewController: GroupSelected{
    func group(id: [String], name: [String]) {
        self.grouped = id
        self.groupName = name
        self.lblGroup.text = self.groupName?.joined(separator: ",")
     
    }
        
}

extension CreateAnnouncementViewController: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
//        let newLines = text.components(separatedBy: CharacterSet.newlines)
//        let linesAfterChange = existingLines.count + newLines.count - 1
//        
//        return linesAfterChange < textView.textContainer.maximumNumberOfLines
//        
//    }
    
    func textViewDidChange(_ textView: UITextView) {
      
        print(textView.text)
    }
}


