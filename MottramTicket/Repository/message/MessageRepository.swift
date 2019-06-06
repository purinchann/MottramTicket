//
//  MessageRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class MessageRepository {
    
    var messageList = Variable<[Message]>([])
    var isWatchResult = Variable<Bool?>(nil)
    private let disposeBag = DisposeBag()
    
    func fetchList() {
        
        if let userId = AuthDataStore.shared.currentUser.value?.id {
            MessageDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] messages in
                self?.messageList.value = messages
                }, onError: {[weak self] error in
                    self?.messageList.value = []
                }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        } else {
            //Google処理
            AuthDataStore.shared.user.asObservable().subscribe(onNext: {[weak self] user in
                guard let `self` = self, let userId = user?.id else {
                    return
                }
                MessageDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] messages in
                    self?.messageList.value = messages
                    }, onError: {[weak self] error in
                        self?.messageList.value = []
                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
                }, onError: { _ in
                    self.messageList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
    }
    
    func updateWatch(_ messageId: String) {
        MessageDataStore().updateByIsWatch(id: messageId).subscribe(onNext: {
            [weak self] _ in
            self?.isWatchResult.value = true
            }, onError: {[weak self] _ in
                self?.isWatchResult.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
