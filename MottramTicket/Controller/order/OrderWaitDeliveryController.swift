//
//  OrderWaitDeliveryController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderWaitDeliveryController: UIViewController, OrderListDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    
    var orderList: [Order] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindTable()
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "OrderTableCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func bindTable() {
        
        guard let orderVC = navigationController?.viewControllers.atIndex(0) as? OrderController else {
            return
        }
        orderVC.baseOrderList.asObservable().bind{[weak self] orders in
            guard let `self` = self else {return}
            if orders.isEmpty {return}
            let waitDeliveryOrderList = orders.filter({order in
                return (order.isPaid ?? false) &&
                    (order.isMake ?? false) &&
                    !(order.isComplete ?? false) &&
                    !(order.isCancel ?? false)
                })
            self.orderList = self.sortedByUploadTime(orders: waitDeliveryOrderList)
            }.disposed(by: disposeBag)
    }
}

extension OrderWaitDeliveryController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderTableCell,
            let order = orderList.atIndex(indexPath.row)
            else { return UITableViewCell() }
        cell.order = order
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = orderList.atIndex(indexPath.row),
            let orderId = order.id,
            let vc = createController(storyboardName: "OrderQRCodeController") as? OrderQRCodeController else { return }
        vc.orderId = orderId
        navigationController?.pushViewController(vc, animated: true)

    }
}

