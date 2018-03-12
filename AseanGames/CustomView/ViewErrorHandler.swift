//
//  ViewErrorHandler.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/22/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit

class ViewErrorHandler: UIView {
    
    fileprivate var holderView: UIView?

    public typealias VEHAction = (_ viewErrorHandler: ViewErrorHandler) -> Void
    
    open dynamic var actionBlock: VEHAction? = nil
    
    open var contentBackgroundColor = UIColor.gray {
        didSet {
            configure()
        }
    }
    
    open var contentBackgroundImage: UIImage? {
        didSet {
            configure()
        }
    }
    
    open var buttonCornerRadius: CGFloat = 0 {
        didSet {
            configure()
        }
    }
    
    open var buttonBackgroundColor = UIColor.red {
        didSet {
            configure()
        }
    }
    
    open var buttonHeight: CGFloat = 44 {
        didSet {
            configure()
        }
    }
    
    open var buttonTextLabel = "RETRY" {
        didSet {
            configure()
        }
    }
    
    open var buttonTextLabelColor = UIColor.white {
        didSet {
            configure()
        }
    }
    
    open var buttonTextFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            configure()
        }
    }
    
    open var messageTextLabel = "an error was occured" {
        didSet {
            configure()
        }
    }
    
    open var messageTextLabelColor = UIColor.white {
        didSet {
            configure()
        }
    }
    
    open var messageTextFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            configure()
        }
    }
    
    open var imageIcon = UIImage(imageLiteralResourceName: "ico-no-conection") {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, actionBlock: @escaping VEHAction) {
        super.init(frame: frame)
        
        self.actionBlock = actionBlock
        configure()
    }
    
    convenience init(frame: CGRect, holderView: UIView, actionBlock: @escaping VEHAction) {
        self.init(frame: frame)
        
        self.actionBlock = actionBlock
        self.holderView = holderView
        
        configure()
    }
}

extension ViewErrorHandler {
    func configure() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        let contentView = UIView()
        if let images = self.contentBackgroundImage {
            contentView.backgroundColor = UIColor(patternImage: images)
        } else {
            contentView.backgroundColor = self.contentBackgroundColor
        }
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewX = NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let contentViewY = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let contentViewHeight = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let contentViewWidth = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([contentViewX, contentViewY, contentViewHeight, contentViewWidth])
        
        let contentImage = UIImageView(image: self.imageIcon)
        contentView.addSubview(contentImage)
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        
        let contentImageRatio = NSLayoutConstraint(item: contentImage, attribute: .height, relatedBy: .equal, toItem: contentImage, attribute: .width, multiplier: contentImage.frame.height / contentImage.frame.width, constant: 0)
        let contentImageWidth = NSLayoutConstraint(item: contentImage, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.4, constant: 0)
        let contentImageTop = NSLayoutConstraint(item: contentImage, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 80)
        let contentImageX = NSLayoutConstraint(item: contentImage, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([contentImageRatio, contentImageWidth, contentImageTop, contentImageX])
        
        let contentLabel = UILabel()
        contentLabel.text = self.messageTextLabel
        contentLabel.textColor = self.messageTextLabelColor
        contentLabel.font = self.messageTextFont
        contentLabel.numberOfLines = 3
        contentLabel.textAlignment = NSTextAlignment.center
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabelTop = NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: contentImage, attribute: .bottom, multiplier: 1, constant: 25)
        let contentLabelWidth = NSLayoutConstraint(item: contentLabel, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.8, constant: 0)
        let contentLabelX = NSLayoutConstraint(item: contentLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([contentLabelTop, contentLabelWidth, contentLabelX])
        
        let actionButton = UIButton()
        actionButton.backgroundColor = self.buttonBackgroundColor
        actionButton.titleLabel?.font = self.buttonTextFont
        actionButton.setTitle(self.buttonTextLabel, for: UIControlState())
        actionButton.setTitleColor(self.buttonTextLabelColor, for: UIControlState())
        actionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
        actionButton.layer.cornerRadius = self.buttonCornerRadius
        actionButton.clipsToBounds = true
        
        contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let actionButtonTop = NSLayoutConstraint(item: actionButton, attribute: .top, relatedBy: .equal, toItem: contentLabel, attribute: .bottom, multiplier: 1, constant: 25)
        let actionButtonHeight = NSLayoutConstraint(item: actionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.buttonHeight)
        let actionButtonWidth = NSLayoutConstraint(item: actionButton, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.8, constant: 0)
        let actionButtonX = NSLayoutConstraint(item: actionButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([actionButtonTop, actionButtonHeight, actionButtonWidth, actionButtonX])
        
        if let holder = self.holderView {
            holder.addSubview(self)
        }
        
        self.hide()
    }
    
    func doAction(_ button: UIButton) {
        actionBlock?(self)
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}

