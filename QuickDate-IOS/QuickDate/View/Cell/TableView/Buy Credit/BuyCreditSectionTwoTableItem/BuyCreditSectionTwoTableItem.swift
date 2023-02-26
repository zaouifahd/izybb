//
//  BuyCreditSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
var dataSetTwoArray = [dataSetTwo]()
class BuyCreditSectionTwoTableItem: UITableViewCell {
    
    @IBOutlet weak var buyCreditLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var vc:BuyCreditVC?
    var paymentDelegate : didSelectPaymentDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    private func setupUI(){
        self.buyCreditLabel.text = NSLocalizedString("Buy Credit", comment: "Buy Credit")
        dataSetTwoArray = [
            dataSetTwo(title: NSLocalizedString("Bag of Credits", comment: "Bag of Credits"), Credit: "1000", itemImage: UIImage(named: "ic_bag_ofcredits"), ammount: "50 $"),
            dataSetTwo(title:NSLocalizedString("Box of Credits", comment: "Box of Credits") , Credit: "5000", itemImage: UIImage(named: "ic_box_of_credits"), ammount: "100 $"),
            dataSetTwo(title:NSLocalizedString("Chest of Credits", comment: "Chest of Credits") , Credit: "10000", itemImage: UIImage(named: "ic_chest_of_credits"), ammount: "150 $")
        ]                
        
        let XIB = UINib(nibName: "BuyCreditSectionTwoCollectionItem", bundle: nil)
        collectionView.register(XIB, forCellWithReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoCollectionItem.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func selectPayment(Index:Int){
        let alert = UIAlertController(title: NSLocalizedString("Select Payment", comment: "Select Payment"), message: "", preferredStyle: .actionSheet)
        let payPal = UIAlertAction(title: NSLocalizedString("Paypal", comment: "Paypal"), style: .default) { (action) in
            self.paymentDelegate?.selectPayment(status: true, type: "Paypal", Index: Index, PaypalCredit: dataSetTwoArray[Index].ammount?.toInt())
        }
        let creditCard = UIAlertAction(title:NSLocalizedString("Credit Card", comment: "Credit Card") , style: .default) { (action) in
            self.paymentDelegate?.selectPayment(status: true, type: "creditCard", Index: Index, PaypalCredit: nil)
        }
        let bankTransfer = UIAlertAction(title: NSLocalizedString("Bank Transfer", comment: "Bank Transfer"), style: .default) { (action) in
            self.paymentDelegate?.selectPayment(status: false, type: "bankTransfer", Index: Index, PaypalCredit: nil)
        }
        
        let applePay = UIAlertAction(title: "Apple Pay", style: .default) { (action) in
            self.paymentDelegate?.selectPayment(status: false, type: "applePay", Index:Index, PaypalCredit: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        alert.addAction(payPal)
        alert.addAction(creditCard)
        alert.addAction(bankTransfer)
        alert.addAction(applePay)
        alert.addAction(cancel)
        self.vc?.present(alert, animated: true, completion: nil)
        
    }
}
extension BuyCreditSectionTwoTableItem:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSetTwoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoCollectionItem.identifier, for: indexPath) as? BuyCreditSectionTwoCollectionItem
        let object = dataSetTwoArray[indexPath.row]
        cell!.bind(object)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectPayment(Index: indexPath.row)
    }
    
}
extension BuyCreditSectionTwoTableItem: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 99)
        //return CGSize(width: 195.0, height: 201.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}
