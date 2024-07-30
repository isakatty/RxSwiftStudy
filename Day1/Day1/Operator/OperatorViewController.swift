//
//  OperatorViewController.swift
//  Day1
//
//  Created by Jisoo HAM on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class OperatorViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
    private let itemsB = [2.3, 2.0, 1.3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        
    }
    private func configureLayout() {
        
    }
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
    }
    private func exampleJust() {
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { err in
                print("just - \(err)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    private func exampleOf() {
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("just - \(value)")
            } onError: { err in
                print("just - \(err)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    private func exampleFrom() {
        Observable.from(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { err in
                print("just - \(err)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    private func exampleTake() {
        Observable.repeatElement("Isak")
            .take(5)
            .subscribe { value in
                print("just - \(value)")
            } onError: { err in
                print("just - \(err)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
}
