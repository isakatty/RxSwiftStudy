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
    private let todoList = BehaviorRelay(value: mockList)
    
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
        bindData()
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
    private func bindData() {
        addView.addBtn.rx.tap
            .withLatestFrom(addView.textField.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                let newTodo = ToDoList(title: text, isFinished: false, highPriority: false)
                mockList.insert(newTodo, at: 0)
                owner.todoList.accept(mockList)
            }
            .disposed(by: disposeBag)
        
        
        todoList
            .bind(to: tableView.rx.items(
                    cellIdentifier: TodoListCell.id,
                    cellType: TodoListCell.self
                )
            ) { row, element, cell in
                cell.configureUI(todo: element)
                
                cell.checkBtn.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        var newTodoList = owner.todoList.value
                        newTodoList[row].isFinished.toggle()
                        owner.todoList.accept(newTodoList)
                    })
                    .disposed(by: cell.disposeBag)
                cell.starBtn.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        var newTodoList = owner.todoList.value
                        newTodoList[row].highPriority.toggle()
                        owner.todoList.accept(newTodoList)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, index in
                let vc = ToDoListDetailViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
