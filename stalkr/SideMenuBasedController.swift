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
    
    @IBOutlet weak var logoStalkr: UIImageView!
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var sideMenuSuperView: UIView!
    @IBOutlet weak var sideMenuSuperViewWidth: NSLayoutConstraint!
    @IBOutlet weak var logoWidthSmall: NSLayoutConstraint!
    @IBOutlet weak var logoWidthBig: NSLayoutConstraint!
    @IBOutlet weak var sideMenuArrowIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    let guideHelper = FocusGuideHelper()
    var sidebarTable: UITableView!
    var currentContainerController: UIViewController?
    var currentSidebarOptionSelected: SidebarOptions?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        sideMenuArrowIcon.alpha = 0
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

extension SideMenuBasedController: SidebarProtocol {
    
    func toggle(showSidebar: Bool) {
        let projectController = self.currentContainerController as? ProjectsViewController
        
        if showSidebar {
            self.sideMenuArrowIcon.alpha = 0
            
            _ = firstly {
                UIView.promise(animateWithDuration: 1, animations: {
                    self.logoStalkr.transform = CGAffineTransform(rotationAngle: 0)
                    self.logoWidthSmall.isActive = true
                    self.logoWidthBig.isActive = false
                    
                    self.sidebarView.alpha = 1
                    
                    projectController?.gridView?.view.alpha = 0
                    
                    self.sideMenuSuperView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.2980392157, alpha: 0.1)
                    self.sideMenuSuperViewWidth.constant = 386
                    self.view.layoutIfNeeded()
                })
            }.then { _ -> Promise<Bool> in
                projectController?.gridView?.gridView?.reloadGrid()
                        
                return UIView.promise(animateWithDuration: 1, animations: {
                    projectController?.gridView?.view.alpha = 1
                })
            }
        } else {
            _ = firstly {
                UIView.promise(animateWithDuration: 1, animations: {
                    self.logoStalkr.transform = CGAffineTransform(rotationAngle: CGFloat(0.5 * Double.pi))
                    self.logoWidthSmall.isActive = false
                    self.logoWidthBig.isActive = true
                    
                    self.sidebarView.alpha = 0
                    
                    projectController?.gridView?.view.alpha = 0
                    
                    self.sideMenuSuperView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.2980392157, alpha: 0.2)
                    self.sideMenuSuperViewWidth.constant = 50
                    self.view.layoutIfNeeded()
                })
            }.then { _ -> Promise<Bool> in
                projectController?.gridView?.gridView?.reloadGrid()
                
                return UIView.promise(animateWithDuration: 1, animations: {
                    self.sideMenuArrowIcon.alpha = 1
                    projectController?.gridView?.view.alpha = 1
                })
            }
        }
    }
    
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
            
            guideHelper.addLinkByFocus(
                from: containerView,
                to: cellDashboard,
                inPosition: .left,
                identifier: "container to sidemenu"
            )
            
        case .myAccount:
            let accountController = currentContainerController as! AccountViewController
            let cellAccount = sidebarTable.cellForRow(at: IndexPath(row: 1, section: 0))!
            
            guideHelper.addLinkByFocusTemporary(
                from: cellAccount,
                to: accountController.view,
                inPosition: .right
            )
            
            guideHelper.addLinkByFocus(
                from: containerView,
                to: cellAccount,
                inPosition: .left,
                identifier: "container to sidemenu"
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
        guard let controller = option.instantiateController else {
            return
        }
        
        setControllerAtContainer(controller)
    }
}
