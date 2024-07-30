//
//  ViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SimplePickerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let pickerView = UIPickerView()
    private let simpleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        configureHierarchy()
        configureLayout()
        setPickerView()
    }
    
    func configureHierarchy() {
        [simpleLabel, pickerView]
            .forEach { view.addSubview($0) }
    }
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        simpleLabel.backgroundColor = .yellow
        simpleLabel.textAlignment = .center
        
        simpleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }

    private func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

