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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }



    func request() -> Observable<Result<String>> {
        return RequestMock.request(result: "data", successProbability: 0.8).timeout(2.0, scheduler: MainScheduler.instance)
            .share()
    }
    
    func bind() {
        self.button.rx.tap.debug("tap").flatMapLatest{ _ in
            return self.request().catchError { (error) -> Observable<Result<String>> in
                // show retry view
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
