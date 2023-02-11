import UIKit

import RealmSwift

class WriteViewController: BaseViewContoller {
    
    let writeView = WriteView()
    private let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        writeView.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .orange
        
        addleftBarButtonItems()
        addrightBarButtonItems()
        
        writeView.writeTextView.becomeFirstResponder()
    }
    
    override func configureUI() {
    }
    
    override func setConstraints() {
    }
    
    func addrightBarButtonItems(){
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    func addleftBarButtonItems(){
        let backImageButton = UIButton.init(type: .custom)
        backImageButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backImageButton.addTarget(self, action: #selector(backImageButtonClicked), for: .touchUpInside)
        
        let backButton = UIButton.init(type: .custom)
        backButton.setTitleColor(UIColor.orange, for: .normal)
        backButton.setTitle("메모", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        let stackview = UIStackView.init(arrangedSubviews: [backImageButton, backButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 4
        
        let leftBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backButtonClicked(){
        guard let writeText = writeView.writeTextView.text else { return }
        let total = writeText.components(separatedBy: "\n")
        let title = String(total[0])
        let content = total.filter { $0 != title }
        let contentString = content.joined(separator: "\n")
        var checkNum = 1
        
        let tasks = localRealm.objects(UserMemoList.self)
        if tasks.isEmpty {
            if title == "" && contentString == "" {
                checkNum = 0
            } else {
                let task = UserMemoList(memoTitle: title, memoContent: contentString)
                try! localRealm.write{
                    localRealm.add(task)
                    print("Realm Succeed")
                }
                checkNum = 0
            }
        } else {
            for task in tasks {
                if task.memoTitle == title { // memoList와 비교를 할 것이다.
                    try! localRealm.write{
                        task.memoTitle = title
                        task.memoContent = contentString
                        checkNum = 0
                    }
                    break
                } else if task.memoTitle != title || task.memoContent != contentString {
                    if title == "" && contentString == "" {
                        //알럿 메세지 띄우기
                        checkNum = 0
                        break
                    }
                }
            }
        }
        
        if checkNum == 1 { // 신규정보 입력
            let task = UserMemoList(memoTitle: title, memoContent: contentString)
            try! localRealm.write{
                localRealm.add(task)
                print("Realm Succeed")
            }
        }
        
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backImageButtonClicked(){
        guard let writeText = writeView.writeTextView.text else { return }
        let total = writeText.components(separatedBy: "\n")
        let title = String(total[0])
        let content = total.filter { $0 != title }
        let contentString = content.joined(separator: "\n")
        var checkNum = 1
        
        let tasks = localRealm.objects(UserMemoList.self)
        if tasks.isEmpty {
            if title == "" && contentString == "" {
                checkNum = 0
            } else {
                let task = UserMemoList(memoTitle: title, memoContent: contentString)
                try! localRealm.write{
                    localRealm.add(task)
                    print("Realm Succeed")
                }
                checkNum = 0

            }
        } else {
            for task in tasks {
                if task.memoTitle == title { // memoList와 비교를 할 것이다.
                    try! localRealm.write{
                        task.memoTitle = title
                        task.memoContent = contentString
                        print("contentString: \(contentString)")
                        checkNum = 0
                    }
                    break
                } else if task.memoTitle != title || task.memoContent != contentString {
                    if title == "" && contentString == "" {
                        //알럿 메세지 띄우기
                        checkNum = 0
                        break
                    }
                }
            }
        }
        
        if checkNum == 1 { // 신규정보 입력
            let task = UserMemoList(memoTitle: title, memoContent: contentString)
            try! localRealm.write{
                localRealm.add(task)
                print("Realm Succeed")
            }
        }
        
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareButtonClicked(){
        guard let writeText = writeView.writeTextView.text else { return }
        var shareObject = [Any]()
        shareObject.append(writeText)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func saveButtonClicked(){
        guard let writeText = writeView.writeTextView.text else { return }
        let total = writeText.components(separatedBy: "\n")
        let title = String(total[0])
        let content = total.filter { $0 != title }
        let contentString = content.joined(separator: "\n")
        var checkNum = 1
        
        let tasks = localRealm.objects(UserMemoList.self)
        if tasks.isEmpty {
            if title == "" && contentString == "" {
                checkNum = 0
            } else {
                let task = UserMemoList(memoTitle: title, memoContent: contentString)
                try! localRealm.write{
                    localRealm.add(task)
                    print("Realm Succeed")
                }
                checkNum = 0
            }
        } else {
            for task in tasks {
                if task.memoTitle == title { // memoList와 비교를 할 것이다.
                    try! localRealm.write{
                        task.memoTitle = title
                        task.memoContent = contentString
                        checkNum = 0
                    }
                    break
                } else if task.memoTitle != title || task.memoContent != contentString {
                    if title == "" && contentString == "" {
                        //알럿 메세지 띄우기
                        checkNum = 0
                        break
                    }
                }
            }
        }
        
        if checkNum == 1 { // 신규정보 입력
            let task = UserMemoList(memoTitle: title, memoContent: contentString)
            try! localRealm.write{
                localRealm.add(task)
                print("Realm Succeed")
            }
        }
        
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
