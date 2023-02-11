import UIKit
import SnapKit

class ListTableViewCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 20
        return view
    }()
    
    //제목 내용 날짜
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.tintColor = .white
        label.textAlignment = .left
        label.text = ""

        label.font = UIFont(name: "Halvetica", size: 13)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.tintColor = .white
        label.textAlignment = .left
        label.text = ""
        
        label.font = UIFont(name: "Halvetica", size: 11)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.tintColor = .white
        label.textAlignment = .left
        label.text = ""
        
        label.font = UIFont(name: "Halvetica", size: 11)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [titleLabel, contentLabel, dateLabel].forEach {
            self.totalView.addSubview($0)
        }
        
        self.contentView.addSubview(totalView)
    }
    
    override func setConstraints() {
        
        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.leading.equalTo(0)
            make.height.equalTo(totalView.snp.height).multipliedBy(0.5)
            make.trailing.equalTo(0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(totalView.snp.leading)
            make.height.equalTo(totalView.snp.height).multipliedBy(0.5)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(self.dateLabel.snp.trailing).offset(10)
            make.height.equalTo(totalView.snp.height).multipliedBy(0.5)
            make.width.equalTo(contentLabel.snp.width)
            make.trailing.equalTo(0)
        }
    }
    
    
    
}
