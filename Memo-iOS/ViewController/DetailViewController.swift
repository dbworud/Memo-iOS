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
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dateFormatter.string(for: memo?.insertDate)
        contentTextView.text = memo?.content
        
    }
    

}
