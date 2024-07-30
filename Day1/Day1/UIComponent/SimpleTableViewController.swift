//
//  SimpleTableViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewController: UIViewController {
    private let simpleLabel = UILabel()
    private let simpleTableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        setTableView()
    }
    
    private func configureHierarchy() {
        [simpleLabel, simpleTableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        simpleLabel.backgroundColor = .yellow
        simpleLabel.textAlignment = .center
        simpleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    private func setTableView() {
        simpleTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
        let items = Observable.just([
            "함",
            "지",
            "수"
        ])
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
                cell.textLabel?.text = "\(element) @ row \(row) "
                return cell
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { "\($0) 을/를 클릭했습니다." }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
