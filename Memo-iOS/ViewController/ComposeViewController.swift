//
//  ComposeViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(title: "알림", message: "메모를 입력하세요.")
            return
        }
        
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)

        navigationController?.popViewController(animated: true)
    }
    
     
    @IBAction func addLineOrGrid(_ sender: Any) {
        actionSheet()
    }
    
}


extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    
}
