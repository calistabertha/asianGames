//
//  SupportViewController.swift
//  AseanGames
//
//  Created by Calista on 3/1/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {
    @IBOutlet weak var lblSupport: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let support = "support@asiangames2018.id"
        let value = "Have any question? Please do check our FAQ section first. If you have urgent questions, send us an email at \(support)"
        lblSupport.textColor = UIColor(hexString: "262626")
//        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: value)
//        attributedString.setColorForText(textToFind: support, withColor: UIColor(hexString: "007e79"))
//        lblSupport.attributedText = attributedString
        self.view.addSubview(lblSupport)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
