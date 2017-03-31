//
//  GridViewController.swift
//  testGrid
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import PusherSwift
import SwiftyJSON
import PromiseKit
import Alamofire

fileprivate var counter = 0

class GridViewController: UICollectionViewController {
    
    let pusher = Pusher(key: "5cdc3c711f606f43aada")
    
    var currentProject: Project?
    
    private var _gridConfiguration: GridConfiguration?
    var gridConfiguration: GridConfiguration {
        get {
            return _gridConfiguration!
        }
        set(grid) {
            self._gridConfiguration = grid
            self.reloadGridWithAnimation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gridConfiguration = GridConfiguration(json: "[[]]")
        
        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
        
        // load xibs
        // todas as classes que implementam o protocolo SlotableCell podem ser exibidas na collectionview
        // todos os nibs da collectionview terão como indentifier o mesmo nome da classe que implementa o protocolo SlotableCell
        listAllSlotableCell.forEach { slotableCell in
            collectionView?.register(UINib(nibName: slotableCell.className, bundle: nil),
                                     forCellWithReuseIdentifier: slotableCell.className)
        }
        
        //
        self.view.backgroundColor = UIColor.clear
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gridConfiguration.slots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridConfiguration.slots[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get slot in grid config
        let slot = gridConfiguration.slots[indexPath.section][indexPath.row]
        
        // start cell
        let cellClassName: String
        if gridConfiguration.isZoom {
            cellClassName = "\(type(of: slot.cell))Zoom"
        } else {
            cellClassName = "\(type(of: slot.cell))"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassName, for: indexPath)
        (cell as! SlotableCell).load(params: slot.params)
        
        // start websockets, if need
        if let cellSubscriber = cell as? SubscriberCell {
            cellSubscriber.webSockets.forEach { webSocket in

                // subscribe in channel
                let channelName = webSocket.channel(slot.params)
                let channel = pusher.subscribe(channelName)
                
                // function to converter data "Any?" to "JSON", and pass the current cell
                func wrapper(data: Any?) {
                    let json: JSON
                    if let object = data as? [String : Any],
                        let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
                        json = JSON(data: jsonData)
                    } else {
                        json = JSON(arrayLiteral: [])
                    }
                    
                    (cell as! LoadingViewProtocol).loadingView!.stop() // todo: não sei se aqui é o lugar ideal para interromper a animação de loading
                    (cell as! SubscriberCell).getHandle(event: webSocket.event, cell: cell as! SlotableCell)(json, cell as! SlotableCell)
                }
                
                let _ = channel.bind(eventName: webSocket.event, callback: wrapper)
                
                pusher.connect()
                
                // start websocket on server
                (cell as! LoadingViewProtocol).loadingView!.show(message: "Fetching data...")
                Alamofire.request(
                    webSocket.requestStartUrl,
                    method: .post,
                    parameters: webSocket.requestStartParams(slot.params),
                    encoding: JSONEncoding.default,
                    headers: ["Content-Type": "application/json"]
                ).responseJSON { response in
                    let statusCode = (response.response?.statusCode)!
                    
                    if statusCode != 200 {
                        (cell as! LoadingViewProtocol).loadingView!.error(message: "Something went wrong.\nCheck your connection and reload the app.")
                    }
                }
            }
        }
        
        // create gestures related a zoom
        if gridConfiguration.isZoom {
            let tapZoomOut = UITapGestureRecognizer(target: self, action: #selector(self.zoomOut))
            tapZoomOut.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)];
            cell.addGestureRecognizer(tapZoomOut)
        }
        
        if (cell as! SlotableCell).haveZoom {
            let tapZoomCell = UITapGestureRecognizer(target: self, action: #selector(self.zoomCell))
            tapZoomCell.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)];
            cell.addGestureRecognizer(tapZoomCell)
        }
        
