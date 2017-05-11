//
//  SegmentedViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 14/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var createProjectView: UIView!
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var accountView: UIView!
    var sidebarController: SidebarController?
    var projectController: ProjectsViewController?
    var createProjectController: CreateGridViewController?
    var accountViewController: AccountViewController?
    var seletionBar: UIView = UIView()
    let gradientLayer = CAGradientLayer()
    let guideHelper = FocusGuideHelper(withArrayOfFocus: [])

    override func viewDidLoad() {
        
        super.viewDidLoad()
        addGradientToBackground()
    }
    
    func addGradientToBackground() {
        
        self.view.backgroundColor = .white
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(netHex: 0x543663).cgColor
        let color2 = UIColor(netHex: 0x483159).cgColor
        let color3 = UIColor(netHex: 0x453158).cgColor
        let color4 = UIColor(netHex: 0x242741).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.startPoint = CGPoint(x: 0.35, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.zPosition = -1
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableIdentifier" {
            self.sidebarController = segue.destination as? SidebarController
            self.sidebarController?.sidebarProtocol = self
            
        } else if segue.identifier == "projectsIdentifier" {
            self.projectController = segue.destination as? ProjectsViewController
            
        } else if segue.identifier == "createProjectIdentifier" {
            self.createProjectController = segue.destination as? CreateGridViewController
        
        } else if segue.identifier == "accountIdentifier" {
            self.accountViewController = segue.destination as? AccountViewController
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return super.shouldUpdateFocus(in: context)
    }
}

//MARK: SidebarProtocol
extension MainViewController: SidebarProtocol {
    
    func focusedCell(withOption option: SidebarOptions) {
        
        labelTitle.text = option.description
        
        guideHelper.deseable()
        
        switch option {
            case .dashboard:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 1
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 0
                })
                guard let cellDashboard = sidebarController!.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
                    return
                }

                projectController!.reloadProjectsList()
                
                let segments = projectController!.dashboardsTab.visibleCells.sorted {
                    $0.center.x < $1.center.x
                }
                
                if segments.count > 0 { // if we have at least one project
                    guideHelper.linkByFocus(
                        from: cellDashboard,
                        to: segments[0],
                        inPosition: .right,
                        reduceMeasurement: .widthAndHeight,
                        inView: self.view
                    )
                    
                    guideHelper.linkByFocus(
                        from: segments[0],
                        to: cellDashboard,
                        inPosition: .left,
                        reduceMeasurement: .width,
                        inView: self.view
                    )
                    
                    projectController!.guideHelper.linkByFocus(
                        from: projectController!.gridView!.view,
                        to: cellDashboard,
                        inPosition: .left,
                        reduceMeasurement: .width,
                        inView: projectController!.gridView!.view
                    )
                }
            
            case .newDasboard:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 1
                    self.accountView.alpha = 0
                })
                guard let cellNewDashboard = sidebarController!.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) else {
                    return
                }
                
                projectController!.guideHelper.deseable()
                
                guideHelper.linkByFocus(
                    from: cellNewDashboard,
                    to: createProjectController!.container.view,
                    inPosition: .right,
                    reduceMeasurement: .widthAndHeight,
                    inView: self.view
                )
                
                createProjectController!.guideHelper.linkByFocus(
                    from: createProjectView,
                    to: cellNewDashboard,
                    inPosition: .left,
                    reduceMeasurement: .width,
                    inView: createProjectView
                )
                createProjectController!.guideHelper.deseable()
            
            case .myAccount:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 1
                })
                guard let cellAccount = sidebarController!.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else {
                    return
                }
                
                projectController!.guideHelper.deseable()
                
                guideHelper.linkByFocus(
                    from: cellAccount,
                    to: accountViewController!.container.view,
                    inPosition: .right,
                    reduceMeasurement: .widthAndHeight,
                    inView: self.view
                )
                
                accountViewController!.guideHelper.linkByFocus(
                    from: createProjectView,
                    to: cellAccount,
                    inPosition: .left,
                    reduceMeasurement: .width,
                    inView: accountView
                )
                accountViewController!.guideHelper.deseable()
                accountViewController!.guideHelperMain = guideHelper
        }
    }
}
