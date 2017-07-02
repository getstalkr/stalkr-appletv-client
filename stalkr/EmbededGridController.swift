//
//  EmbededGrid.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 29/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import PromiseKit
import TvLightSegments
import GridView

class EmbededGridController: UIViewController {

    @IBOutlet weak var container: UIView!
    var gridView: GridViewController?
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
    
    func setup(cell: SlotableCell, params: [String: Any]) {
        // start websockets, if need
        if var cellSubscriber = cell as? SubscriberCell {
            cellSubscriber.pusher = cellSubscriber.subscriber(
                pusherKey: params["pusher_key"]! as! String,
                params: params
            )
        }
        
        // create gestures related a zoom
        let uiCell = (cell as! UICollectionViewCell)
        
        if gridIsZoom {
            let tapZoomOut = UITapGestureRecognizer(target: self, action: #selector(self.zoomOut))
            tapZoomOut.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)];
            uiCell.addGestureRecognizer(tapZoomOut)
        } else if (type(of: cell) as! StalkrCell.Type).haveZoom {
            let tapZoomCell = UITapGestureRecognizer(target: self, action: #selector(self.zoomCell))
            tapZoomCell.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)];
            uiCell.addGestureRecognizer(tapZoomCell)
        }
        
        //
        uiCell.backgroundColor = UIColor.backgroundCell
        uiCell.layer.cornerRadius = 10
    }
    
    // Gesture functions
    func zoomCell(_ cell: UITapGestureRecognizer) { // todo: talvez eu possa remover esse paraemtro
        if let focusedCell = UIScreen.main.focusedView as? UICollectionViewCell { // todo: talvez usar guard let
            let indexPath = gridView!.collectionView!.indexPath(for: focusedCell)
            
            let zoomCell = NSClassFromString("stalkr." + (type(of: gridView!.collectionView!.cellForItem(at: indexPath!)!).className() + "Zoom"))! as! SlotableCell.Type
            let params = gridView!.getParams(of: focusedCell)
            
            gridIsZoom = true
            gridView!.gridConfiguration = GridConfiguration.create(slots: Slots(slots: [[Slot(cell: zoomCell, params: params)]]))
            reloadGridWithAnimation()
        }
    }
    
    func zoomOut() {
        gridIsZoom = false
        gridView!.gridConfiguration = GridConfiguration.create(slots: self.currentProject!.slots)
        reloadGridWithAnimation()
    }
    
    //
    func gridView(_ gridView: GridViewController, shouldMoveCellAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func gridViewGestureToStartMoveAt(_ gridView: GridViewController) -> UIGestureRecognizer {
        
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 0.75
        return gesture
    }
    
    func gridView(_ gridView: GridViewController, newGridConfiguration: GridConfiguration) {
        
        // todo: in future, remove the "amazing change grid configuration"
        //let indexOfCurrentProjectSelected = UserSession.shared.projects.index(
        //    where: { $0 === currentProject! }
        //)!
        //UserSession.shared.projects[indexOfCurrentProjectSelected].slots = newGridConfiguration.slots
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
        gridView!.gridConfiguration = GridConfiguration.create(slots: currentProject!.slots)
        reloadGridWithAnimation()
    }
    
}
