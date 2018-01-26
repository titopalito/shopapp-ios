//
//  BaseViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class BaseViewModel {
    var state = PublishSubject<ViewState>()

    func tryAgain() {
        assert(false, "'tryAgain' method not implemented")
    }
}
