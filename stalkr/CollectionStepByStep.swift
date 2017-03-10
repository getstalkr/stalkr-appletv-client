//
//  CollectionStepByStep
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CellCreateGrid {
    case name(String)
    case input(ConfigInput, cellName: String, currentValue: String) // TODO: Desacoplar lógica do ConfigInput da parte de criar grid para algo genérico
    case finish()
}

protocol CollectionStepByStepProtocol {
    var cellConfigList: [CellCreateGrid] { get set }
    func cellFinishAction()
}

class CollectionStepByStep: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, CollectionStepyByStepLayoutDelegate {

    var delegateStepByStep: CollectionStepByStepProtocol?
    let showInput = ShowInput()
    
    func load() {
        (self.collectionViewLayout as! CollectionStepByStepLayout).delegate = self
        
        self.register(UINib(nibName: "CellCSbSDivision", bundle: nil), forCellWithReuseIdentifier: "CellCSbSDivision")
        self.register(UINib(nibName: "CellCSbSConfigFinish", bundle: nil), forCellWithReuseIdentifier: "CellCSbSConfigFinish")
        self.register(UINib(nibName: "CellCSbSConfigTitle", bundle: nil), forCellWithReuseIdentifier: "CellCSbSConfigTitle")
        self.register(UINib(nibName: "CellCSbSConfigInput", bundle: nil), forCellWithReuseIdentifier: "CellCSbSConfigInput")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegateStepByStep!.cellConfigList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch delegateStepByStep!.cellConfigList[section] {
        case .name(_):
            return 2
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let currentCell = delegateStepByStep!.cellConfigList[indexPath.section]

        if Mirror(reflecting: currentCell).children.first?.label! == "name" && indexPath.item == 0 {
            let cell = self.dequeueReusableCell(withReuseIdentifier: "CellCSbSDivision", for: indexPath) as! CellConfigDivision
            
            cell.startCell()
            
            return cell
        }
        
        switch currentCell {
        case .name(let name):
            let cell = self.dequeueReusableCell(withReuseIdentifier: "CellCSbSConfigTitle", for: indexPath) as! CellConfigTitle
            
            cell.labelTitle.text = name
            
            return cell
        case .input(let input, _, let value):
            let cell = self.dequeueReusableCell(withReuseIdentifier: "CellCSbSConfigInput", for: indexPath) as! CellConfigInput
            // if input.obligatory { ... // TODO: Colocar na UI algo para diferenciar quando o campo é obrigatório/opcional
            
            if value == "" {
                cell.labelField.text = input.label
            } else {
                cell.labelField.text = value
            }
            
            return cell
        case .finish:
            let cell = self.dequeueReusableCell(withReuseIdentifier: "CellCSbSConfigFinish", for: indexPath) as! CellConfigFinish
            
            cell.startCell()
            
            return cell
        }
    }

    // focus
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    // input
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.cellForItem(at: indexPath)
        
        if let cell = cell as? CellConfigInput {
            showInput.callback = { text in
                // TODO: é preciso atualizar o status de "cheio" e "vazio" daquela bolinha da cell step
                cell.labelField.text = text
                
                switch self.delegateStepByStep!.cellConfigList[indexPath.section] {
                case .input(let input, let cellName, _):
                    self.delegateStepByStep!.cellConfigList[indexPath.section] = CellCreateGrid.input(input, cellName: cellName, currentValue: text)
                default:
                    return
                }
            }
            
            showInput.start(view: cell)
            
        } else if ((cell as? CellConfigFinish) != nil) {
            delegateStepByStep!.cellFinishAction()
        }
    }

    // CollectionStepyByStepLayoutDelegate
    func numberOfInputsAtStep(section: Int) -> Int {
        var count = 0
        var sectionCurrent = section + 1
        while delegateStepByStep!.cellConfigList.count != sectionCurrent && Mirror(reflecting: delegateStepByStep!.cellConfigList[sectionCurrent]).children.first?.label! != "name" {
            count += 1
            sectionCurrent += 1
        }
        
        return count
    }
    
    func cellTypeAt(section: Int, row: Int) -> CellStepByStepType {
        let currentCell = delegateStepByStep!.cellConfigList[section]
        
        if Mirror(reflecting: currentCell).children.first?.label! == "name" && row == 0 {
            return .step
        } else {
            switch currentCell {
            case .name:
                return .name
            case .input:
                return .input
            case .finish:
                return .finish
            }
        }
    }
    
}
