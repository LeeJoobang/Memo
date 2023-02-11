import UIKit

class ListView: BaseView{
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {

        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }

    }
    
    
    
}
