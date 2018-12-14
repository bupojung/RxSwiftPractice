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

class TimeOutAndRetryViewModel: ViewModelType {
    func request() -> Observable<Result<String>> {
        return RequestMock.request(result: "data__", successProbability: 1.0).timeout(2.0, scheduler: MainScheduler.instance)
            .share()
    }
    struct Input {
        let refreshTap: Observable<()>
        let retryTap: Observable<()>
        let viewDidShow: Observable<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let showButton: Driver<Bool>
        let showLabel: Driver<Bool>
        let result: Driver<String>
    }
    
    func transform(_ input: TimeOutAndRetryViewModel.Input) -> TimeOutAndRetryViewModel.Output {
        let triger = Observable.merge(input.retryTap, input.viewDidShow, input.refreshTap)
        let aRequest = request().catchError { (error) -> Observable<Result<String>> in
            print("timeout")
            return Observable.just(.error(error))
        }.share()
        
        let startRequest = triger.flatMap { (_) -> Observable<Result<String>> in
            return aRequest
        }

        let hideLoading = triger.flatMap { (_) -> Observable<Bool> in
            return aRequest.map({ (_) -> Bool in
                return true
            }).startWith(false)
        }.asDriver(onErrorJustReturn: true).startWith(false)

        let hideButton = triger.flatMap { (_) -> Observable<Bool> in
            return startRequest.flatMap({ (result) -> Observable<Bool> in
                switch result {
                case .error(_):
                    return Observable.just(false)
                default:
                    return Observable.just(true)
                }
            }).startWith(true)
        }
        .asDriver(onErrorJustReturn: false).startWith(true)
        
        let hideLabel = startRequest.flatMap({ (result) -> Observable<Bool> in
                switch result {
                case .succ(_):
                    return Observable.just(false)
                default:
                    return Observable.just(true)
                }
        }).asDriver(onErrorJustReturn: true).startWith(true)
        
        let result = startRequest.flatMap { (result) -> Observable<String> in
            switch result {
            case .succ(let data):
                return Observable.just(data)
            default:
                return Observable.empty()
            }
        }.asDriver(onErrorJustReturn: "")
        
        return Output(loading: hideLoading, showButton: hideButton, showLabel: hideLabel, result: result)
    }
}
