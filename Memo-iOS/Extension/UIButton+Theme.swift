//
//  UIButton+Theme.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit


extension UIButton {
    
   
    // selected -> layer.color = UIColor(named: "AccentColor")
    
    // corner Radius
    
}

class ThemeButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5.0
        self.backgroundColor = .lightGray
        self.backgroundColor = UIColor(red: 255/255, green: 132/255, blue: 102/255, alpha: 1)
        self.tintColor = UIColor(named: "AccentColor")

    }
    
}
