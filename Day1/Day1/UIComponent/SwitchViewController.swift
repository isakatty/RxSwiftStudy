//
//  SwitchViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SwitchViewController: UIViewController {
    private let simpleSwitch = UISwitch()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        setSwitch()
    }
    
    private func configureHierarchy() {
        view.addSubview(simpleSwitch)
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        simpleSwitch.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
            make.height.equalTo(70)
            make.width.equalTo(30)
        }
    }
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    private func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
