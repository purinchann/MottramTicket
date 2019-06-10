//
//  RenewalActionController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class RenewalActionController: UIViewController {
    
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var inductionLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    private let repository = RenewalActionRepository()
    private let disposeBag = DisposeBag()
    
    var orderId: String = ""
    fileprivate var updateOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUseCase()
        if !orderId.isEmpty {
            repository.fetchOrder(orderId: orderId)
        }
    }
    
    private func bindUseCase() {
        
        repository.oderAndShopPair.asObservable().bind{[weak self ] pair in
            guard let `self` = self, let _pair = pair else {return}
            self.loadData(_pair.order, _pair.shop)
        }.disposed(by: disposeBag)
        
        repository.isUpdateResult.asObservable().bind{[weak self] isResult in
            guard let `self` = self, let _ = isResult else {return}
            self.toast(message: "注文を更新しました", callback: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }.disposed(by: disposeBag)
    }
    
    private func loadData(_ order: Order, _ shop: Shop) {
        
        self.updateOrder = order
        
        orderIdLabel.text = order.id ?? ""
        orderNameLabel.text = order.orderName ?? ""
        sizeLabel.text = "\(order.size ?? "") サイズ"
        priceLabel.text = "\(order.price ?? 0) 円"
        
        guard let orderTimeStr = order.orderTime else {return}
        let date = DateUtil().stringToDate("yyyyMMddHHmm", dateStr: orderTimeStr)
        orderTimeLabel.text = date.convertFormat("MM月dd日 HH時mm分")
        
        guard let orderType = getOrderStatusType(order) else {return}
        
        orderType.setTitleLabel(titileLabel)
        orderType.setInductionLabel(inductionLabel, shop, order)
        orderType.buttonHidden(updateButton)
    }
    
    private func getOrderStatusType(_ order: Order) -> OrderStatusType? {
        
        guard let isPaid = order.isPaid,let isMake = order.isMake, let isComplete = order.isComplete, let isCancel = order.isCancel else {
            return nil
        }
        
        if (!isPaid && !isMake && !isComplete && !isCancel) {
            // 未支払い
            return OrderStatusType(rawValue: 0)
        }
        else if (isPaid && !isMake && !isComplete && !isCancel) {
            // 並び中
            return OrderStatusType(rawValue: 1)
        }
        else if (isPaid && isMake && !isComplete && !isCancel) {
            // 受け取り待ち
            return OrderStatusType(rawValue: 2)
        }
        else if (isPaid && isMake && isComplete && !isCancel) {
            // 過去の注文
            return OrderStatusType(rawValue: 3)
        }
        else if isCancel {
            return OrderStatusType(rawValue: 4)
        } else {
            return OrderStatusType(rawValue: 5)
        }
    }
    
    @IBAction func tapOnUpdate(_ sender: UIButton) {
        
        if orderId.isEmpty {
            toast(message: "この注文は更新できません", callback: {})
            return
        }
        guard let order = self.updateOrder,
            let orderType = getOrderStatusType(order),
            let params = orderType.createParameter(order) else {
            toast(message: "この注文は更新できません", callback: {})
            return
        }
        repository.updateOrder(orderId: orderId, params: params)
    }
}

enum OrderStatusType: Int {
    
    case notPaid = 0
    case notMake
    case notComplete
    case history
    case cancel
    case other
    
    func setTitleLabel(_ label: UILabel) {
        switch self {
        case .notPaid:
            label.text = "未支払いの注文です"
        case .notMake:
            label.text = "並び中/ 作成中の注文です"
        case .notComplete:
            label.text = "お客さんの受け取り待ち注文です"
        case .history:
            label.text = "過去の注文です"
        case .cancel:
            label.text = "キャンセルされた注文です"
        default:
            label.text = "不明な注文です"
        }
    }
    
    func setInductionLabel(_ label: UILabel, _ shop: Shop, _ order: Order) {
        switch self {
        case .notPaid:
            let fee = shop.fee ?? 500
            let price = order.price ?? 0
            let totalAmount = fee + price
            label.text = "支払い総額は\(totalAmount)円です。\(totalAmount)円を受け取り、更新ボタンを押してください。"
        case .notComplete:
            label.text = "上記の商品を渡して更新ボタンを押してください。"
        default:
            label.text = "この注文は更新対象ではありません。"
        }
    }
    
    func buttonHidden(_ btn: UIButton) {
        switch self {
        case .notPaid, .notComplete:
            btn.isHidden = false
        default:
            btn.isHidden = true
        }
    }
    
    func createParameter(_ order: Order) -> [String: Any]? {
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else {
            return nil
        }
        let timestamp = Int(Date().timeIntervalSince1970)*1000
        let orderTimeStr = Date().convertFormat("yyyyMMddHHmm")
        switch self {
        case .notPaid:
            let params: [String: Any] = [
                "order_time": orderTimeStr,
                "is_paid": true,
                "updated_at": timestamp,
                "paid_user_id": userId
            ]
            return params
        case .notComplete:
            let params: [String: Any] = [
                "is_complete": true,
                "updated_at": timestamp,
                "delivered_user_id": userId
            ]
            return params
        default:
            return nil
        }
    }
}
