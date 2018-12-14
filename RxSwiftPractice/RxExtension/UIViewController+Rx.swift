//
//  UIViewController+Rx.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/12.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

