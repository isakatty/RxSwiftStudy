//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/8/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class BoxOfficeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = BoxOfficeViewModel()
    private let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 120
        table.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        return table
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "20240807 이런 날짜형식으로 검색해주세요."
        return searchBar
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func configureHierarchy() {
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        tableView.backgroundColor = .systemYellow
    }
    private func bind() {
        // searchBar enter -> 글자 넘겨줘야함.
        // 넘겨받은 글자를 통해서 API 통신 -> 결과 받아 output 넘겨줘야함.
        // output 받아서 tableview에 보여줘야함.
        
        let recentText = PublishSubject<String>()
        let input = BoxOfficeViewModel.Input(
            searchedText: recentText,
            searchBtnTap: searchBar.rx.searchButtonClicked
        )
        
        searchBar.rx.text.orEmpty
            .subscribe(onNext: { text in
                recentText.onNext(text)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.searchedResultMovie
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)) { row, element, cell in
                cell.configureUI(movieName: element.movieNm)
            }
            .disposed(by: disposeBag)
    }
}
