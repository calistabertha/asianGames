//
//  SubClassScrollView.swift
//  TesterScroll
//
//  Created by Calista on 7/7/17.
//  Copyright © 2017 Calista. All rights reserved.
//

import UIKit

class SubClassScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var test: Bool = true
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return test
    }
    
    func isSimultaneously(_ status: Bool) {
        test = status
    }
}
