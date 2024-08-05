//
//  ViewModelType.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/5/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
