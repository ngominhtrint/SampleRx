//
//  ValidateViewController.swift
//  SampleRx
//
//  Created by TriNgo on 12/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ValidateViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var doSomethingButton: UIButton!
    
    var disposeBag = DisposeBag()
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameErrorLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordErrorLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameField.rx.text.orEmpty
            .map { $0.characters.count >= self.minimalUsernameLength }
//            .shareReplay(1) // without this map would be executed once for each binding, rx is stateless by default
        
        let passwordValid = passwordField.rx.text.orEmpty
            .map { $0.characters.count >= self.minimalPasswordLength }
//            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
//            .shareReplay(1)
        
        usernameValid
            .bindTo(passwordField.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        usernameValid
            .bindTo(usernameErrorLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        passwordValid
            .bindTo(passwordErrorLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        everythingValid
            .bindTo(doSomethingButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        doSomethingButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.showAlert() })
            .addDisposableTo(disposeBag)

    }

    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Validation Example", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
