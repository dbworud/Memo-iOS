//
//  Memo.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import Foundation

class Memo {
    
    var content: String
    var insertDate: Date
    
    init(content: String) {
        self.content = content
        insertDate = Date()
    }
    
    static var dummyMemoList = [
        Memo(content: "3월 일정"),
        Memo(content: "4월 일정")
    ]
}
