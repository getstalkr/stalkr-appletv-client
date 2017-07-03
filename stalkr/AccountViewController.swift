//
//  AccountViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 15
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        UserSession.shared.sessionContext.changeStateToNotLogged(
            removeTokenStored: true
        )
        
        let viewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController()!
        self.present(viewController, animated: true, completion: nil)
    }
    
}
