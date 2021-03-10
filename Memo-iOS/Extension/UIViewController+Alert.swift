//
//  UIViewController+Alert.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

extension UIViewController {
    
    // Alert
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // Action Sheet
    func actionSheet() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let addLineOrGrid = UIAlertAction(title: "줄 및 격자", style: .default) { _ in
           
            self.present(SelectThemeViewController(), animated: false, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(addLineOrGrid)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor(named: "AccentColor")
//        alert.pruneNegativeWidthConstraints()

        present(alert, animated: false, completion: nil)

        // Apple bug issue
        //https://stackoverflow.com/questions/60647478/presenting-uialertcontroller-in-actionsheet-style-caused-mysterious-autolayout
    }
    */
    
}

/*
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
*/
