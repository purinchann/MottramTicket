//
//  AppDelegate.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/05/27.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import RxSwift

enum AppError: Error {
    case noError
    case network
    case notAuthorized
    case generic
    case validate([Error])
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var disposeBag = DisposeBag()
    var rootName = "FirstController"
    
    var googleAuthInfo = Variable<(withIDToken: String, accessToken: String, email: String)>((withIDToken: "", accessToken: "", email: ""))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //autoLogin()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme == "com.googleusercontent.apps.274607142041-i82k8snb1atr05c236ecpru45n5mi1mv" {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        }
        return true
    }
    
    private func autoLogin() {
        var locked = true
        KeyChain.read(keys: ["email", "password"], success: { (dict) in
            guard let email = dict["email"], let password = dict["password"] else {
                locked = false
                self.rootVC(id: "FirstController")
                return
            }
            AuthDataStore.shared.login(email: email, password: password).subscribe(onNext: { (isLogin) in
                DispatchQueue.main.async {
                    locked = false
                    self.rootVC(id: (isLogin) ? "BaseController" : "FirstController")
                }
            }, onError: { (error) in
                locked = false
                self.rootVC(id: "FirstController")
            }, onCompleted: nil).disposed(by: self.disposeBag)
        }) { (error) in
            locked = false
            self.rootVC(id: "FirstController")
        }
        
        while(locked) {
            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func rootVC(id: String) {
        self.window?.rootViewController = UIStoryboard(name: id, bundle: nil)
            .instantiateViewController(withIdentifier: id)
        self.rootName = id
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil { return }
        
        let idToken = user.authentication.idToken ?? ""
        let token = user?.authentication?.accessToken ?? ""
        let mail = user?.profile.email ?? ""
        googleAuthInfo.value = (withIDToken: idToken, accessToken: token, email: mail)
    }
}

