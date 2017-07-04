//
//  SplashViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 03/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import PromiseKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        
        firstly {
            UserSession.shared.sessionContext.recoverToken()
        }.then { lastToken -> Void in
            UserSession.shared.sessionContext.changeStateToLogged(
                sessionToken: lastToken,
                storeToken: false
            )
            
            self.changeRootViewController(toInitialAtStoryboard: "SideMenuBased")
        }.catch { _ in
            self.changeRootViewController(toInitialAtStoryboard: "Authentication")
        }
    }
}
