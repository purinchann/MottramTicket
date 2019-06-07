//
//  SettingController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class SettingController: UITableViewController {
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    
    fileprivate let repository = SettingRepository()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "設定"
        setupTableView()
        bindUseCase()
        repository.fetchShop()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func bindUseCase() {
        
        repository.shop.asObservable().bind{[weak self] value in
            guard let `self` = self,
                let fee = value?.fee,
                let businessHour = value?.businessHours else {return}
            self.feeLabel.text = "\(fee)円"
            self.businessHoursLabel.text = businessHour
        }.disposed(by: disposeBag)
        
        repository.isLogout.asObservable().bind{[weak self] flag in
            
            guard let `self` = self, let _flag = flag else {return}
            if !_flag {
                self.toast(message: "もう一度ログアウトをお試しください", callback: {})
                return
            }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if appDelegate.rootName == "FirstController" {
                    appDelegate.window?.rootViewController = self.createController(storyboardName: appDelegate.rootName)
                } else {
                    appDelegate.window?.rootViewController = self.createController(storyboardName: "FirstController")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            toDetailPage(row: indexPath.row)
        case 2:
            showAlert()
        default: break
        }
    }
    
    private func toDetailPage(row: Int) {
        
        guard let vc = createController(storyboardName: "AdController") as? AdController else {
            return
        }
        switch row {
        case 0:
            vc.urlString = "LPのリンク"
        case 1:
            vc.urlString = "プライバシーポリシーのリンク"
        case 2:
            vc.urlString = "利用規約のリンク"
        case 3:
            vc.urlString = "お問い合わせのリンク"
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "本当にログアウトしますか？",
            message: "",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ログアウト", style: .default, handler: {
            (_: UIAlertAction!) -> Void in
            self.repository.logout()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (_: UIAlertAction!) -> Void in }))
        self.present(alert, animated: true, completion: nil)
    }
}
