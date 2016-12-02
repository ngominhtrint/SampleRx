//
//  ViewController.swift
//  SampleRx
//
//  Created by TriNgo on 12/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional
import Moya
import Moya_ModelMapper
import Mapper

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var latestGiphyName: Observable<String> {
        return searchBar.rx.text
            .filterNil()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Giphy>!
    var giphyTrackerModel: GiphyTrackerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureKeyboardDismissesOnScroll()
    }

    func setup() {
        provider = RxMoyaProvider<Giphy>()
        giphyTrackerModel = GiphyTrackerModel(provider: provider, gifUrl: latestGiphyName)
        giphyTrackerModel
            .trackGiphy()
            .bindTo(tableView.rx.items(cellIdentifier: "SearchCell", cellType: SearchCell.self)) {
                (index, giphyDataModel, cell) in
                cell.titleLabel.text = giphyDataModel.url
                print("\(index): \(giphyDataModel.images?.original?.mp4)")
            }
            .addDisposableTo(disposeBag)
        
        // tap on table view item
        tableView
            .rx.itemSelected
            .subscribe { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureKeyboardDismissesOnScroll() {
        tableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { index in
                if self.searchBar?.isFirstResponder ?? false {
                    _ = self.searchBar?.resignFirstResponder()
                }
            })
            .addDisposableTo(disposeBag)
    }
}

