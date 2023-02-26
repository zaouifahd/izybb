//
//  UpgradeAccountVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import PassKit
import Async
import StoreKit
import QuickDateSDK
import Razorpay
//import SecurionPay

struct UpgradeDataSetClass{
    var planName:String?
    var planMoney:String?
    var planTyle:String?
    var planColor:UIColor?
    
}

struct PayingInformation {
    let payType: String
    let amount: Int
    let description: String
    let memberShipType: Int
    let credits: Int
}

protocol MoveToPayScreenDelegate {
    //    func moveToPayScreen(status:Bool,payType:String?,amount:Int,description:String,membershipType:Int?,credits:Int?)
    func moveToPayScreen(status: Bool, payingInfo: PayingInformation)
    func moveToAuthorizeNetPayScreen(status: Bool, payingInfo: PayingInformation)
}

/// - Tag: UpgradeAccountVC
class UpgradeAccountVC: BaseViewController , SKPaymentTransactionObserver{
    
    
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var moreSticket: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var activatingLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var likeNotification: UILabel!
    
    @IBOutlet weak var tableViewList: UITableView!
    
    @IBOutlet weak var findPotentialMatchesLbl: UILabel!
    @IBOutlet weak var createUnlimitedVideoPLabel: UILabel!
    @IBOutlet weak var displayFirstLabel: UILabel!
    @IBOutlet weak var getDiscountLabel: UILabel!
    @IBOutlet weak var constrintTableViewListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSet = [UpgradeDataSetClass()]
    
    var delegate:MoveToPayScreenDelegate?
    var paymentDelegate : didSelectPaymentDelegate?
    var paymentRequest: PKPaymentRequest!
    var superVC: UIViewController?
//    var braintree: BTAPIClient?
//    var braintreeClient: BTAPIClient?
    
    var transactionId = ""
    var status = ""
    var amount = 100
    
    let PurchaseID = "001"
    var razorpay: RazorpayCheckout!
    var razorpayAmount: String?
    
