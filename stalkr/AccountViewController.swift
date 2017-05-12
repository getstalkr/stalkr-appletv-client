//
//  AccountViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import InputStepByStep

class AccountViewController: UIViewController, InputStepByStepProtocol {

    @IBOutlet weak var container: InputStepByStep!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 15
    }

    var configList: [CellCreateGrid] = {
        var x: [CellCreateGrid] = []
        
        x.append(.name("Account"))
        x.append(.input(name: "login", label: "Login"))
        x.append(.input(name: "password", label: "Password"))
        
        x.append(.finish())
        
        return x
    }()
    
    func cellFinishAction(inputValues: [String: [String: String]]) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueInputStepByStep" {
            self.container = (segue.destination as! InputStepByStep)
            self.container!.delegate = self
        }
    }

}
