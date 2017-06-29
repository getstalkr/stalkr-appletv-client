//
//  AuthenticationViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 16/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import TvCodeScreen

class AuthenticationViewController: UIViewController, CodeInputViewDelegate {
    
    @IBOutlet weak var labelLoginNetworkStatus: UILabel!
    @IBOutlet weak var codeInputView: CodeInputView!
    
    override func viewDidLoad() {
        codeInputView.delegate = self
    }
    
    func finishTyping(_ codeInputView: CodeInputView, codeText: String) {
        sendLogin(token: codeText)
    }
    
    enum loginNetworkStatus: String {
        case sendingToken = "Sending token..."
        case success = "Success"
        case failIncorrectToken = "Fail! Token incorrect."
        case failUnknowError = "Fail! Unknow error."
        
        func updateStatusLabel(_ authViewController: AuthenticationViewController) {
            authViewController.labelLoginNetworkStatus.text = self.rawValue
        }
    }
    
    func sendLogin(token: String) {
        
        loginNetworkStatus.sendingToken.updateStatusLabel(self)
        
        firstly {
            LoginTask(loginToken: token).execute()
        }.then { r -> Void in
            globalUserSession.changeStateToLogged(userId: r.userId, userToken: r.sessionToken)
            loginNetworkStatus.success.updateStatusLabel(self)
        }.catch { error in
                
            if let error = error as? LoginTaskErros {
                switch error {
                case .incorrectToken:
                    loginNetworkStatus.failIncorrectToken.updateStatusLabel(self)
                }
                    
            } else {
                loginNetworkStatus.failUnknowError.updateStatusLabel(self)
            }
            
            print("LOGIN ERROR: \(error.localizedDescription)")
        }
    }
}
