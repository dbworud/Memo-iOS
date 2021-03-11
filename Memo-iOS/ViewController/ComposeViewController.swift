//
//  ComposeViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var memoTextView: UITextView!
    
    var editTarget: Memo? // DetailVC에서 전달받은 Memo
    
    // 키보드 노티피케이션
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    // MARK: LifeCycle
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
        
        
        // 키보드 높이만큼 여백 추가
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
            // 기기마다 다르기 때문에 noti로 높이 구하기
            guard let `self` = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height // 키보드 높이 저장
                var inset = self.memoTextView.contentInset
                
                inset.bottom = height
                self.memoTextView.contentInset = inset
                
                // 스크롤바에도 같은 크기의 여백 추가
                inset = self.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                self.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        // 키보드 사라지면 여백 제거
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
            
            guard let `self` = self else { return }
            
            var inset = self.memoTextView.contentInset
            inset.bottom = 0
            self.memoTextView.contentInset = inset
            
            inset = self.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            self.memoTextView.scrollIndicatorInsets = inset
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memoTextView.becomeFirstResponder() // 입력포커스가 textView가 되어 keyboard 자동으로 올라옴
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.memoTextView.resignFirstResponder() // 입력포커스 제거 keyboard 제거
    }
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(title: "알림", message: "메모를 입력하세요.")
            return
        }
        
        let insertDate = Date()
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget {
            target.content  = memo
            target.insertDate = insertDate
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
        
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.save(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension ComposeViewController {
    
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    static let memoDidUpdate = Notification.Name("memoDidUpdate")
    
}
