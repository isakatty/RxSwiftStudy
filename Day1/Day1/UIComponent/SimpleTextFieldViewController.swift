//
//  SimpleTextFieldViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SimpleTextFieldViewController: UIViewController {
    private let signName: UITextField = UITextField()
    private let signEmail = UITextField()
    private let simpleLabel = UILabel()
    private let signButton = UIButton()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        setSign()
    }
    
    private func configureHierarchy() {
        [signName, signEmail, simpleLabel]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        signEmail.backgroundColor = .yellow
        signEmail.textAlignment = .center
        
        signName.backgroundColor = .magenta
        signName.textAlignment = .center
        signName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        signButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.horizontalEdges.equalTo(safeArea)
        }
    }
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    private func setSign() {
        Observable
            .combineLatest(
                signName.rx.text.orEmpty,
                signEmail.rx.text.orEmpty
            ) { value1, value2 in
                return "이름은 \(value1)이고, 이메일은 \(value2)입니다"
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        signButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
}
