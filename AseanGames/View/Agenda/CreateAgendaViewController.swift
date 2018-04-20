//
//  CreateAgendaViewController.swift
//  AseanGames
//
//  Created by Calista on 2/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class CreateAgendaViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTimeStart: UITextField!
    @IBOutlet weak var txtTimeEnd: UITextField!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var timeStartPicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var lblGuest: UILabel!
    @IBOutlet weak var viewHideKeyboard: UIView!
    @IBOutlet weak var timeEndPicker: UIDatePicker!
    var location = ""
    var grouped : [String]?
    var guest : [String]?
    var date = ""
    var timeStart = ""
    var timeEnd = ""
    var guestName : [String]?
    var groupName : [String]?
    var allName : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPicker.isHidden = true
        self.viewHideKeyboard.isHidden = true
        self.txtDescription.delegate = self
     
        self.txtDate.delegate = self
        self.txtDate.inputView = self.datePicker
        self.datePicker.isHidden = true
        self.txtDate.clearButtonMode = UITextFieldViewMode.never
    
        self.txtTimeStart.delegate = self
        self.txtTimeStart.inputView = self.timeStartPicker
        self.timeStartPicker.isHidden = true
        self.txtTimeStart.clearButtonMode = UITextFieldViewMode.never
        
        self.txtTimeEnd.delegate = self
        self.txtTimeEnd.inputView = self.timeEndPicker
        self.timeEndPicker.isHidden = true
        self.txtTimeEnd.clearButtonMode = UITextFieldViewMode.never
        
        self.timeStartPicker.addTarget(self, action: #selector(timeStartPickerChanged(sender:)), for: UIControlEvents.valueChanged)
        self.timeEndPicker.addTarget(self, action: #selector(timeEndPickerChanged(sender:)), for: UIControlEvents.valueChanged)
        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: UIControlEvents.valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.viewHideKeyboard.addGestureRecognizer(tap)
        
      //  self.txtDescription.textContainer.maximumNumberOfLines = 4
    
    }
    
    //MARK: Function
    func hideKeyboard() {
        self.viewHideKeyboard.isHidden = true
        print("tap")
        self.viewPicker.isHidden = true
        self.view.endEditing(true)
    }
    
    //MARK: -Picker Changed
    func datePickerChanged(sender: UIDatePicker) {
        self.datePicker.isHidden = false
        self.timeStartPicker.isHidden = true
        self.timeEndPicker.isHidden = true
        self.datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        self.txtDate.text = dateFormatter.string(from: sender.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "YYYY-MM-dd"
        self.date = dateFormatter2.string(from: sender.date)
  
    }
    
    func timeStartPickerChanged(sender: UIDatePicker) {
        self.timeStartPicker.isHidden = false
        self.datePicker.isHidden = true
        self.timeEndPicker.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.txtTimeStart.text = dateFormatter.string(from: sender.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm:ss"
        self.timeStart = dateFormatter2.string(from: sender.date)

    }
    
    func timeEndPickerChanged(sender: UIDatePicker) {
        self.timeEndPicker.isHidden = false
        self.timeStartPicker.isHidden = true
        self.datePicker.isHidden = true
       
//        let date = timeStartPicker.date
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let hour = components.hour!
//        let minute = components.minute!
//        print("start time \(hour) , \(minute)")
//
//        let date1 = timeEndPicker.date
//        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
//        var components1 = gregorian.dateComponents([.day, .month, .year], from:date1 )
//        components1.hour = hour
//        components1.minute = minute
//        let startDate = gregorian.date(from: components as DateComponents)!
//
//        timeEndPicker.minimumDate = startDate
//        timeEndPicker.setDate(startDate as Date, animated: true)
//        timeEndPicker.reloadInputViews()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.txtTimeEnd.text = dateFormatter.string(from: sender.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm:ss"
        self.timeEnd = dateFormatter2.string(from: sender.date)
    }

    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func selectGuest(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardReferences.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Agenda.parent) as! ParentSelectGroupViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        viewHideKeyboard.isHidden = false
        viewPicker.isHidden = false
        datePicker.isHidden = false
        timeStartPicker.isHidden = true
        timeEndPicker.isHidden = true
        self.datePicker.minimumDate = NSDate.init(timeIntervalSinceNow: TimeInterval(0)) as Date
    }
    
    @IBAction func timeStartChanged(_ sender: Any) {
        viewHideKeyboard.isHidden = false
        viewPicker.isHidden = false
        datePicker.isHidden = true
        timeStartPicker.isHidden = false
        timeEndPicker.isHidden = true
        
    }
    
    @IBAction func timeEndChanged(_ sender: Any) {
        viewHideKeyboard.isHidden = false
        viewPicker.isHidden = false
        datePicker.isHidden = true
        timeEndPicker.isHidden = false
        timeStartPicker.isHidden = true
    }
    
    @IBAction func createAgenda(_ sender: Any) {
        let start = Int(self.txtTimeStart.text!.replacingOccurrences(of: ":", with: ""))
        let end = Int(self.txtTimeEnd.text!.replacingOccurrences(of: ":", with: ""))
        guard let s = start else {return}
        guard let e = end else {return}
        if e < s {
            let alert = JDropDownAlert()
            alert.alertWith("Failed", message: "Please change your end time", topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
            return
        }
        
        AgendaController().requestAgenda(title: txtTitle.text!, description: txtDescription.text, location: location, guest: self.guest, group: self.grouped, date: self.date, timeStart: timeStart, timeEnd: timeEnd,onSuccess: { (code, message, result) in
            guard let res = result else {return}
            if code == 200 {
                let alert = JDropDownAlert()
                alert.alertWith("Success", message: res, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "1ABBA4"), image: nil)
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

extension CreateAgendaViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.txtLocation.text = place.name
        self.location = "\(place.name)#\(place.formattedAddress!.replacingOccurrences(of: "\(place.name)", with: ""))"
        print("desc \(place.description)")
        print("location \(location)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension CreateAgendaViewController: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
//        let newLines = text.components(separatedBy: CharacterSet.newlines)
//        let linesAfterChange = existingLines.count + newLines.count - 1
//        
//        return linesAfterChange <= textView.textContainer.maximumNumberOfLines
//    }
}

extension CreateAgendaViewController: ParentSelected{
    func guest(id: [String], name: [String]) {
        self.guest = id
        self.guestName = name
        self.lblGuest.text = self.guestName?.joined(separator: ",")
       
    }
    
    func group(id: [String], name: [String]) {
        self.grouped = id
        self.groupName = name
        self.lblGuest.text = self.groupName?.joined(separator: ",")
    }
}


