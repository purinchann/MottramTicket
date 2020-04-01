//
//  FirstController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import RxSwift
import RxCocoa

class FirstController: UIViewController {
    
    @IBOutlet weak var googleButton: UIButton!
    
    fileprivate let repository: FirstRepository = FirstRepository()
    private let disposeBag: DisposeBag = DisposeBag()
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        googleBtnImageAdust()
        bindGoogleAuth()
    }
    
    func bindGoogleAuth() {
        
        appDelegate.googleAuthInfo.asObservable().bind{ [weak self] authcation in
            if authcation.withIDToken.isEmpty && authcation.accessToken.isEmpty {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authcation.withIDToken, accessToken: authcation.accessToken)
            self?.repository.googleSignup(credential: credential)
        }.disposed(by: disposeBag)
        
        repository.isGoogleAuth.asObservable().bind{[weak self] isRes in
            if isRes {
                self?.appDelegate.rootVC(id: "BaseController")
            }
        }.disposed(by: disposeBag)
    }
    
    func googleBtnImageAdust() {
        
        googleButton.setImage(UIImage(named: "google"), for: .normal)
        let halfWidth = googleButton.frame.size.width / 2
        guard let text = googleButton.titleLabel?.text else { return }
        let halfTextWidth = (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width/2
        let diff = halfTextWidth - halfWidth
        googleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: diff, bottom: 0, right: 0)
    }
    
    @IBAction func toLogin(_ sender: UIButton) {
        let loginVC = createController(storyboardName: "LoginController")
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func toSignup(_ sender: UIButton) {
        let signupVC = createController(storyboardName: "SignupController")
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func tapOnGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension FirstController: GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        if error != nil { return }
        
        guard let _signIn = signIn,
            let _currentUser = _signIn.currentUser,
            let _authentication = _currentUser.authentication,
            let _accessToken = _authentication.accessToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: _authentication.idToken,
                                                       accessToken: _accessToken)
        repository.googleLogin(credential: credential)
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
