//
//  GiphyTrackerModel.swift
//  Spoofy
//
//  Created by TriNgo on 11/28/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import Moya
import Mapper
import Moya_ModelMapper
import RxSwift
import RxOptional

struct GiphyTrackerModel {

    let provider: RxMoyaProvider<Giphy>
    let gifUrl: Observable<String>
    
    func trackGiphy() -> Observable<[GiphyDataModel]> {
        return gifUrl.observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<[GiphyDataModel]> in
                return self.findGifs(name: name, offset: 0)
            }
    }
    
    internal func findGifs(name: String, offset: Int) -> Observable<[GiphyDataModel]> {
        return self.provider
            .request(Giphy.search(name, offset))
            .debug()
            .mapArray(type: GiphyDataModel.self, keyPath: "data")
    }
}

