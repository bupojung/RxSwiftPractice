//
//  RequestMock.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/11.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import Foundation
import RxSwift

enum Result<T>: CustomDebugStringConvertible where T: CustomDebugStringConvertible {
    case succ(T)
    case error(Error)
    var debugDescription: String {
        switch self {
        case .succ(let d):
            return ".succ(\(d))"
        case .error(let e):
            return ".error(\(e))"
        }
    }
}

class RequestMock {
    static func request<DataType>(result: DataType, successProbability: Double = 1.0) -> Observable<Result<DataType>> {
        guard successProbability >= 0, successProbability <= 1 else {
            fatalError("errorProbability must between 0 to 1")
        }
        return  Observable.create({ (observer) -> Disposable in
            let time = Double.random(in: 1 ..< 4)
            print("run Request time: \(time)")
            let timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { (_) in
                let random = Double.random(in: 0 ..< 100)
                print("request time\(time)")
                if random > 100 * successProbability {
                    let error = NSError(domain: "request", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock request error"])
                    observer.onError(error)
                } else {
                    observer.onNext(.succ(result))
                    observer.onCompleted()
                }
            })
            return Disposables.create {
                print("request did disposed")
                timer.invalidate()
            }
        })
    }
}
