//
//  OrderQRCodeController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class OrderQRCodeController: UIViewController {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var orderId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注文情報のQRコード"
        setupUI()
    }
    
    private func setupUI() {
        
        orderIdLabel.text = orderId
        
        guard let data = orderId.data(using: .utf8),
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"]),
        let qrOutputImage = qr.outputImage else {return}
        
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qrOutputImage.transformed(by: sizeTransform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(qrImage, from: qrImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgImage)
        qrCodeImageView.image = uiImage
    }
    
}
