//
//  ShoppingTableViewController.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/4/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ShoppingTableViewController: UIViewController {
    private let viewModel = ShoppingViewModel()
    
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.rowHeight = 80
        table.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.id)
        return table
    }()
    private let addView = TodoListAddView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func configureHierarchy() {
        [addView, tableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "쇼핑"
        
        addView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
        
    }
    private func bind() {
        let input = ShoppingViewModel.Input(
            shoppingListText: addView.textField.rx.text,
            checkBtnTap: PublishRelay<Int>(),
            starBtnTap: PublishRelay<Int>(),
            addBtnTap: PublishRelay<Void>(),
            cellTap: tableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        addView.addBtn.rx.tap
            .bind(to: input.addBtnTap)
            .disposed(by: disposeBag)
        
        output.shoppingList
            .bind(to: tableView.rx.items(
                cellIdentifier: TodoListCell.id,
                cellType: TodoListCell.self)
            ) { row, element, cell in
                
                cell.configureUI(todo: element)
                cell.checkBtn.rx.tap
                    .map { row }
                    .bind(to: input.checkBtnTap)
                    .disposed(by: cell.disposeBag)
                cell.starBtn.rx.tap
                    .map { row }
                    .bind(to: input.starBtnTap)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        output.cellTap
            .bind(with: self) { owner, index in
                let vc = ToDoListDetailViewController()
                vc.navigationItem.title = output.shoppingList.value[index.row].title
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
