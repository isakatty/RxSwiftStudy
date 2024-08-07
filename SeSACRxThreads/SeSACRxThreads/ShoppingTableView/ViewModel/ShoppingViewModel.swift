//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/5/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ShoppingViewModel: ViewModelType {
    private var disposeBag = DisposeBag()
    private var collectionShoppingList = ["키보드", "맥북", "에어팟", "베이스 기타", "앰프", "마우스", "CDP"]
    
    func transform(input: Input) -> Output {
        let todoList = BehaviorRelay(value: mockList)
        let output = Output(
            collectionList: BehaviorSubject<[String]>(value: collectionShoppingList),
            shoppingList: todoList,
            cellTap: input.cellTap
        )
        
        input.addBtnTap
            .withLatestFrom(input.shoppingListText.orEmpty)
            .bind { text in
                let newTodo = ToDoList(title: text, isFinished: false, highPriority: false)
                mockList.insert(newTodo, at: 0)
                todoList.accept(mockList)
            }
            .disposed(by: disposeBag)
        
        input.checkBtnTap
            .bind { index in
                var newTodoList = todoList.value
                newTodoList[index].isFinished.toggle()
                todoList.accept(newTodoList)
            }
            .disposed(by: disposeBag)
        input.starBtnTap
            .bind { index in
                var newTodoList = todoList.value
                newTodoList[index].highPriority.toggle()
                todoList.accept(newTodoList)
            }
            .disposed(by: disposeBag)
        input.selectedText
            .subscribe(with: self) { owner, value in
                let newTodo = ToDoList(title: value, isFinished: false, highPriority: false)
                mockList.insert(newTodo, at: 0)
                todoList.accept(mockList)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    struct Input {
        let shoppingListText: ControlProperty<String?>
        let checkBtnTap: PublishRelay<Int>
        let starBtnTap: PublishRelay<Int>
        let addBtnTap: PublishRelay<Void>
        let cellTap: Observable<IndexPath>
        let selectedText: PublishSubject<String>
    }
    struct Output {
        let collectionList: BehaviorSubject<[String]>
        let shoppingList: BehaviorRelay<[ToDoList]>
        let cellTap: Observable<IndexPath>
    }
}
