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
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collection.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.id)
        return collection
    }()
    private let addView = TodoListAddView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func configureHierarchy() {
        [addView, tableView, collectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "쇼핑"
        
        addView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    private func bind() {
        let selectedString = PublishSubject<String>()
        
        let input = ShoppingViewModel.Input(
            shoppingListText: addView.textField.rx.text,
            checkBtnTap: PublishRelay<Int>(),
            starBtnTap: PublishRelay<Int>(),
            addBtnTap: PublishRelay<Void>(),
            cellTap: tableView.rx.itemSelected.asObservable(),
            selectedText: selectedString
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
        
        output.collectionList
            .bind(to: collectionView.rx.items(
                    cellIdentifier: TodoCollectionViewCell.id,
                    cellType: TodoCollectionViewCell.self
                )
            ) { row, element, cell in
                cell.configureUI(text: element)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(
                collectionView.rx.itemSelected,
                collectionView.rx.modelSelected(String.self)
            )
            .map({ index, value in
                return value + " 구매하기"
            })
            .subscribe(with: self) { owner, value in
                selectedString.on(.next(value))
            }
            .disposed(by: disposeBag)
    }
}

extension ShoppingTableViewController {
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
