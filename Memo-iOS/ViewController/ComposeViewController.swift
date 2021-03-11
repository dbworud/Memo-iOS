//
//  ComposeViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var editTarget: Memo? // DetailVC에서 전달받은 Memo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(title: "알림", message: "메모를 입력하세요.")
            return
        }
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget {
            target.content  = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidUpdate, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }

        navigationController?.popViewController(animated: true)
    }
    
     
    @IBAction func addLineOrGrid(_ sender: Any) {
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let addLineOrGrid = UIAlertAction(title: "줄 및 격자", style: .default) { _ in
//
//            self.navigationController?.pushViewController(SelectThemeViewController(), animated: true)
//        }
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//
//        alert.addAction(addLineOrGrid)
//        alert.addAction(cancel)
//        alert.view.tintColor = UIColor(named: "AccentColor")
//
//        present(alert, animated: false, completion: nil)
    }
    
    @objc func back() {
        // Perform your custom actions
                // ...
                // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
}


extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    static let memoDidUpdate = Notification.Name("memoDidUpdate")
    
}
