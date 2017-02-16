//
//  MainViewController.swift
//  testGrid
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import PusherSwift

fileprivate var counter = 0
fileprivate let gridConfiguration = GridConfiguration.shared

class MainViewController: UICollectionViewController {
    
    //let pusher = Pusher(key: "767b37910219fd5fe893")
    let pusher = Pusher(key: "5cdc3c711f606f43aada")
    
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
        
        //
        self.view.backgroundColor = UIColor.backgroundAbove
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridConfiguration.slots[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get slot in grid config
        let slot = gridConfiguration.slots[indexPath.section][indexPath.row]
        
        // start cell
        let cellClassName = "\(type(of: slot.cell))"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassName, for: indexPath)
        (cell as! SlotableCell).load(params: slot.params)
        
        // start websocket
        if let webSocketConfig = slot.webSocketConfig {
            let channel = pusher.subscribe(webSocketConfig.channel)
            let _ = channel.bind(eventName: webSocketConfig.event, callback: (cell as! SubscriberCell).getHandle(event: webSocketConfig.event))
            
            pusher.connect()
        }
        
        //
        cell.backgroundColor = UIColor.backgroundCell
        cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98) // TODO: Gambiarra! Isso não deve ficar aqui, mas sim em SlotableCellDefault
        
        return cell
    }
    
    // Focus
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainViewController: GridLayoutDelegate {
    
    func cellSlotSize(section: Int, row: Int) -> (width: Int, height: Int) {
        let slotCell = gridConfiguration.slots[section][row].cell
        
        return (slotCell.slotWidth, slotCell.slotHeight)
    }
}