        //
        cell.backgroundColor = UIColor.backgroundCell
        cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98) // TODO: Gambiarra! Isso não deve ficar aqui, mas sim em SlotableCellDefault
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    // Focus
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Reload grid
    func reloadGridWithAnimation() {
        // we need clear cache
        (self.collectionView?.collectionViewLayout as! GridLayout).clearCache()
        
        // reload data with animation
        _ = firstly {
            UIView.promise(animateWithDuration: 0.5, animations: {
                self.collectionView?.alpha = 0
            })
        }.then { _ -> Void in
            self.collectionView?.reloadData()
            _ = UIView.promise(animateWithDuration: 0.5, animations: {
                self.collectionView?.alpha = 1
            })
        }
    }
    
    // Gesture functions
    func zoomCell(_ cell: UICollectionViewCell) {
        if let focusedCell = UIScreen.main.focusedView as? UICollectionViewCell{
            let indexPath = collectionView?.indexPath(for: focusedCell)
            
            self.gridConfiguration = GridConfiguration(zoomAtX: indexPath!.row, y: indexPath!.section, grid: self.gridConfiguration)
        }
    }
    
    func zoomOut() {
        self.gridConfiguration = self.gridConfiguration.gridConfigZoomOut!
    }
}

extension GridViewController: GridLayoutDelegate {
    
    func cellSlotSize(section: Int, row: Int) -> (width: Int, height: Int) {
        let slotCell = gridConfiguration.slots[section][row].cell
        
        return (slotCell.slotWidth, slotCell.slotHeight)
    }
    
    // as funções gridNumberOfRows e gridNumberOfColumns seguem um algoritimo parecido,
    // para computar a quantidade de linhas e colunas, respectivamente, que a grid precisará
    // o algoritimo é o seguinte:
    // 1 - armazenará na variável yOffset o buffer de quantas linhas são necessárias para desenhar a célula da linha atual
    // 2 - em "gridConfiguration.slots.forEach" computaremos linha a linha da grid
    // 3 - em "while yOffset[index] != 0 {" finalizando a computação da linha, então, como já usamos uma linha para desenhar a célula, apagaremos em 1 cada item de yOffset
    func gridNumberOfRows() -> Int {
        var yOffset: [Int] = [Int](repeating: 0, count: 10)
        
        var maxIndex = 0
        gridConfiguration.slots.forEach {
            var index = 0
            $0.forEach {
                while yOffset[index] != 0 {
                    index += 1
                }
                
                yOffset[index] = $0.cell.slotHeight
                if index > maxIndex {
                    maxIndex = index
                }
            }
            index = 0
            
            while yOffset[index] != 0 {
                yOffset[index] -= 1
                index += 1
            }
        }
        
        // a quantidade de linhas necessárias para se desenhar a grid é o quanto sobrou para desenhar a célula (ou seja, yOffset.max) + quantas linhas foram necessárias para desenhar as demais células (gridConfiguration.slots.count)
        return yOffset.max()! + gridConfiguration.slots.count
    }
    
    func gridNumberOfColumns() -> Int {
        var yOffset: [Int] = [Int](repeating: 0, count: 10)
        
        var maxIndex = 0
        gridConfiguration.slots.forEach {
            var index = 0
            $0.forEach {
                while yOffset[index] != 0 {
                    index += 1
                }
                
                for _ in 0..<$0.cell.slotWidth {
                    yOffset[index] = $0.cell.slotHeight
                    index += 1
                }
                if index > maxIndex {
                    maxIndex = index
                }
            }
            index = 0
            
            while yOffset[index] != 0 {
                yOffset[index] -= 1
                index += 1
            }
        }
        
        // a quantidade de colunas necessárias para desenhar a grid é o maior índice necessário que foi usado em yOffset (armazenado em maxIndex)
        return maxIndex
    }
}

extension GridViewController: ProjectViewProtocol {
    
    func didChangeProject(_ project: Project) {
        if project === self.currentProject {
            return
        }
        
        self.currentProject = project
        
        self.gridConfiguration = self.currentProject!.grid
        (self.collectionView?.collectionViewLayout as! GridLayout).clearCache()

    }
}
