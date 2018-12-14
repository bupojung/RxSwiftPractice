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
    var viewModel = TimeOutAndRetryViewModel()
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var refresh: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    func bind() {
        let willAppear = self.rx.viewWillAppear.asObservable().map{ _ in }
        let tap = self.button.rx.tap.asObservable()
        let refreshTap = self.refresh.rx.tap.asObservable()
        let input = TimeOutAndRetryViewModel.Input(refreshTap: refreshTap, retryTap: tap, viewDidShow: willAppear)
        let output = self.viewModel.transform(input)
        


        output.loading.drive(loadingView.rx.isHidden).disposed(by: bag)
        output.showButton.drive(button.rx.isHidden).disposed(by: bag)
        output.showLabel.drive(resultLabel.rx.isHidden).disposed(by: bag)
        output.result.drive(resultLabel.rx.text).disposed(by: bag)
    }

}
