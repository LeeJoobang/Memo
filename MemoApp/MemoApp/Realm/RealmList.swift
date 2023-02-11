import UIKit
import RealmSwift

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
