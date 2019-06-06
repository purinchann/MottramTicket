//
//  MessageController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class MessageController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let repository = MessageRepository()
    fileprivate let disposeBag = DisposeBag()
    
    var messageList: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        repository.fetchList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "メッセージ"
        setupTable()
        bindUseCase()
    }
    
    private func setupTable() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    private func bindUseCase() {
        
        repository.messageList.asObservable().bind{[weak self] messages in
            guard let `self` = self else {return}
            if messages.isEmpty {return}
            self.messageList = messages
        }.disposed(by: disposeBag)
        
        repository.isWatchResult.asObservable().bind{[weak self] isRes in
            guard let `self` = self, let _ = isRes else {return}
            self.repository.fetchList()
        }.disposed(by: disposeBag)
    }
}

extension MessageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell,
            let message = messageList.atIndex(indexPath.row) else {return UITableViewCell()}
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        guard let message = self.messageList.atIndex(indexPath.row), let isWatch = message.isWatch else {
            return true
        }
        return !isWatch
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let watchButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "ウォッチする") { (action, index) -> Void in
            guard let message = self.messageList.atIndex(indexPath.row), let messageId = message.id else {
                return
            }
            self.repository.updateWatch(messageId)
        }
        watchButton.backgroundColor = #colorLiteral(red: 0, green: 0.5814838409, blue: 0.6292404532, alpha: 1)
        return [watchButton]
    }
}
