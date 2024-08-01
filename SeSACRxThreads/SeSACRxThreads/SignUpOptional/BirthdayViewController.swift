//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    // UI에 보여줄 것 + onCom, onErr를 만날 일 XX, Observable이자 Observer. -> subject로도 가능하지만, onCom, onErr를 전달할 가능성이 아예 없는 Relay 사용.
    let infoText = BehaviorRelay(value: "만 17세 이상만 가입 가능합니다.")
    let textColor = BehaviorRelay(value: UIColor.red)
    let today = BehaviorRelay(value: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bindData()
    }
    
    func configureLayout() {
        [infoLabel, containerStackView, birthDayPicker, nextButton]
            .forEach { view.addSubview($0) }
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel]
            .forEach { containerStackView.addArrangedSubview($0) }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    func bindData() {
        /*
         Calendar - year, month, day 로 나눔
            각 라벨에 보여야함. -> 오늘자 날짜로 보여야함.
         + 만 17세 조건 판별 -> validation
         + validation ? .blue, isEnabled, text 달라요 : .gray, !isEnabled, text 만 17세 어쩌그
         */
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                // alert 띄우기
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

}
