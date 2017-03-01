//
//  SegmentedViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 14/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addGradientToBackground()
        
        //linkTableAndSegmentedByFocus()
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
    
    //A função abaixo é importante para o focus guide. Após alguns ajuste ela será funcional
    
//    func linkTableAndSegmentedByFocus() {
//        
//        //Table to segmented from left to right
//        let focusGuide = UIFocusGuide()
//        view.addLayoutGuide(focusGuide)
//        focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        focusGuide.heightAnchor.constraint(equalTo: projectTable!.view.heightAnchor).isActive = true
//        focusGuide.leadingAnchor.constraint(equalTo: projectTable!.view.trailingAnchor, constant: 0).isActive = true
//        focusGuide.centerYAnchor.constraint(equalTo: projectTable!.view.centerYAnchor).isActive = true
//        let segments = projectsSegmented.subviews.sorted(by: { (a, b) -> Bool in
//            return a.center.x < b.center.x
//        })
//        focusGuide.preferredFocusedView = segments[0]
//        
//        //segmented to table from right to left
//        let focusGuide2 = UIFocusGuide()
//        view.addLayoutGuide(focusGuide2)
//        focusGuide2.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        focusGuide2.heightAnchor.constraint(equalTo: segments[0].heightAnchor).isActive = true
//        focusGuide2.trailingAnchor.constraint(equalTo: segments[0].leadingAnchor, constant: 0).isActive = true
//        focusGuide2.centerYAnchor.constraint(equalTo: segments[0].centerYAnchor).isActive = true
//        focusGuide2.preferredFocusedView = projectTable!.view
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableIdentifier" {
            self.sidebarController = segue.destination as? ProjectTableViewController
            self.sidebarController?.sidebarProtocol = self
            
        } else if segue.identifier == "projectsIdentifier" {
            self.projectController = segue.destination as? ProjectsViewController
            self.projectController?.parentController = self
            
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
                })
            case "Criar projeto":
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 1
                    self.accountView.alpha = 0
                })
            default:
                UIView.animate(withDuration: 0.5, animations: {
                    self.projectView.alpha = 0
                    self.createProjectView.alpha = 0
                    self.accountView.alpha = 1
            })
        }
    }
}
