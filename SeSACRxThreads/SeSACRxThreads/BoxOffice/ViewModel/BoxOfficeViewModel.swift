//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/8/24.
//

import Foundation

import RxSwift
import RxCocoa

final class BoxOfficeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchedText: PublishSubject<String>
        let searchBtnTap: ControlEvent<Void>
    }
    struct Output {
        let searchedResultMovie: PublishSubject<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[DailyBoxOfficeList]>()
        let output = Output(searchedResultMovie: movieList)
        
        input.searchBtnTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchedText)
            .distinctUntilChanged()
            .map { text in
                guard let intText = Int(text) else {
                    return 240807
                }
                return intText
            }
            .map { "\($0)" }
            .flatMap { NetworkManager.shared.callMovie(dateString: $0) }
            .subscribe(onNext: { movie in
                movieList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            })
            .disposed(by: disposeBag)

        input.searchedText
            .subscribe(with: self) { owner, value in
                print("VM - text : \(value)")
            }
            .disposed(by: disposeBag)
        return output
    }
}
