

import Foundation
import UIKit

protocol didUpdateSettingsDelegate {
    func updateSettings(searchEngine:Int,randomUser:Int,matchProfile:Int,switch:UISwitch)
}
protocol didUpdateOnlineStatusDelegate {
    func updateOnlineStatus(status:Int,switch:UISwitch)
}

protocol didSelectCountryDelegate {
    func selectCountry(status:Bool,countryString:String)
}


protocol didSelectPaymentDelegate {
    func selectPayment(status:Bool,type:String,Index:Int,PaypalCredit:Int?)
}

protocol ReceiveCallDelegate {
    func receiveCall(status:Bool,profileImage:String,CallId:Int,AccessToken:String,RoomId:String,username:String,isVoice:Bool)
}
protocol selectGenderDelegate {
    func selectGender(type:String, TypeID:[String:String]?,status:Bool?)
}

protocol callReceivedDelegate {
    func callReceived()
}
protocol getAddressDelegate {
    func getAddress(address: String)
}
