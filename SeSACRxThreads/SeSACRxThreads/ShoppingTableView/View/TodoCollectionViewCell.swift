//
//  TodoCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by Jisoo HAM on 8/7/24.
//

import UIKit

import SnapKit

final class TodoCollectionViewCell: UICollectionViewCell {
    static let id = "TodoCollectionViewCell"
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(text: String) {
        label.text = text
    }
}
