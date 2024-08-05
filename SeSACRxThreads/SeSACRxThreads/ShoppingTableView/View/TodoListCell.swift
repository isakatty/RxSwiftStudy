//
//  TodoListCell.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/4/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class TodoListCell: UITableViewCell {
    static let id = "TodoListCell"
    
    var disposeBag = DisposeBag()
    
    lazy var checkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return btn
    }()
    lazy var starBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        return btn
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [checkBtn, label, starBtn]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        checkBtn.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(checkBtn.snp.height)
        }
        starBtn.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
            make.width.equalTo(checkBtn.snp.height)
        }
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(checkBtn.snp.trailing)
            make.trailing.equalTo(starBtn.snp.leading)
        }
    }
    
    func configureUI(todo: ToDoList) {
        label.text = todo.title
        configureCheckBtnUI(isChecked: todo.isFinished)
        configureStarBtnUI(isHighPriority: todo.highPriority)
    }
    func configureCheckBtnUI(isChecked: Bool) {
        let checkImg = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        checkBtn.setImage(checkImg, for: .normal)
    }
    func configureStarBtnUI(isHighPriority: Bool) {
        let starImg = isHighPriority ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        starBtn.setImage(starImg, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
