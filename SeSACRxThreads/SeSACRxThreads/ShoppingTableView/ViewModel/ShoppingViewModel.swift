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
    func transform(input: Input) -> Output {
        let todoList = BehaviorRelay(value: mockList)
        
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
        
        return Output(
            shoppingList: todoList,
            cellTap: input.cellTap
        )
    }
    
    struct Input {
        let shoppingListText: ControlProperty<String?>
        let checkBtnTap: PublishRelay<Int>
        let starBtnTap: PublishRelay<Int>
        let addBtnTap: PublishRelay<Void>
        let cellTap: Observable<IndexPath>
    }
    struct Output {
        let shoppingList: BehaviorRelay<[ToDoList]>
        let cellTap: Observable<IndexPath>
    }
}
