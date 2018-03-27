//
//  CreateAnnouncementViewController.swift
//  AseanGames
//
//  Created by Calista on 2/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateAnnouncementViewController: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addAttachment()
    }
    
    func addAttachment(){
        let picker = UIDocumentMenuViewController(documentTypes: [(kUTTypePDF) ,(kUTTypeJPEG) ,(kUTTypePNG) ,(kUTTypeSpreadsheet) ,(kUTTypeText) ,(kUTTypeContent)] as [String], in: .import )
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

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
