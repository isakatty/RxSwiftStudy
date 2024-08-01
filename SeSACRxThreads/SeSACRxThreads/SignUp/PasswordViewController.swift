//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

/*
 8자리 이상 입력, 조건 ? Pink, isEnable : LightGray, isEnable = false
 - description label에 상태 알려주기
 - true면 description label 사라지기
 */

class PasswordViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let descriptionLabel = UILabel()
    let validText = Observable.just("8자 이상 입력해주세요.")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bindData()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bindData() {
        // text 전달
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

}
