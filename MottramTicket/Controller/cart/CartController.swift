//
//  CartController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class CartController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cartList: [Cart] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var shop: Shop?
    
    fileprivate let repository = CartRepository()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        repository.fetchList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "カート"
        setupTableView()
        bindUseCase()
        repository.fetchShop(shopId: "Bhgou5g11hYztxeX2JFz")
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        let xibCell = UINib(nibName: "CartTableCell", bundle: nil)
        tableView.register(xibCell, forCellReuseIdentifier: "cell")
        
        let footer = UINib(nibName: "CartTableFooterView", bundle: nil)
        tableView.register(footer, forHeaderFooterViewReuseIdentifier: "footer")
    }
    
    private func bindUseCase() {
        
        repository.cartList.asObservable().bind{[weak self] carts in
            self?.cartList = carts
        }.disposed(by: disposeBag)
        
        repository.shop.asObservable().bind{ [weak self] value in
            guard let `self` = self, let shop = value else {
                return
            }
            self.shop = shop
            }.disposed(by: disposeBag)
        
        repository.deleteIndex.asObservable().bind{[weak self] indexRow in
            guard let `self` = self, let row = indexRow else {return}
            self.cartList.remove(at: row)
        }.disposed(by: disposeBag)
        
        repository.isCreateOrder.asObservable().bind{[weak self] isResult in
            guard let `self` = self, let isRes = isResult else {return}
            if !isRes {
                self.toast(message: "注文に失敗しました", callback: {})
                return
            }
            self.toOrderPage()
        }.disposed(by: disposeBag)
    }
    
    private func toOrderPage() {
        
        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
            DispatchQueue.main.async {
                tabvc.selectedIndex = 2
            }
        }
        let vc = createController(storyboardName: "OrderController")
        self.tabBarController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableCell,
            let cart = cartList.atIndex(indexPath.row) else {return UITableViewCell()}
        cell.cart = cart
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as? CartTableFooterView else {return UIView()}
        footer.cartList = self.cartList
        footer.fee = self.shop?.fee ?? 500
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 700.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "カートから削除") { (action, index) -> Void in
            guard let cart = self.cartList.atIndex(indexPath.row), let cartId = cart.id else {
                return
            }
            self.repository.deleteCart(cartId: cartId, indexRow: indexPath.row)
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        return [deleteButton]
    }
}

extension CartController: CartTableFooterDelegate {
    
    func createOrderAction() {
        
        if cartList.isEmpty {
            toast(message: "カートに商品がありません", callback: {})
            return
        }
        
        if !Date().isInBusinessHours() {
            toast(message: "注文を受け付けている時間帯は午前11時〜午後18時までです", callback: {})
            return
        }
        
        //TODO: - バリデーションが足りないかも
        
        let lastIndex = cartList.count - 1
        repository.createOrder(cnt: lastIndex, carts: cartList)
    }
}
