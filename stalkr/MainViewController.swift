//
//  SegmentedViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 14/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

enum Pos {
    
    case Up
    case Left
    case Down
    case Right
}

enum Measurement {
    
    case Width
    case Height
    case None
    case WidthAndHeight
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var sidebarController: SidebarController?
    
    var projectController: ProjectsViewController?
    
    var createProjectController: CreateGridViewController?
        
    var seletionBar: UIView = UIView()
    
    @IBOutlet weak var sidebarView: UIView!
    
    @IBOutlet weak var createProjectView: UIView!
    
    @IBOutlet weak var projectView: UIView!
        
    @IBOutlet weak var accountView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    var guideHelper = FocusGuideHelper(withArrayOfFocus: [])

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableIdentifier" {
            
            self.sidebarController = segue.destination as? SidebarController
            self.sidebarController?.sidebarProtocol = self
            
        } else if segue.identifier == "projectsIdentifier" {
            self.projectController = segue.destination as? ProjectsViewController
            
        } else if segue.identifier == "createProjectIdentifier" {
            self.createProjectController = segue.destination as? CreateGridViewController
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return super.shouldUpdateFocus(in: context)
    }
}

//MARK: SidebarProtocol

extension MainViewController: SidebarProtocol {
    
    func focusedCell(withOption option: String) {
        
        labelTitle.text = option
        
        guideHelper.deseable()
        
        switch option {
            case "DASHBOARD":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 1
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 0
                })
                guard let cell = sidebarController!.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
                    return
                }

                projectController!.reloadProjectsList()
                
                let segments = projectController!.projectsTab.visibleCells.sorted(by: { (a, b) -> Bool in
                    return a.center.x < b.center.x
                })

                guideHelper.linkByFocus(from: cell, to: segments[0], inPosition: .Right, reduceMeasurement: .WidthAndHeight, inView: self.view)
                guideHelper.linkByFocus(from: segments[0], to: cell, inPosition: .Left, reduceMeasurement: .Width, inView: self.view)
            case "NEW PROJECT":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 1
                    self.accountView.alpha = 0
                })
                guard let sidebarCell = sidebarController!.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) else {
                    return
                }
                
                guideHelper.linkByFocus(from: sidebarCell, to: createProjectView, inPosition: .Right, reduceMeasurement: .WidthAndHeight, inView: self.view)
                guideHelper.linkByFocus(from: createProjectView, to: sidebarCell, inPosition: .Left, reduceMeasurement: .Width, inView: self.view)
            
            case "MY ACCOUNT":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 1
                })
                guard let sidebarCell = sidebarController!.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else {
                    return
                }
                
                guideHelper.linkByFocus(from: sidebarCell, to: accountView, inPosition: .Right, reduceMeasurement: .WidthAndHeight, inView: self.view)
                guideHelper.linkByFocus(from: accountView, to: sidebarCell, inPosition: .Left, reduceMeasurement: .Width, inView: self.view)
            
            default:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 1
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 0
                })
        }
    }
    
    //TODO: Find a way to explicitly changing focus (without any swipe gesture)
    func selectedCell(withIndex index: IndexPath) {

    }
}
