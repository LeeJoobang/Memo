import UIKit
import SwiftUI
import SnapKit
import RealmSwift

class ListViewController: BaseViewContoller {
    
    var listView = ListView()
    let localRealm = try! Realm()
    
    var tasks: Results<UserMemoList>! {
        didSet {
            self.listView.tableView.reloadData()
            self.navigationItem.title = "\(tasks?.count ?? 0)개의 메모"
        }
    }
    
    var fileterInfo = [UserMemoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = listView
        listView.backgroundColor = .systemGray6
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        
        self.listView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reusableIdentifier)
        
        setupSearchController()
        setupToolbar()
        
        print("Realm is located at:", localRealm.configuration.fileURL!) //스니펫에 저장해서 써도 무방
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        tasks = localRealm.objects(UserMemoList.self)
        listView.tableView.reloadData()
        fetchRealm()
    }
    
    override func configureUI() {
    }
    
    override func setConstraints() {
    }
    
    func setupToolbar(){
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
        
        let toolbarItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItem.tintColor = .orange
        toolbar.setItems([flexibleSpace, toolbarItem], animated: true)
    }
    
    @objc func writeButtonClicked(){
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering == true {
            return 1
        } else {
            var pinInfo = [UserMemoList]()
            var normalInfo = [UserMemoList]()
            
            for task in tasks {
                if task.memoCheck == true {
                    pinInfo.append(task)
                } else {
                    normalInfo.append(task)
                }
            }
            
            return tasks.count < 1 ? 1 : 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        if isFiltering == true {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.black
            
            let sectionLabel = UILabel(frame: CGRect(x: 10, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel.font = UIFont(name: "Helvetica", size: 20)
            sectionLabel.text = String(describing: ["\(fileterInfo.count)개 찾음"][section])
            sectionLabel.textColor = UIColor.white
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)
            return headerView
        } else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.black
            
            let sectionLabel = UILabel(frame: CGRect(x: 10, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel.font = UIFont(name: "Helvetica", size: 20)
            
            if tasks.count < 1 {
                sectionLabel.text = String(describing: ["메모"][section])
            } else {
                sectionLabel.text = String(describing: ["고정된 메모", "메모"][section])
            }
            
            sectionLabel.textColor = UIColor.white
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)
            return headerView
        }
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var pinInfo = [UserMemoList]()
        var normalInfo = [UserMemoList]()
        
        if editingStyle == .delete{
            for task in tasks {
                if task.memoCheck == true {
                    pinInfo.append(task)
                } else {
                    normalInfo.append(task)
                }
            }
            
            if indexPath.section == 0 {
                if self.isFiltering == true {
                    try! localRealm.write{
                        localRealm.delete(fileterInfo[indexPath.row])
                    }
                    self.listView.tableView.reloadData()
                } else {
                    try! localRealm.write{
                        localRealm.delete(pinInfo[indexPath.row])
                    }
                    self.listView.tableView.reloadData()
                }
            } else if indexPath.section == 1 {
                try! localRealm.write{
                    localRealm.delete(normalInfo[indexPath.row])
                }
                self.listView.tableView.reloadData()
            }
            self.listView.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var pinInfo = [UserMemoList]()
        var normalInfo = [UserMemoList]()
        
        for task in tasks {
            if task.memoCheck == true {
                pinInfo.append(task)
            } else {
                normalInfo.append(task)
            }
        }
        
        let check = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            if indexPath.section == 0 {
                if self.isFiltering == true {
                    self.updateFavorite(item: self.fileterInfo[indexPath.row])
                } else {
                    self.updateFavorite(item: pinInfo[indexPath.row])
                    self.fetchRealm()
                }
            } else if indexPath.section == 1 {
                self.updateFavorite(item: normalInfo[indexPath.row])
                self.fetchRealm()
            }
            
        }
        
        let image = indexPath.section == 0 ? "pin.fill" : "pin.slash.fill"
        check.image = UIImage(systemName: image)
        check.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [check])
    }
    
    func fetchRealm(){
        tasks = fetch()
    }
    
    func fetch() -> Results<UserMemoList> {
        return localRealm.objects(UserMemoList.self).sorted(byKeyPath: "memoTitle", ascending: true)
    }
    
    func updateFavorite(item: UserMemoList){
        try! localRealm.write {
            item.memoCheck.toggle()
            print("realm update succed, reload Rows 필요")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering == true {
            return fileterInfo.count
        } else {
            var checkCount = 0
            
            if tasks.count > 0 {
                for item in 0...tasks.count - 1 {
                    if tasks[item].memoCheck == true {
                        checkCount += 1
                    }
                }
            }
            if section == 0 {
                return checkCount
            }
            return tasks.count - checkCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reusableIdentifier, for: indexPath) as! ListTableViewCell
        cell.backgroundColor = .black
        
        if isFiltering == true {
            cell.titleLabel.text = fileterInfo[indexPath.row].memoTitle
            cell.dateLabel.text = ""
            cell.contentLabel.text = fileterInfo[indexPath.row].memoContent
            return cell
        } else {
            var pinInfo = [UserMemoList]()
            var normalInfo = [UserMemoList]()
            
            for task in tasks {
                if task.memoCheck == true {
                    pinInfo.append(task)
                } else {
                    normalInfo.append(task)
                }
            }
            cell.titleLabel.text = indexPath.section == 0 ? pinInfo[indexPath.row].memoTitle : normalInfo[indexPath.row].memoTitle
            cell.dateLabel.text = ""
            cell.contentLabel.text = indexPath.section == 0 ? pinInfo[indexPath.row].memoContent : normalInfo[indexPath.row].memoContent
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        
        var pinInfo = [UserMemoList]()
        var normalInfo = [UserMemoList]()
        
        for task in tasks {
            if task.memoCheck == true {
                pinInfo.append(task)
            } else {
                normalInfo.append(task)
            }
        }
        
        if indexPath.section == 0 {
            vc.writeView.writeTextView.text = pinInfo[indexPath.row].memoTitle + "\n" + pinInfo[indexPath.row].memoContent
        } else if indexPath.section == 1{
            vc.writeView.writeTextView.text = normalInfo[indexPath.row].memoTitle + "\n" + normalInfo[indexPath.row].memoContent
        }
    }
}

extension ListViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func setupSearchController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .systemGray6
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        fileterInfo = self.tasks.filter { $0.memoTitle.lowercased().contains(text) || $0.memoContent.lowercased().contains(text) }
        print(fileterInfo)
        self.listView.tableView.reloadData()
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
}
