//
//  DetailViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        df.locale = Locale(identifier: "KO_kr")
        return df
        
    }()
    
    var memo: Memo?
    
    // 키보드 노티피케이션
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dateFormatter.string(for: memo?.insertDate)
        contentTextView.text = memo?.content
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidUpdate, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.contentTextView.text = self?.memo?.content
        })
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
            // 키보드 높이만큼 여백 추가. 기기마다 다르기 때문에 noti로 높이 구하기
            guard let `self` = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height // 키보드 높이 저장
                var inset = self.contentTextView.contentInset
                
                inset.bottom = height
                self.contentTextView.contentInset = inset
                
                // 스크롤바에도 같은 크기의 여백 추가
                inset = self.contentTextView.scrollIndicatorInsets
                inset.bottom = height
                self.contentTextView.scrollIndicatorInsets = inset
            }
        })
        
        // 키보드 사라지면 여백 제거
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
            
            guard let `self` = self else { return }
            
            var inset = self.contentTextView.contentInset
            inset.bottom = 0
            self.contentTextView.contentInset = inset
            
            inset = self.contentTextView.scrollIndicatorInsets
            inset.bottom = 0
            self.contentTextView.scrollIndicatorInsets = inset
            
        })
    }
    
    deinit{
        
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    

    var token: NSObjectProtocol?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ComposeViewController {
            vc.editTarget = memo
        }
    }
}
