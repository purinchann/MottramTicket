//
//  UIViewController+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    
    func createController(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardName)
        return controller
    }
    
    func toast(message: String, callback: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alert.dismiss(animated: true, completion: nil)
                callback()
            })
        })
    }
    
    func alert(message: String, callback: @escaping () -> Void) {
        alert(with: message, for:
            UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                callback()
            })
        )
    }
    
    func alert(with message: String, for action: UIAlertAction) {
        alert(with: message, for: [action])
    }
    
    func alert(with message: String, for actions: [UIAlertAction]) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: {})
    }
    
    func actionSheet(with message: String?, for actions: [UIAlertAction], fromView: UIView) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = fromView.frame
        present(alert, animated: true, completion: {})
    }
    
    func actionSheet(with message: String?, for actions: [UIAlertAction], sourceView: UIView, fromView: UIView) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = fromView.frame
        present(alert, animated: true, completion: {})
    }
    
    func actionSheet(with message: String?, for actions: [UIAlertAction], fromBarButton: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.barButtonItem = fromBarButton
        present(alert, animated: true, completion: {})
    }
}

// MARK: - CurrentViewController
extension UIViewController {
    
    class func topDisplayController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topDisplayController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topDisplayController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topDisplayController(controller: presented)
        }
        return controller
    }
    
    var asNavigation: UINavigationController? { return (self as? UINavigationController) }
    
    var isTopDisplayController: Bool {
        
        return UIViewController.topDisplayController() == self
    }
    
    func previousControllerOnNavigation(offset: Int = 1) -> UIViewController? {
        
        guard let navigation = navigationController else { return nil }
        guard let index = navigation.viewControllers.lastIndex(of: self) else { return nil }
        
        if index < offset { return nil }
        
        return navigation.viewControllers[index - offset]
    }
}

// MARK: - IBAction

extension UIViewController {
    
    @IBAction func dismiss() {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Rx

extension UIViewController {
    
    var rxToast: Binder<String> {
        return Binder(self) {(viewController, value: String) in
            viewController.toast(message: value, callback: {})
        }
    }
    
    var viewWillAppearTrigger: Observable<Void> {
        return lifeCycleTrigger(selector: #selector(self.viewWillAppear(_:)))
    }
    
    var viewDidAppearTrigger: Observable<Void> {
        return lifeCycleTrigger(selector: #selector(self.viewDidAppear(_:)))
    }
    
    var viewWillDisappearTrigger: Observable<Void> {
        return lifeCycleTrigger(selector: #selector(self.viewWillDisappear(_:)))
    }
    
    var viewDidDisappearTrigger: Observable<Void> {
        return lifeCycleTrigger(selector: #selector(self.viewDidDisappear(_:)))
    }
    
    private func lifeCycleTrigger(selector: Selector) -> Observable<Void> {
        return rx.sentMessage(selector).map { _ in () }.share(replay: 1)
    }
    
}
