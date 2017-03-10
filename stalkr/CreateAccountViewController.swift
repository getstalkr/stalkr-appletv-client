//
//  CreateAccountController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CreateAccountViewController: UICollectionViewController, CollectionStepByStepProtocol {

    var cellConfigList: [CellCreateGrid] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (collectionView! as! CollectionStepByStep).delegateStepByStep = self
        (collectionView! as! CollectionStepByStep).load()
        collectionView!.delegate = (collectionView! as! CollectionStepByStep)
        collectionView!.dataSource = (collectionView! as! CollectionStepByStep)
        
        //
        cellConfigList.append(CellCreateGrid.name("Login"))
        cellConfigList.append(CellCreateGrid.input(ConfigInput(name: "login", label: "Login", inputType: .text, obligatory: true), cellName: "", currentValue: ""))
        cellConfigList.append(CellCreateGrid.input(ConfigInput(name: "password", label: "Password", inputType: .text, obligatory: true), cellName: "", currentValue: ""))
        
        cellConfigList.append(CellCreateGrid.finish())
    }
    
    func cellFinishAction() {
        // TODO
        print("creating account...")
    }

}
