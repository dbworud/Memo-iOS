//
//  MainViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        df.locale = Locale(identifier: "KO_kr")
        return df
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.9184874892, green: 0.9130274653, blue: 0.9226844907, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.searchController = searchController
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memo.dummyMemoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        
        let memo = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = memo.content
        cell.detailTextLabel?.text = dateFormatter.string(from: memo.insertDate)
        
        return cell
    }
    
}

