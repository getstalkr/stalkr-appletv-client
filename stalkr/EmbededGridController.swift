//
//  EmbededGrid.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 29/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftyJSON
import PusherSwift
import Alamofire
import PromiseKit
import TvLightSegments
import GridView

class EmbededGridController: UIViewController {

    @IBOutlet weak var container: UIView!
    var gridView: GridViewController?
    let pusher = Pusher(key: "5cdc3c711f606f43aada")
    var currentProject: Project?
    var gridIsZoom = false // "true" if zooming in cell
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueGrid" {
            self.gridView = (segue.destination as! GridViewController)
            self.gridView!.delegate = self
        }
    }
    
    func reloadGridWithAnimation() {
        // reload data with animation
        _ = firstly {
            UIView.promise(animateWithDuration: 0.5, animations: {
                self.gridView!.view.alpha = 0
            })
        }.then { _ -> Void in
            self.gridView!.reloadGrid()
            _ = UIView.promise(animateWithDuration: 0.5, animations: {
                self.gridView!.view.alpha = 1
            })
        }
    }
}

extension EmbededGridController: GridViewDelegate {
    func getCellToRegister() -> [SlotableCell.Type] {
        return listAllSlotableCell.map { ($0.classObject as! SlotableCell.Type) }
    }
    
    func setup(cell: UICollectionViewCell, params: [String: Any]) {
        // start websockets, if need
        if let cellSubscriber = cell as? SubscriberCell {
            cellSubscriber.webSockets.forEach { webSocket in
                
                // subscribe in channel
                let channelName = webSocket.channel(params)
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
                    parameters: webSocket.requestStartParams(params),
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
        if gridIsZoom {
            let tapZoomOut = UITapGestureRecognizer(target: self, action: #selector(self.zoomOut))
            tapZoomOut.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)];
            cell.addGestureRecognizer(tapZoomOut)
        } else if (type(of: cell) as! StalkrCell.Type).haveZoom {
            let tapZoomCell = UITapGestureRecognizer(target: self, action: #selector(self.zoomCell))
            tapZoomCell.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)];
            cell.addGestureRecognizer(tapZoomCell)
        }
        
        //
        cell.backgroundColor = UIColor.backgroundCell
        cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98) // TODO: Gambiarra! Isso não deve ficar aqui, mas sim em SlotableCellDefault
        cell.layer.cornerRadius = 10
    }
    
    // Gesture functions
    func zoomCell(_ cell: UICollectionViewCell) {
        if let focusedCell = UIScreen.main.focusedView as? UICollectionViewCell {
            let indexPath = gridView!.collectionView!.indexPath(for: focusedCell)
            
            let zoomCell = NSClassFromString("stalkr." + (type(of: gridView!.collectionView!.cellForItem(at: indexPath!)!).className() + "Zoom"))! as! SlotableCell.Type
            let params = (gridView!.gridConfiguration![indexPath!.section][indexPath!.row]).params
            
            gridIsZoom = true
            gridView!.gridConfiguration = [[Slot(cell: zoomCell, params: params)]]
            reloadGridWithAnimation()
        }
    }
    
    func zoomOut() {
        gridIsZoom = false
        gridView!.gridConfiguration = self.currentProject!.slots
        reloadGridWithAnimation()
    }
}

extension EmbededGridController: TvLightSegmentsDisplay {
    
    func didChangeSegment(_ segmentItem: TvLightSegmentsItem) {
        let project = segmentItem as! Project
        
        if project === self.currentProject {
            return
        }
        
        gridIsZoom = false
        currentProject = project
        gridView!.gridConfiguration = currentProject!.slots
        reloadGridWithAnimation()
    }
    
}
