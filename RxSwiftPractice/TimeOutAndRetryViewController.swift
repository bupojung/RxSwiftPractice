//
//  TimeOutAndRetryViewController.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/11.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimeOutAndRetryViewController: UIViewController {
    var bag = DisposeBag()

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }


    enum Result<T>: CustomDebugStringConvertible {
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
    func request() -> Observable<Result<String>> {
        return  Observable.create({ (observer) -> Disposable in
            print("run Request")
            let time = Double.random(in: 1 ..< 4)
            print("request time\(time)")
            DispatchQueue.global().asyncAfter(deadline: .now() + time, execute: {
                observer.onNext(.succ("datas\(time)"))
                observer.onCompleted()
            })
            return Disposables.create()
        }).timeout(2.0, scheduler: MainScheduler.instance)
            .share()
    }
    
    func bind() {
        self.button.rx.tap.debug("tap").flatMapLatest{ _ in
            return self.request().catchError { (_) -> Observable<Result<String>> in
                // show retry view
                let error = NSError(domain: "requesr", code: 99, userInfo: [NSLocalizedDescriptionKey:"timeout"])
                return Observable.just(.error(error))
            }
            }.debug("request")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (r) in
                // show data
                switch r {
                case .succ(let data):
                    self.resultLabel.text = data
                case .error(let e):
                    self.resultLabel.text = e.localizedDescription
                }
            }).disposed(by: bag)
    }

}
