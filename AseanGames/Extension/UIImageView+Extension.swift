//
//  UIImageView+Extension.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/19/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImageAPI(url: URL, completion: (() -> Void)? = nil) {
        self.contentMode = .scaleAspectFit
        self.af_setImage(withURL: url, filter: nil, progress: nil, imageTransition:.crossDissolve(0.2), runImageTransitionIfCached: false) { (result) in
            guard result.value != nil else { return }
            self.contentMode = .scaleAspectFill
            
            guard completion != nil else { return }
            completion!()
        }
    }
}
