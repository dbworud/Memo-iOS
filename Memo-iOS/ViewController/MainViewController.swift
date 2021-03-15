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
    var filteredMemo = [Memo]()
    var allMemo = DataManager.shared.memoList
    
    var isFiltering: Bool {
        return searchController.isActive && !self.isSearchBarEmpty()
    }
    
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
                                               queue: OperationQueue.main)
        { [weak self] noti in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // ViewController가 화면에 보여지기 직전에 호출, 네트워크 혹은 데이터 fetch해서 붙여넣기
        DataManager.shared.fetchMemo()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sender활용해서 몇 번째 셀이 선택됐는지 알아야 함
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as?  DetailViewController {

                if isFiltering {
                    vc.memo = filteredMemo[indexPath.row]
                } else {
                    vc.memo = DataManager.shared.memoList[indexPath.row]
                }
            }
        }
    }
    
    // 옵저버를 계속 관찰하고 있으면 메모리가 낭비되기 때문에 view가 사라지기 전 혹은 해제될 때 옵저버 관찰을 해제한다
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            view.backgroundColor = #colorLiteral(red: 0.9184874892, green: 0.9130274653, blue: 0.9226844907, alpha: 1)
        }
    }
    
    // MARK: Method
    func configureUI() {
        tableView.layer.cornerRadius = 10
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            view.backgroundColor = #colorLiteral(red: 0.9184874892, green: 0.9130274653, blue: 0.9226844907, alpha: 1)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "AccentColor")
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self // UISearchBar 내의 텍스트가 변경되는 것을 알림
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false // 다른 뷰 컨트롤러를 사용할 경우 true로 설정하여 유용
        definesPresentationContext = true // UISearchController가 활성화되어있는 동안, 사용자가 다른 뷰 컨트롤러로 이동하면 search bar가 화면에 남아있지 않도록
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentsForSearchText(_ searchText: String, scope: String? = "All") {
        filteredMemo = DataManager.shared.memoList.filter{ (memo: Memo) -> Bool in
            if let memoContent = memo.content {
                return memoContent.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        }
        tableView.reloadData()
    }
}


// MARK: - Extension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMemo.count
        } else {
            return DataManager.shared.memoList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        let memo: Memo
        
//        let memo = DataManager.shared.memoList[indexPath.row]
        
        if isFiltering {
            memo = filteredMemo[indexPath.row]
        } else {
            memo = DataManager.shared.memoList[indexPath.row]
        }
        cell.textLabel?.text = memo.content
        cell.detailTextLabel?.text = dateFormatter.string(for: memo.insertDate)

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let memo = DataManager.shared.memoList[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: { _,_,_  in
            
                DataManager.shared.deleteMemo(memo)
                
                DataManager.shared.memoList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })

        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash.fill")
        } else {
            deleteAction.title = "Delete"
        }
        
        deleteAction.backgroundColor = .red
       
        let shareAction = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            guard let memoContent = memo.content else { return }
            
            let vc = UIActivityViewController(activityItems: [memoContent], applicationActivities: nil)
            self.present(vc, animated: true, completion: nil)
        }
        
        if #available(iOS 13.0, *) {
            shareAction.image = UIImage(systemName: "square.and.arrow.up")
        } else {
            shareAction.title = "Share"
        }
        
        shareAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
    }
}


extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentsForSearchText(searchController.searchBar.text!)
    }
}
