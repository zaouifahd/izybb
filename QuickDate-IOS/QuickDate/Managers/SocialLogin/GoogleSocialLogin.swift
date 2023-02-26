//
//  GoogleSocialLogin.swift
//  QuickDate
//
//  Created by iMac on 03/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

typealias blockCompletedWithStatus = (String) -> Void

class GoogleSocialLogin {
    static let shared = GoogleSocialLogin()
    
    
    func googleLogin(vc: UIViewController, blockCompletedWithStatus: @escaping blockCompletedWithStatus) {
        let signInConfig = GIDConfiguration(clientID: ControlSettings.googleClientKey)
        GIDSignIn.sharedInstance.signIn(
            withPresenting: vc)  { signInResult, error in
                guard error != nil else {
                    // Inspect error
                    print("\(error?.localizedDescription ?? "")")
                    return
                }
                blockCompletedWithStatus(signInResult?.user.idToken?.tokenString ?? "")
            }
    }
}
