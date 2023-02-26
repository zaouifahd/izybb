//
//  PaymentOpetionViewController.swift
//  QuickDate
//
//  Created by iMac on 13/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class PaymentOpetionViewController: BaseViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewTopLine: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewPaypal: UIView!
    @IBOutlet weak var btnPayPal: UIButton!
    @IBOutlet weak var viewVisaCard: UIView!
    @IBOutlet weak var btnVisaCard: UIButton!
    @IBOutlet weak var viewBank: UIView!
    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var viewRazorPay: UIView!
    @IBOutlet weak var btnRazorPay: UIButton!
    @IBOutlet weak var viewSecurionPay: UIView!
    @IBOutlet weak var btnSecurionPay: UIButton!
    @IBOutlet weak var viewAuthorizeNet: UIView!
    @IBOutlet weak var btnAuthorizeNet: UIButton!
    @IBOutlet weak var viewIyziPay: UIView!
    @IBOutlet weak var btnIyziPay: UIButton!
    @IBOutlet weak var btnCloseView: UIButton!
    
    var paymentName = PaymentName.bank
    var onPaymnetClick: ((PaymentName) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}

//MARK: Custom Method
extension PaymentOpetionViewController {
    private func setupUI() {
        setupUIColor()
        setupUIAction()
    }
    
    private func setupUIColor() {
        viewTopLine.circleView()
        btnSave.circleView()
        btnSave.borderWidthV = 1
        btnSave.isHidden = true
        btnSave.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewPaypal.borderWidthV = 1
        viewPaypal.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewPaypal.cornerRadiusV = 8
        viewVisaCard.borderWidthV = 1
        viewVisaCard.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewVisaCard.cornerRadiusV = 8
        viewBank.borderWidthV = 1
        viewBank.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewBank.cornerRadiusV = 8
        viewSecurionPay.borderWidthV = 1
        viewSecurionPay.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewSecurionPay.circleView()
        viewRazorPay.borderWidthV = 1
        viewRazorPay.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewRazorPay.circleView()
        viewAuthorizeNet.borderWidthV = 1
        viewAuthorizeNet.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewAuthorizeNet.circleView()
        viewIyziPay.borderWidthV = 1
        viewIyziPay.borderColorV = UIColor.hexStringToUIColor(hex: "F5F5F5")
        viewIyziPay.circleView()
    }
    
    private func setupUIAction() {
        btnPayPal.addTarget(self, action: #selector(onBtnPayPal), for: .touchUpInside)
        btnVisaCard.addTarget(self, action: #selector(onBtnCrediCard), for: .touchUpInside)
        btnBank.addTarget(self, action: #selector(onBtnBank), for: .touchUpInside)
        btnRazorPay.addTarget(self, action: #selector(onBtnRazorPay), for: .touchUpInside)
        btnSecurionPay.addTarget(self, action: #selector(onBtnSecurionPay), for: .touchUpInside)
        btnAuthorizeNet.addTarget(self, action: #selector(onBtnAuthorizeNet), for: .touchUpInside)
        btnIyziPay.addTarget(self, action: #selector(onBtnIyziPay), for: .touchUpInside)
        btnCloseView.addTarget(self, action: #selector(onBtnClose), for: .touchUpInside)
    }
}

//MARK: Action
extension PaymentOpetionViewController {
    @objc func onBtnClose() {
        self.dismiss(animated: true)
    }
    @objc func onBtnPayPal() {
        onPaymnetClick?(.paypal)
        onBtnClose()
    }
    
    @objc func onBtnCrediCard() {
        onPaymnetClick?(.creditCard)
        onBtnClose()
    }
    
    @objc func onBtnBank() {
        onPaymnetClick?(.bank)
        onBtnClose()
    }
    
    @objc func onBtnRazorPay() {
        onBtnClose()
        onPaymnetClick?(.razorPay)
        
    }
    
    @objc func onBtnSecurionPay() {
        onPaymnetClick?(.securionPay)
        onBtnClose()
    }
    
    @objc func onBtnAuthorizeNet() {
        onPaymnetClick?(.authorizeNet)
        onBtnClose()
    }
    
    @objc func onBtnIyziPay() {
        onPaymnetClick?(.iyziPay)
        onBtnClose()
    }
}
