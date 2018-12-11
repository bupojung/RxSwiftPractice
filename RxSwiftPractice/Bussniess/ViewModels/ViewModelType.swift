//
//  ViewModelType.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/11.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