   var RAZOR_KEY_ID  = "rzp_test_ruzI7R7AkonOIi"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        SKPaymentQueue.default().add(self)
        RAZOR_KEY_ID = AppInstance.shared.adminAllSettings?.data?.razorpayKeyId ?? "rzp_test_ruzI7R7AkonOIi"
        razorpay = RazorpayCheckout.initWithKey(RAZOR_KEY_ID, andDelegate: self)
        razorpay.setExternalWalletSelectionDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        hideTabBar()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            if transaction.transactionState == .purchased{
                //if Bought
                print("transaction is successful!")
                
            }else if transaction.transactionState == .failed{
                //if Not Bought
                print("transaction has falied!")
            }else{
                print("unknown!")
            }
        }
    }
    
    
    private func setupUI(){
        viewDetails.cornerRadiusV = 20
        self.upgradeLabel.text = NSLocalizedString("Upgrade To Premium", comment: "Upgrade To Premium")
        self.activatingLabel.text = NSLocalizedString("Activating Premium will help you meet more people, faster.", comment: "Activating Premium will help you meet more people, faster.")
        self.moreSticket.text = NSLocalizedString("See more stickers on chat.", comment: "See more stickers on chat")
        self.premiumLabel.text = NSLocalizedString("Show in Premium bar", comment: "Show in Premium bar")
        self.likeNotification.text = NSLocalizedString("See likes notifications", comment: "See likes notifications")
        self.premiumLabel.text = NSLocalizedString("Show in Premium bar", comment: "Show in Premium bar")
        self.getDiscountLabel.text = NSLocalizedString("Get discount when buy boost me", comment: "Get discount when buy boost me")
        self.displayFirstLabel.text = NSLocalizedString("Display first in find matches", comment: "Display first in find matches")
        self.createUnlimitedVideoPLabel.text = NSLocalizedString("Create unlimited video and audio calls", comment: "Create unlimited video and audio calls")
        self.findPotentialMatchesLbl.text = NSLocalizedString("Find potential matches by country", comment: "Find potential matches by country")
        self.skipBtn.setTitle(NSLocalizedString("Skip Premium", comment: "Skip Premium"), for: .normal)
        
        self.paymentDelegate = self
        
//        collectionView.register(R.nib.upgradeAccountCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.upgradeAccountCollectionItem.identifier)
        
        let XIB = UINib(nibName: "UpgradeAccountCollectionItem", bundle: nil)
        collectionView.register(XIB, forCellWithReuseIdentifier: R.reuseIdentifier.upgradeAccountCollectionItem.identifier)
        self.dataSet = [
            UpgradeDataSetClass(planName: "Weekly", planMoney: "\(AppInstance.shared.adminAllSettings?.data?.weeklyProPlan ?? "8") \(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")", planTyle: "Normal", planColor: UIColor.hexStringToUIColor(hex: "912F86")),
            UpgradeDataSetClass(planName: "Monthly", planMoney: "\(AppInstance.shared.adminAllSettings?.data?.monthlyProPlan ?? "25") \(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")", planTyle: "Save 51%", planColor: UIColor.hexStringToUIColor(hex: "F3CE80")),
            UpgradeDataSetClass(planName: "Yearly", planMoney: "\(AppInstance.shared.adminAllSettings?.data?.yearlyProPlan ?? "280") \(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")", planTyle: "Save 90%", planColor: UIColor.hexStringToUIColor(hex: "B11B42")),
            UpgradeDataSetClass(planName: "Lifetime", planMoney: "\(AppInstance.shared.adminAllSettings?.data?.lifetimeProPlan ?? "500") \(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")", planTyle: "Pay ones access for ever", planColor: UIColor.hexStringToUIColor(hex: "77A6EE")),
        ]
        self.setupTableView()
    }
    
    private func setupTableView() {
        tableViewList.delegate = self
        tableViewList.dataSource = self
        tableViewList.register(UINib(nibName: "UpgradCellTableViewCell", bundle: nil), forCellReuseIdentifier: "UpgradCellTableViewCell")
        tableViewList.reloadData()
        constrintTableViewListHeight.constant = CGFloat(90 * dataSet.count)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onBtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func selectPayment(Index:Int){
        let viewController = PaymentOpetionViewController
            .instantiate(fromStoryboardNamed: .credit)
        
        viewController.onPaymnetClick = { [weak self] (paymnetOption) -> Void in
            guard let self = self else { return }
            switch paymnetOption {
                
            case .paypal:
                self.paymentDelegate?.selectPayment(status: true, type: "Paypal", Index: Index, PaypalCredit: self.dataSet[Index].planMoney?.toInt())
            case .creditCard:
                self.dismiss(animated: true, completion: nil)
                self.paymentDelegate?.selectPayment(status: true, type: "creditCard", Index: Index, PaypalCredit: nil)
            case .bank:
                self.dismiss(animated: true, completion: nil)
                self.paymentDelegate?.selectPayment(status: false, type: "bankTransfer", Index: Index, PaypalCredit: nil)
            case .razorPay:
                self.razorPayAction(index: Index)
                break
            case .securionPay:
                self.didTapPaymentButton()
                break
            case .authorizeNet:
                self.authorizeNetPayAction(index: Index)
                break
            case .iyziPay:
                self.createIyzipaySession(index: Index)
                break
            }
        }
        self.present(viewController, animated: true, completion: nil)
        
        //
        //
        //        let alert = UIAlertController(title: NSLocalizedString("Select Payment", comment: "Select Payment"), message: "", preferredStyle: .actionSheet)
        //        let payPal = UIAlertAction(title:NSLocalizedString("Paypal", comment: "Paypal"), style: .default) { (action) in
        //            self.paymentDelegate?.selectPayment(status: true, type: "Paypal", Index: Index, PaypalCredit: self.dataSet[Index].planMoney?.toInt())
        //        }
        //        let creditCard = UIAlertAction(title:NSLocalizedString("Credit Card", comment: "Credit Card") , style: .default) { (action) in
        //
        //            self.paymentDelegate?.selectPayment(status: true, type: "creditCard", Index: Index, PaypalCredit: nil)
        //
        //        }
        //        let bankTransfer = UIAlertAction(title: NSLocalizedString("Bank Transfer", comment: "Bank Transfer"), style: .default) { (action) in
        //
        //            self.paymentDelegate?.selectPayment(status: false, type: "bankTransfer", Index: Index, PaypalCredit: nil)
        //
        //
        //        }
        //
        //        let applePay = UIAlertAction(title: "Apple Pay", style: .default) { (action) in
        //            //               self.paymentDelegate?.selectPayment(status: false, type: "applePay", Index:Index, PaypalCredit: nil)
        //            if SKPaymentQueue.canMakePayments(){
        //                let transavtionRequest = SKMutablePayment()
        //                transavtionRequest.productIdentifier = self.PurchaseID
        //                SKPaymentQueue.default().add(transavtionRequest)
        //            }else{
        //
        //                print("This user can not make transaction!")
        //            }
        //        }
        //        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive) { (action) in
        //
        //        }
        //        alert.addAction(payPal)
        //        alert.addAction(creditCard)
        //        alert.addAction(bankTransfer)
        ////        alert.addAction(applePay)
        //        alert.addAction(cancel)
        //        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createIyzipaySession(index: Int) {
        
        let description: String =
        index == 0 ? "Weekly" :  index ==  1 ? "Monthly" : index ==  2 ? "Yearly" : "Lifetime"
        let week = Int(AppInstance.shared.adminAllSettings?.data?.weeklyProPlan ?? "8") ?? 8
        let monthly = Int(AppInstance.shared.adminAllSettings?.data?.monthlyProPlan ?? "25") ?? 25
        let yearly = Int(AppInstance.shared.adminAllSettings?.data?.yearlyProPlan ?? "280") ?? 280
        let lifetime = Int(AppInstance.shared.adminAllSettings?.data?.lifetimeProPlan ?? "500") ?? 500
        
        let amount: Int = index == 0 ? week :  index ==  1 ? monthly : index ==  2 ? yearly : lifetime
        
        let options = [
            "access_token" : AppInstance.shared.accessToken ?? "",
            "price" : amount
        ] as [String : Any]
        
        PaymentManager.instance.iyzipayCreateSession(params: options) { stHtmlText, error in
            guard error == nil else {
                self.displayDefaultAlert(title:NSLocalizedString("Error", comment: "Error"), message: error ?? "Error")
                return
            }
            self.displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: stHtmlText)
        }
    }
    
    func didTapPaymentButton() {
      
    }
