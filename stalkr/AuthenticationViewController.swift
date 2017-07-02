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
        setDefaultBackground()
    }
    
    func finishTyping(_ codeInputView: CodeInputView, codeText: String) {
        sendLogin(token: codeText)
    }
    
    enum loginNetworkStatus: String {
        case sendingToken = "Sending token..."
        case loginSuccess = "Login success! Getting projects..."
        case failIncorrectToken = "Fail! Token incorrect."
        case failDashboardJsonMalformatted = "Fail! Dashboard with errors!"
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
            UserSession.shared.sessionContext.changeStateToLogged(
                sessionToken: r.sessionToken,
                storeToken: true
            )
            
            loginNetworkStatus.loginSuccess.updateStatusLabel(self)
            
            let viewController = UIStoryboard(name: "SideMenuBased", bundle: nil).instantiateInitialViewController()!
            self.present(viewController, animated: true, completion: nil)
        
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
