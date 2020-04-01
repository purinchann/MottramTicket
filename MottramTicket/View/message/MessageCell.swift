//
//  MessageCell.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var message: Message? {
        didSet {
            reload()
        }
    }
    
    private func reload() {
        guard let _message = message else { return }
        titleLabel.text = _message.messageText ?? ""
        timestampLabel.text = Date().elapsedTimeStr(unixtime: Int(_message.createdAt ?? 0))
        
        if (_message.isWatch ?? true) {
            backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        }
    }
}
