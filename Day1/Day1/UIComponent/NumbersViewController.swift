//
//  NumbersViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/31/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class NumbersViewController: UIViewController {
    
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    
    private let result = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        setupStream()
    }
    
    func configureHierarchy() {
        [number1, number2, number3, result]
            .forEach { view.addSubview($0) }
        number1.backgroundColor = .yellow
        number2.backgroundColor = .cyan
        number3.backgroundColor = .green
        result.backgroundColor = .systemPink
    }
    func configureLayout() {
        number1.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(safeArea).offset(30)
            make.height.equalTo(30)
        }
        number2.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(number1.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        number3.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(number2.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        result.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(30)
        }
    }
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    func setupStream() {
        Observable
            .combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}
