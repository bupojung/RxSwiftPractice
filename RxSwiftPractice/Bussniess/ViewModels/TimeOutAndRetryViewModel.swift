//
//  TimeOutAndRetryViewModel.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/11.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TimeOutAndRetryViewModel: ViewModelType {
    struct Input {
        let retryTap: Observable<()>
        let viewDidShow: Observable<()>
    }
    
    struct Output {
        let error: Driver<String>
        let result: Driver<String>
    }
    
    func transform(_ input: TimeOutAndRetryViewModel.Input) -> TimeOutAndRetryViewModel.Output {
        return Output(error: Driver.just("error: timeout"),
                      result: Driver.just("datas"))
    }
}
