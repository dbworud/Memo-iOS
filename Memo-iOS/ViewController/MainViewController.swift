//
//  MainViewController.swift
//  Memo-iOS
//
//  Created by jaekyung you on 2021/03/10.
//

import UIKit


class MainViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        df.locale = Locale(identifier: "KO_kr")
        return df
        
    }()
    
    // 옵저버 해제할 때 쓰는 속성 token
    var token: NSObjectProtocol?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] noti in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sender활용해서 몇 번째 셀이 선택됐는지 알아야 함
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as?  DetailViewController {
                vc.memo = Memo.dummyMemoList[indexPath.row]
            }
        }
    }
    
    // 옵저버를 계속 관찰하고 있으면 메모리가 낭비되기 때문에 view가 사라지기 전 혹은 해제될 때 옵저버 관찰을 해제한다
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    // MARK: Method
    func configureUI() {
        tableView.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.9184874892, green: 0.9130274653, blue: 0.9226844907, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "AccentColor")
        
    }

}



// MARK: - Extension
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

