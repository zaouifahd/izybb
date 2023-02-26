

import UIKit

class SelectPaymentVC: UIViewController {
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var bankTransferBtn: UIButton!
    @IBOutlet weak var creditCardBtn: UIButton!
    var delegate : didSelectPaymentDelegate?
    var index:Int? = 0
    var paymentStatus:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if paymentStatus ?? false{
            self.creditCardBtn.isHidden = true
            self.bankTransferBtn.isHidden = true
            self.applePayBtn.isHidden = false
            
        }else{
            self.creditCardBtn.isHidden = false
            self.bankTransferBtn.isHidden = false
            self.applePayBtn.isHidden = true
        }
        
    }
    
    @IBAction func creditCardPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.selectPayment(status: true, type: "creditCard", Index: self.index ?? 0, PaypalCredit: nil)
        }
    }
    
    @IBAction func bankTransferPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.selectPayment(status: false, type: "bankTransfer", Index: self.index ?? 0, PaypalCredit: nil)
        }
    }
    @IBAction func applePaypressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.selectPayment(status: false, type: "applePay", Index: self.index ?? 0, PaypalCredit: nil)
        }
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
