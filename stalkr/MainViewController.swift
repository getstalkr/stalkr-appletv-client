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
        
        // load xibs
        // todas as classes que implementam o protocolo SlotableCell podem ser exibidas na collectionview
        // todos os nibs da collectionview terão como indentifier o mesmo nome da classe que implementa o protocolo SlotableCell
        listAllSlotableCell.forEach { i in
            let stringClassName = i.className()
            collectionView?.register(UINib(nibName: stringClassName, bundle: nil),
                                     forCellWithReuseIdentifier: stringClassName)
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
        
        let cellClassName = "\(type(of: slot.cell))"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassName, for: indexPath)
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
        let slotCell = gridConfiguration.slots[section][row].cell
        
        return (slotCell.slotWidth, slotCell.slotHeight)
    }
}
