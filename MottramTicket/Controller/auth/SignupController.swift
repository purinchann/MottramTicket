//
//  SignupController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class SignupController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    fileprivate let repository: SignupRepository = SignupRepository()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUseCase()
    }
    
    private func setupUI() {
        title = "新規作成"
        passwordTextField.isSecureTextEntry = true
    }
    
    private func bindUseCase() {
        
        repository.isSignup.asObservable().bind{[weak self] isLogin in
            if isLogin {
                self?.toast(message: "成功", callback: {})
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {return}
                appDelegate.rootVC(id: "BaseController")
            }
            }.disposed(by: disposeBag)
    }
    
    private func validation(mail: String, pass: String, _ handler: @escaping (Bool) -> Void) {
        // mail && pass
        if mail.isEmpty && pass.isEmpty {
            handler(false)
        }
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !emailPredicate.evaluate(with: mail) {
            handler(false)
        }
        
        if pass.count < 8 {
            handler(false)
        }
        
        handler(true)
    }
    
    @IBAction func tapOnSignup(_ sender: UIButton) {
        guard let mail = mailTextField.text,
            let password = passwordTextField.text else {return}
        validation(mail: mail, pass: password, { isRes in
            if isRes {
                self.repository.signup(mail, password)
            } else {
                self.toast(message: "メールとパスワードを見直してください", callback: {})
            }
        })
    }
}
