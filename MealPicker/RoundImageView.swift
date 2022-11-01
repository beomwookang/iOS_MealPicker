//
//  RoundImageView.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/02.
//

import UIKit

class RoundImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureOutfit() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        
        self.layer.opacity = 0.4
    }
}
