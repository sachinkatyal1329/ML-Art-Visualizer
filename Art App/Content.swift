//
//  Content.swift
//  Art App
//
//  Created by Sachin Katyal on 7/2/19.
//  Copyright © 2019 Sachin Katyal. All rights reserved.
//

import Foundation
import UIKit

class Content: UIView{
    
    var outline: CGRect!
    
    
    var panGesture = UIPanGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height))
        
        self.outline = frame
        
        initUI()
    }
    
    func initUI() {
        
        self.layer.zPosition = 4
        self.layer.position = CGPoint(x: 0, y: UIScreen.main.bounds.height + outline.height / 2)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        
        
        let mainContent = UIView(frame: self.outline)
        mainContent.backgroundColor = .white
        mainContent.layer.cornerRadius = 10
        self.addSubview(mainContent)
        
        let aboutArt = UIView(frame: self.outline)
        aboutArt.backgroundColor = .red
        aboutArt.layer.zPosition = 6
        aboutArt.layer.cornerRadius = 10
        aboutArt.layer.position = CGPoint(x: self.outline.width * 1.5, y: self.outline.height / 2)
        self.addSubview(aboutArt)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)

    }
    
    func showView() {
        var transform = self.transform
         transform = transform.translatedBy(x: 0.0, y: -1 * UIScreen.main.bounds.height * 0.8)

        UIView.animate(withDuration: 0.3, animations: {
            self.transform = transform
        })
    }
    
    func hideView() {
        var transform = self.transform
        transform = transform.translatedBy(x: 0, y: UIScreen.main.bounds.height * 0.8)
        
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = transform
        })
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y)
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


