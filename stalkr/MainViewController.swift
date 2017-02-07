//
//  MainViewController.swift
//  testGrid
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

fileprivate var counter = 0
fileprivate let gridConfiguration = GridConfiguration.shared

func getRandomColor() -> UIColor{
    let red:CGFloat = CGFloat(drand48())
    let green:CGFloat = CGFloat(drand48())
    let blue:CGFloat = CGFloat(drand48())
    
    return UIColor(red:red, green: green, blue: blue, alpha: 0.5)
}

class MainViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridConfiguration.slots[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let slot = gridConfiguration.slots[indexPath.section][indexPath.row]
        
        // todo: precisa ser mais flexível essa parte de carregar a célula, para quando adicionar numa nova célula não ter que atualizar esse código
        var cell: UICollectionViewCell
        if slot.application is CellPlaceholderSmall {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPlaceholderSmall", for: indexPath)
        } else if slot.application is CellPlaceholderWidthTwo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPlaceholderWidthTwo", for: indexPath)
        } else if slot.application is CellPlaceholderHeightTwo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPlaceholderHeightTwo", for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPlaceholderTwoXTwo", for: indexPath)
        }
        
        (cell as! SlotableCell).load(params: slot.params)
        
        cell.backgroundColor = getRandomColor()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MainViewController: GridLayoutDelegate {
    
    func cellSlotSize(section: Int, row: Int) -> (width: Int, height: Int) {
        let slotApp = gridConfiguration.slots[section][row].application!
        
        return (slotApp.slotWidth, slotApp.slotHeight)
    }
}
