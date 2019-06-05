//
//  PurchaseController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class PurchaseController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var refreshControl = UIRefreshControl()
    
    fileprivate let repository = PurchaseRepository()
    fileprivate let disposeBag = DisposeBag()
    
    var orderList: [Order] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "購入リスト"
        setupTableView()
        bindUseCase()
        repository.fetchList()
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "OrderTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.refreshControl.addTarget(self, action: #selector(onRefresh(sender:)), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
    }
    
    private func bindUseCase() {
        
        repository.orderList.asObservable().bind{[weak self] orders in
            guard let `self` = self else {return}
            if orders.isEmpty {return}
            self.refreshControl.endRefreshing()
            self.orderList = orders
        }.disposed(by: disposeBag)
        
        repository.selectIndex.asObservable().bind{[weak self] indexRow in
            guard let `self` = self, let row = indexRow else {return}
            self.toast(message: "購入しました", callback: {
                self.orderList.remove(at: row)
            })
        }.disposed(by: disposeBag)
    }
    
    @objc private func onRefresh(sender: Any) {
        repository.fetchList()
    }
}

extension PurchaseController: UITableViewDelegate, UITableViewDataSource {
    
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
            let order = orderList.atIndex(indexPath.row) else {
                return UITableViewCell()
        }
        cell.order = order
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "購入完了") { (action, index) -> Void in
            guard let order = self.orderList.atIndex(indexPath.row), let orderId = order.id else {
                return
            }
            self.repository.purchaseComplete(orderId: orderId, indexRow: indexPath.row)
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        return [deleteButton]
    }
}