//        SecurionPay.shared.publicKey = "pk_test_3fpxbjAZDQwcL1TG7c8KA1MH"
//        SecurionPay.shared.bundleIdentifier = "com.nazmiyavuz.app.ios.app"
//        SecurionPay.shared.showCheckoutViewController(
//            in: self,
//            checkoutRequest: CheckoutRequest(content: "OWE1ZjY0MTBhZjQ0NGJjNjQ4MzBkNGI1MjM3YWU3NzQ3OTU5NmY0ODcyZTc0MzQzMjZiNmY1YTUxMTQ1OWVjMHx7ImNoYXJnZSI6eyJhbW91bnQiOjUwMDAsImN1cnJlbmN5IjoiVVNEIiwibWV0YWRhdGEiOnsidXNlcl9rZXkiOiI5NjE5OTQ3NjMiLCJ0eXBlIjoiY3JlZGl0In19fQ==")) { [weak self] result, error in
//                if let result = result {
//                    let alert = UIAlertController(title: "Payment succeeded!", message: "Charge id: \(result.chargeId ?? "-")\nSubscription id: \(result.subscriptionId ?? "-")", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//                } else if let error = error {
//                    let alert = UIAlertController(title: "Error!", message: error.localizedMessage(), preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//                } else {
//                    let alert = UIAlertController(title: "Payment cancelled!", message: "Try again", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//                }
//            }
//    }
    
    func authorizeNetPayAction(index: Int) {
        let description: String =
        index == 0 ? "Weekly" :  index ==  1 ? "Monthly" : index ==  2 ? "Yearly" : "Lifetime"
        let week = Int(AppInstance.shared.adminAllSettings?.data?.weeklyProPlan ?? "8") ?? 8
        let monthly = Int(AppInstance.shared.adminAllSettings?.data?.monthlyProPlan ?? "25") ?? 25
        let yearly = Int(AppInstance.shared.adminAllSettings?.data?.yearlyProPlan ?? "280") ?? 280
        let lifetime = Int(AppInstance.shared.adminAllSettings?.data?.lifetimeProPlan ?? "500") ?? 500
        
        let amount: Int = index == 0 ? week :  index ==  1 ? monthly : index ==  2 ? yearly : lifetime
        //razorpayAmount = "\(amount)"
        let options = [
            "amount" : amount * 100,
            "currency" : "INR",
            "description" : "Booking For: \(description)",
            "image" : UIImage(named: "ic_boost_edit_profile") ?? UIImage(),
            "name" : "QuickDate",
            "prefill" :
                ["email" : "", "contact": ""],
            "theme" : ["color" : "#24ABEB"]
        ] as [String : Any]
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
      //  self.razorpay.open(options, displayController:  appDelegate.window?.rootViewController ?? self)
        
        let payInfo = PayingInformation(
            payType: "membership", amount: amount, description: description,
            memberShipType: index + 1, credits: 0)
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                self.delegate?.moveToAuthorizeNetPayScreen(status: true, payingInfo: payInfo)
            }
        }
    }
    
    func razorPayAction(index: Int) {
        let description: String =
        index == 0 ? "Weekly" :  index ==  1 ? "Monthly" : index ==  2 ? "Yearly" : "Lifetime"
        let week = Int(AppInstance.shared.adminAllSettings?.data?.weeklyProPlan ?? "8") ?? 8
        let monthly = Int(AppInstance.shared.adminAllSettings?.data?.monthlyProPlan ?? "25") ?? 25
        let yearly = Int(AppInstance.shared.adminAllSettings?.data?.yearlyProPlan ?? "280") ?? 280
        let lifetime = Int(AppInstance.shared.adminAllSettings?.data?.lifetimeProPlan ?? "500") ?? 500
        
        let amount: Int = index == 0 ? week :  index ==  1 ? monthly : index ==  2 ? yearly : lifetime
        razorpayAmount = "\(amount)"
        let options = [
            "amount" : amount * 100,
            "currency" : "INR",
            "description" : "Booking For: \(description)",
            "image" : UIImage(named: "ic_boost_edit_profile") ?? UIImage(),
            "name" : "QuickDate",
            "prefill" :
                ["email" : "", "contact": ""],
            "theme" : ["color" : "#24ABEB"]
        ] as [String : Any]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.razorpay.open(options, displayController:  appDelegate.window?.rootViewController ?? self)
    }
    
    func startCheckout(amount:Int,memberShipType:Int) {
//        braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
//        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
//        payPalDriver.viewControllerPresentingDelegate = self
//        payPalDriver.appSwitchDelegate = self // Optional
//
//        let request = BTPayPalRequest(amount: "\(amount ?? 0)")
//        request.currencyCode = AppInstance.shared.adminAllSettings?.data?.paypalCurrency ?? "USD" // Optional; see BTPayPalRequest.h for more options
//        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
//            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
//                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
//
//                let email = tokenizedPayPalAccount.email
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddress
//
//
//                self.setPro(through: "paypal", amount: amount, memberShipType: memberShipType)
//
//            } else if let error = error {
//                Logger.verbose("error = \(error.localizedDescription ?? "")")
//            } else {
//                Logger.verbose("error = \(error?.localizedDescription ?? "")")
//            }
//        }
    }
    private func setPro(through:String,amount: Int, memberShipType: Int){
        
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            let amountInt = amount ?? 0
            let membershipTypeInt = memberShipType ?? 0
            
            Async.background({
                SetProManager.instance.setPro(AccessToken: accessToken, Type: membershipTypeInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
}
extension UpgradeAccountVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.upgradeAccountCollectionItem.identifier, for: indexPath) as? UpgradeAccountCollectionItem
        cell?.vc = self
        let object = self.dataSet[indexPath.row]
        cell?.bind(object)
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectPayment(Index: indexPath.row)
        if indexPath.row == 0{
            
        }
    }
    
}

