//
//  RenewalScanController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import AVFoundation

class RenewalScanController: UIViewController {
    
    @IBOutlet weak var captureView: UIView?
    @IBOutlet weak var orderIdLabel: UILabel!
    
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    private lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()
    
    private lazy var captureOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderIdLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QRコードスキャン"
        callDevicePassStatus()
        setupBarcodeCapture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturePreviewLayer.frame = self.captureView?.bounds ?? .zero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toRenewalAction(_ sender: UIButton) {
        
        guard let vc = createController(storyboardName: "RenewalActionController") as? RenewalActionController, let orderId = orderIdLabel.text else {return}
        if orderId.isEmpty {
            toast(message: "スキャンされていません", callback: {})
            return
        }
        vc.orderId = orderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension RenewalScanController {
    
    fileprivate func setupBarcodeCapture() {
        
        if captureDevice == nil {return}
        do {
            let captureInput = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(captureInput)
            captureSession.addOutput(captureOutput)
            captureOutput.metadataObjectTypes = captureOutput.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.captureView?.bounds ?? .zero
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureView?.layer.addSublayer(capturePreviewLayer)
            captureSession.startRunning()
        } catch let error as NSError {
            toast(message: "スキャン中にエラーが発生", callback: {})
        }
    }
    
    fileprivate func callDevicePassStatus() {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized: print("アクセス許可あり")
        case .restricted: print("ユーザさんがカメラの許可をされていない")
        case .notDetermined: print("まだ許可すら聞いていない")
        case .denied: print("アクセス許可されていない")
        default: print("その他")
        }
    }
    
    fileprivate func convartISBN(value: String) -> String? {
        
        let v = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        guard prefix == 978 || prefix == 979 else { return nil }
        let isbn9: Int64 = (v % 10000000000) / 10
        var sum: Int64 = 0
        var tmpISBN = isbn9
        
        var i = 10
        while i > 0 && tmpISBN > 0 {
            let divisor: Int64 = Int64(pow(10, Double(i - 2)))
            sum += (tmpISBN / divisor) * Int64(i)
            tmpISBN %= divisor
            i -= 1
        }
        
        let checkdigit = 11 - (sum % 11)
        return String(format: "%lld%@", isbn9, (checkdigit == 10) ? "X" : String(format: "%lld", checkdigit % 11))
    }
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension RenewalScanController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        
        var readValue: String?
        for mo in metadataObjects {
            guard capturePreviewLayer.transformedMetadataObject(for: mo) is AVMetadataMachineReadableCodeObject else { continue }
            guard let metaData = mo as? AVMetadataMachineReadableCodeObject,
                let _readValue = metaData.stringValue else {break}
            readValue = _readValue
        }
        guard let readV = readValue else {
            toast(message: "読み込み失敗", callback: {})
            return
        }
        captureSession.startRunning()
        orderIdLabel.text = readV
    }
}
