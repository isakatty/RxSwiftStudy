//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/5/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PasswordViewModel: ViewModelType {
    struct Input {
        let nextBtnTap: Observable<Void>
        let textFieldText: ControlProperty<String?>
    }
    struct Output {
        let validText: Observable<String>
        let validation: Observable<Bool>
        let nextBtnTap: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.textFieldText.orEmpty
            .map { $0.count >= 8 }
            .share()
        let validText = Observable.just("8자 이상 입력해주세요.")
        
        return Output(
            validText: validText,
            validation: validation,
            nextBtnTap: input.nextBtnTap
        )
    }
}