extension UpgradeAccountVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSet.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradCellTableViewCell", for: indexPath) as? UpgradCellTableViewCell else { return UITableViewCell.init() }
        cell.vc = self
        let object = self.dataSet[indexPath.row]
        cell.bind(object)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectPayment(Index: indexPath.row)
        if indexPath.row == 0{
            
        }
    }
    
}

extension UpgradeAccountVC: didSelectPaymentDelegate {
    
    func selectPayment(status: Bool, type: String, Index: Int,PaypalCredit:Int?) {
        let description: String =
        Index == 0 ? "Weekly" :  Index ==  1 ? "Monthly" : Index ==  2 ? "Yearly" : "Lifetime"
        let week = Int(AppInstance.shared.adminAllSettings?.data?.weeklyProPlan ?? "8") ?? 8
        let monthly = Int(AppInstance.shared.adminAllSettings?.data?.monthlyProPlan ?? "25") ?? 25
        let yearly = Int(AppInstance.shared.adminAllSettings?.data?.yearlyProPlan ?? "280") ?? 280
        let lifetime = Int(AppInstance.shared.adminAllSettings?.data?.lifetimeProPlan ?? "500") ?? 500
        
        let amount: Int = Index == 0 ? week :  Index ==  1 ? monthly : Index ==  2 ? yearly : lifetime
        
        if type == "creditCard" || type == "bankTransfer" {
            
            let status: Bool = type == "creditCard" ? true : false
            
            let payInfo = PayingInformation(
                payType: "membership", amount: amount, description: description,
                memberShipType: Index + 1, credits: 0)
            self.dismiss(animated: true) {
                self.delegate?.moveToPayScreen(status: status, payingInfo: payInfo)
            }
            
            
        } else if type == "applePay" {
            self.dismiss(animated: true) {
                self.setupApplePay(description: description, amount: amount)
            }
            
            
        } else  if type == "Paypal" {
            self.dismiss(animated: true) {
                self.startCheckout(amount: amount, memberShipType: Index + 1)
            }
        }
    }
    
