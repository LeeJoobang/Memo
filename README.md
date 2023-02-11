# MemoApp

### 앱 소개

| ![Simulator Screen Shot - iPhone 14 - 2023-02-10 at 19 44 25](https://user-images.githubusercontent.com/84652513/218244181-1c239f79-f0f0-4815-9540-8104ae8a389b.png) | ![Simulator Screen Shot - iPhone 14 - 2023-02-10 at 19 44 20](https://user-images.githubusercontent.com/84652513/218244196-ad2a352b-7c99-4a27-8915-aa112eb94438.png) | ![Simulator Screen Shot - iPhone 14 - 2023-02-10 at 19 44 06](https://user-images.githubusercontent.com/84652513/218244212-5ef14022-2be1-48ac-97d4-30d19ca9dbe0.png) | ![Simulator Screen Shot - iPhone 14 - 2023-02-10 at 19 42 33](https://user-images.githubusercontent.com/84652513/218244222-e96131f5-c69d-4979-8146-a07677ad6565.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |

- Memo는 사용자가 메모를 작성하고 작성된 메모를 관리할 수 있는 앱입니다. 현재 아이폰에서 제공하는 메모앱의 기능을 구현해보고자 하였습니다.

------

### 개발기간 및 사용 기술

#### 개발 기간

- '22. 08. 31. - 09. 05.(6일간)

#### 사용 기술

- Memo는 사용자가 메모를 작성하고 작성된 메모를 관리할 수 있는 앱입니다. 현재 아이폰에서 제공하는 메모앱의 기능을 구현해보고자 하였습니다.

------

#### 고민과 해결

- PK를 활용한 데이터 베이스(Realm) Schema 설계 및 정규화 진행

  ```swift
  class UserMemoList: Object {
      @Persisted var memoCheck: Bool // 즐겨찾기(필수)
      @Persisted var memoTitle: String // 제목(필수)
      @Persisted var memoContent: String // 내용(필수)
      
      @Persisted(primaryKey: true) var objectID: ObjectId
  
      convenience init(memoTitle: String, memoContent: String) {
          self.init()
          self.memoCheck = false
          self.memoTitle = memoTitle
          self.memoContent = memoContent
      }
  }
  
  ```

- Swift Generic과 Enum을 활용하여 화면 전환 메서드 구현

  ```swift
  extension UIViewController {
      
      enum TransitionStyle {
          case present
          case presentNavigation
          case presentFullNavigation
          case push
      }
      
      func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
          
          switch transitionStyle {
          case .present:
              self.present(viewController, animated: true)
          case .presentNavigation:
              let navi = UINavigationController(rootViewController: viewController)
              self.present(navi, animated: true)
          case .push:
              self.navigationController?.pushViewController(viewController, animated: true)
          case .presentFullNavigation:
              let navi = UINavigationController(rootViewController: viewController)
              navi.modalPresentationStyle = .fullScreen
              self.present(navi, animated: true)
          }
      }
  }
  ```

- 메모가 추가될 때마다 네비게이션 타이틀의 변경을 적용하고자 하였음. 데이터 변경 시점에 didSet을 통해 단방향 데이터 바인딩 구현

  ```swift
  var tasks: Results<UserMemoList>! {
          didSet {
              self.listView.tableView.reloadData()
              self.navigationItem.title = "\(tasks?.count ?? 0)개의 메모"
          }
      }
  ```

- 메모 CRUD 및 UISearchController로 실시간 메모 검색 기능 지원
