//
//  CalculatorViewController.swift
//  SampleRx
//
//  Created by TriNgo on 12/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CalculatorViewController: UIViewController {

    @IBOutlet weak var numberAField: UITextField!
    @IBOutlet weak var numberBField: UITextField!
    @IBOutlet weak var resultField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(numberAField.rx.text.orEmpty, numberBField.rx.text.orEmpty) {
            value1, value2 in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0)
        }
        .map{ $0.description }
        .bindTo(resultField.rx.text)
        .addDisposableTo(disposeBag)
        
        
    }
    
}
