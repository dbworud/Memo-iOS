//
//  UIViewController+Alert.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
