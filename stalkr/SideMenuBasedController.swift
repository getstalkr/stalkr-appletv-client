//
//  SideMenuBasedController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 14/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import PromiseKit
import FocusGuideHelper


class SideMenuBasedController: UIViewController {
    
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    let guideHelper = FocusGuideHelper()
    var sidebarTable: UITableView!
    var currentContainerController: UIViewController?
    var currentSidebarOptionSelected: SidebarOptions?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setDefaultBackground()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableIdentifier" {
            let sidebarController = segue.destination as! SidebarController
            sidebarController.sidebarProtocol = self
            
            sidebarTable = sidebarController.tableView
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        guideHelper.updateFocus(in: context)
    }

}

//MARK: SidebarProtocol
extension SideMenuBasedController: SidebarProtocol {
    
    func focusedCell(withOption option: SidebarOptions) {
        
        if currentSidebarOptionSelected == option {
            updateSidemenuFocusGuide()
            return
        }
        
        currentSidebarOptionSelected = option
        
        _ = firstly {
            UIView.promise(animateWithDuration: 0.5, animations: {
                self.containerView.alpha = 0
            })
        }.then { _ -> Void in
            // todo: fix this strange condition; we "need" it because of async
            if self.currentSidebarOptionSelected == option {
                self.changeContainerView(option: option)
                self.updateSidemenuFocusGuide()
            
            
                _ = UIView.promise(animateWithDuration: 0.5, animations: {
                    self.containerView.alpha = 1
                })
            }
        }
    }
    
    func updateSidemenuFocusGuide() {
        
        switch currentSidebarOptionSelected! {
        case .dashboard:
            let projectController = currentContainerController as! ProjectsViewController
            let cellDashboard = sidebarTable.cellForRow(at: IndexPath(row: 0, section: 0))!
            
            guideHelper.addLinkByFocusTemporary(
                from: cellDashboard,
                to: projectController.dashboardsTab,
                inPosition: .right
            )
            
            projectController.guideHelper.addLinkByFocus(
                from: projectController.dashboardsTab,
                to: cellDashboard,
                inPosition: .left,
                identifier: "projects segmenets to sidemenu"
            )
            
            projectController.guideHelper.addLinkByFocus(
                from: projectController.gridView!.view,
                to: cellDashboard,
                inPosition: .left,
                identifier: "grid to sidemenu",
                activedWhen: { context in
                    return (context.nextFocusedView as? SlotableCellDefault) != nil
                }
            )
            
        case .newDasboard:
            let createProjectController = currentContainerController as! CreateGridViewController
            let cellNewDashboard = sidebarTable.cellForRow(at: IndexPath(row: 1, section: 0))!
            
            guideHelper.addLinkByFocusTemporary(
                from: cellNewDashboard,
                to: createProjectController.container.view,
                inPosition: .right
            )
            
        case .myAccount:
            let accountController = currentContainerController as! AccountViewController
            let cellAccount = sidebarTable.cellForRow(at: IndexPath(row: 2, section: 0))!
            
            guideHelper.addLinkByFocusTemporary(
                from: cellAccount,
                to: accountController.container.view,
                inPosition: .right
            )
        }
    }
    
    func setControllerAtContainer(_ controller: UIViewController) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        addChildViewController(controller)
        controller.view.frame.size = containerView.frame.size
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
        currentContainerController = controller
    }
    
    func changeContainerView(option: SidebarOptions) {
        labelTitle.text = option.description
        
        guard let controller = option.instantiateController else {
            return
        }
        
        setControllerAtContainer(controller)
    }
}
