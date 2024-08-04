//
//  TodoListAddView.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/5/24.
//

import UIKit

final class TodoListAddView: UIView {
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "무엇을 구매하실 건가요?"
        return tf
    }()
    let addBtn: UIButton = {
        var config = UIButton.Configuration.bordered()
        let btn = UIButton(configuration: config)
        btn.setTitle("추가", for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [textField, addBtn]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        addBtn.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
            make.width.equalTo(addBtn.snp.height).multipliedBy(2)
        }
        textField.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(addBtn.snp.leading)
        }
    }
    
}
