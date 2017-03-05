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

class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var sidebarController: ProjectTableViewController?
    
    var projectController: ProjectsViewController?
    
    var createProjectController: CreateGridViewController?
        
    var seletionBar: UIView = UIView()
    
    @IBOutlet weak var sidebarView: UIView!
    
    @IBOutlet weak var createProjectView: UIView!
    
    @IBOutlet weak var projectView: UIView!
        
    @IBOutlet weak var accountView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    let gradientLayer = CAGradientLayer()
    
    var focusArray: [UIFocusGuide] = []
    
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
            self.sidebarController = segue.destination as? ProjectTableViewController
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

extension SegmentedViewController: SidebarProtocol {
    
    func focusedCell(withOption option: String) {
        
        labelTitle.text = option
        
        switch option {
        case "Projetos":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 1
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 0
                    
                    if self.focusArray.count < 1 {
                        //Liga a célula projeto da sidebar ao segmented control.
                        //Comentada pq Não há mais um segmented.
                        //Basta trocar o segmented pelo novo elemento
                        
//                        guard let cell = self.sidebarController!.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
//                            print("\ncell\n")
//                            return
//                        }
//                        let segments = self.projectController!.segmentShowGrid.subviews.sorted(by: { (a, b) -> Bool in
//                            return a.center.x < b.center.x
//                        })
//                        self.linkByFocus(from: cell, to: segments[0], inPosition: .Right, reduceMeasurement: .Width)
//                        self.linkByFocus(from: segments[0], to: cell, inPosition: .Left, reduceMeasurement: .Width)
                    }
                })
            case "Criar projeto":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 1
                    self.accountView.alpha = 0
                    
                    if self.focusArray.count < 2 {
                        //Ligar célula Criar projeto ao textfield da view criar projeto
                    }
                })
            default:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 1
            })
        }
    }
    
    func linkByFocus(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement) {
        
        let focusGuide = UIFocusGuide()
        self.view.addLayoutGuide(focusGuide)
        switch measure {
            case .Height:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
            case .Width:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .None:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .WidthAndHeight:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        
        switch pos {
            case .Up:
                focusGuide.bottomAnchor.constraint(equalTo: view1.topAnchor, constant: 0).isActive = true
            case .Down:
                focusGuide.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 0).isActive = true
            case .Left:
                focusGuide.trailingAnchor.constraint(equalTo: view1.leadingAnchor, constant: 0).isActive = true
            case .Right:
                focusGuide.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 0).isActive = true
        }
        
        focusGuide.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
        focusGuide.preferredFocusEnvironments = [view2]
        self.focusArray.append(focusGuide)
    }
    
    func selectedCell(withIndex index: IndexPath) {

        
    }
}
