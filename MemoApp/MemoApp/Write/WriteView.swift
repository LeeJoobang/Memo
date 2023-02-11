import UIKit

class WriteView: BaseView{
    
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let writeTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.black
        view.font = .systemFont(ofSize: 16)
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        
        adjustUITextViewHeight(textView: writeTextView)

        [writeTextView].forEach {
            self.totalView.addSubview($0)
        }
        
        [totalView].forEach {
            self.addSubview($0)
        }
        
        
    }
    
    override func setConstraints() {

        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        writeTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }
    
}

extension UIView: UITextFieldDelegate {
    
     func adjustUITextViewHeight(textView: UITextView){
         textView.translatesAutoresizingMaskIntoConstraints = true
         textView.isScrollEnabled = false
         textView.sizeToFit()
    }
}