    func setupApplePay(description: String, amount: Int) {
        paymentRequest = PKPaymentRequest()
        paymentRequest.currencyCode = "USD"
        paymentRequest.countryCode = "US"
        paymentRequest.merchantIdentifier = "merchant.com.ScriptSun.QuickDateiOS.App"
        // Payment networks array
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        paymentRequest.supportedNetworks = paymentNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        let item = PKPaymentSummaryItem(label: "Order Total", amount: NSDecimalNumber(string: "\(amount)"))
        paymentRequest.paymentSummaryItems = [item]
        let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        applePayVC!.delegate = self
        self.present(applePayVC!, animated: true, completion: nil)
        
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension UpgradeAccountVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("The Apple Pay transaction was complete.", comment: "The Apple Pay transaction was complete."))
    }
}

//extension UpgradeAccountVC:BTAppSwitchDelegate, BTViewControllerPresentingDelegate{
//    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
//        self.showProgressDialog(with: "Loading...")
//    }
//    
//    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
//        Logger.verbose("Switched")
//    }
//    
//    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
//        self.dismissProgressDialog {
//            Logger.verbose("Switched")
//        }
//    }
//    
//    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
//        present(viewController, animated: true, completion: nil)
//    }
//    
//    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//}


extension UpgradeAccountVC: RazorpayResultProtocol,RazorpayPaymentCompletionProtocol, ExternalWalletSelectionProtocol{
    func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
    }
    
    func onComplete(response: [AnyHashable : Any]) {
        print("onComplete \(response)")
        if let razorpay_payment_id = response["razorpay_payment_id"] as? String, let accessToken = AppInstance.shared.accessToken, let amount = razorpayAmount {
            PaymentManager.instance.razorPaySuccess(AccessToken: accessToken, payment_id: razorpay_payment_id, merchant_amount: amount) { json, error in
                self.razorpayAmount = nil
                guard error == nil else {
                    self.displayDefaultAlert(title:NSLocalizedString("Error", comment: "Error"), message: error ?? "Error")
                    return
                }
                self.displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("The RazorPay transaction was complete.", comment: "The RazorPay transaction was complete"))
            }
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("onPaymentSuccess \(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("onPaymentSuccess \(payment_id)")
    }
}
