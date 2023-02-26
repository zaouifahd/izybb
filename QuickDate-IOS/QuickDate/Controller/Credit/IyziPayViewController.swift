//
//  IyziPayViewController.swift
//  QuickDate
//
//  Created by iMac on 31/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import WebKit

class IyziPayViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.evaluateJavaScript("<script type=\"text/javascript\">if (typeof iyziInit == 'undefined') {var iyziInit = {currency:\"TRY\",token:\"48d70d7d-80c7-4cbd-9439-51d21d83fa9d\",price:50.00,locale:\"tr\",baseUrl:\"https://sandbox-api.iyzipay.com\", merchantGatewayBaseUrl:\"https://sandbox-merchantgw.iyzipay.com\", registerCardEnabled:true,bkmEnabled:true,bankTransferEnabled:false,bankTransferRedirectUrl:\"https://quickdatescript.com/aj/iyzipay/success?hash=YTo3OntzOjY6InVzZXJpZCI7czo2OiIxNzUwOTMiO3M6MTE6ImRlc2NyaXB0aW9uIjtzOjE0OiJ0b3AgdXAgY3JlZGl0cyI7czo5OiJyZWFscHJpY2UiO2k6NTA7czo1OiJwcmljZSI7aTo1MDAwO3M6NjoiYW1vdW50IjtzOjQ6IjEwMDAiO3M6MTQ6Im1lbWJlcnNoaXBUeXBlIjtpOjA7czo4OiJjdXJyZW5jeSI7czoyOiJUTCI7fQ==\",bankTransferCustomUIProps:{},campaignEnabled:false,campaignMarketingUiDisplay:null,paymentSourceName:\"\",plusInstallmentResponseList:null,payWithIyzicoSingleTab:false,payWithIyzicoOneTab:false,creditCardEnabled:true,bankTransferAccounts:[],userCards:[],fundEnabled:true,memberCheckoutOtpData:{},force3Ds:false,isSandbox:true,storeNewCardEnabled:true,paymentWithNewCardEnabled:true,enabledApmTypes:[\"SOFORT\",\"IDEAL\",\"QIWI\",\"GIROPAY\"],payWithIyzicoUsed:false,payWithIyzicoEnabled:true,payWithIyzicoCustomUI:{},buyerName:\"John\",buyerSurname:\"Doe\",merchantInfo:\"\",cancelUrl:\"\",buyerProtectionEnabled:false,hide3DS:false,gsmNumber:\"\",email:\"email@email.com\",checkConsumerDetail:{},subscriptionPaymentEnabled:false,ucsEnabled:false,fingerprintEnabled:false,payWithIyzicoFirstTab:false,creditEnabled:false,metadata : {},createTag:function(){var iyziJSTag = document.createElement('script');iyziJSTag.setAttribute('src','https://sandbox-static.iyzipay.com/checkoutform/v2/bundle.js?v=1667209366421');document.head.appendChild(iyziJSTag);}};iyziInit.createTag();}</script>")
        
        
//        webView.loadHTMLString("<script type=\"text/javascript\">if (typeof iyziInit == 'undefined') {var iyziInit = {currency:\"TRY\",token:\"48d70d7d-80c7-4cbd-9439-51d21d83fa9d\",price:50.00,locale:\"tr\",baseUrl:\"https://sandbox-api.iyzipay.com\", merchantGatewayBaseUrl:\"https://sandbox-merchantgw.iyzipay.com\", registerCardEnabled:true,bkmEnabled:true,bankTransferEnabled:false,bankTransferRedirectUrl:\"https://quickdatescript.com/aj/iyzipay/success?hash=YTo3OntzOjY6InVzZXJpZCI7czo2OiIxNzUwOTMiO3M6MTE6ImRlc2NyaXB0aW9uIjtzOjE0OiJ0b3AgdXAgY3JlZGl0cyI7czo5OiJyZWFscHJpY2UiO2k6NTA7czo1OiJwcmljZSI7aTo1MDAwO3M6NjoiYW1vdW50IjtzOjQ6IjEwMDAiO3M6MTQ6Im1lbWJlcnNoaXBUeXBlIjtpOjA7czo4OiJjdXJyZW5jeSI7czoyOiJUTCI7fQ==\",bankTransferCustomUIProps:{},campaignEnabled:false,campaignMarketingUiDisplay:null,paymentSourceName:\"\",plusInstallmentResponseList:null,payWithIyzicoSingleTab:false,payWithIyzicoOneTab:false,creditCardEnabled:true,bankTransferAccounts:[],userCards:[],fundEnabled:true,memberCheckoutOtpData:{},force3Ds:false,isSandbox:true,storeNewCardEnabled:true,paymentWithNewCardEnabled:true,enabledApmTypes:[\"SOFORT\",\"IDEAL\",\"QIWI\",\"GIROPAY\"],payWithIyzicoUsed:false,payWithIyzicoEnabled:true,payWithIyzicoCustomUI:{},buyerName:\"John\",buyerSurname:\"Doe\",merchantInfo:\"\",cancelUrl:\"\",buyerProtectionEnabled:false,hide3DS:false,gsmNumber:\"\",email:\"email@email.com\",checkConsumerDetail:{},subscriptionPaymentEnabled:false,ucsEnabled:false,fingerprintEnabled:false,payWithIyzicoFirstTab:false,creditEnabled:false,metadata : {},createTag:function(){var iyziJSTag = document.createElement('script');iyziJSTag.setAttribute('src','https://sandbox-static.iyzipay.com/checkoutform/v2/bundle.js?v=1667209366421');document.head.appendChild(iyziJSTag);}};iyziInit.createTag();}</script>", baseURL: URL(string: "https://sandbox-merchantgw.iyzipay.com"))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
}
extension IyziPayViewController {
    @IBAction func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension IyziPayViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showProgressDialog(with: "Loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissProgressDialog {
            Logger.verbose("dismissed")
        }
    }
}
