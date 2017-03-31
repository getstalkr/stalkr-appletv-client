//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//
import UIKit
import Cartography

class ProjectsViewController: UIViewController {

    @IBOutlet weak var projectsTab: UICollectionView!
    @IBOutlet weak var viewProjectsTabFooter: UIView!
    @IBOutlet weak var containerView: UIView!
    var gridView: GridViewController?
    var projectsList: [Project] = []

    var selectedIndex = IndexPath()
    
    var guideHelper = FocusGuideHelper(withArrayOfFocus: [])
    
    var shouldSelectEspecificTab = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        projectsTab.delegate = self
        projectsTab.dataSource = self
        projectsTab.backgroundColor = UIColor(white: 0, alpha: 0)
        
        viewProjectsTabFooter.backgroundColor = UIColor.projectTabNotSelected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gridIdentifier" {
            self.gridView = segue.destination as? GridViewController
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return super.shouldUpdateFocus(in: context)
    }
}

// code of project list collectionview
extension ProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func reloadProjectsList() {
        projectsList = UserSession.shared.projects!
        if projectsList.count == 0 {
            return
        }
        
        projectsList[0].show(atProjectView: (self.gridView!))
        
        selectedIndex = IndexPath(row: 0, section: 0)
        
        projectsTab.reloadData()
        self.projectsTab.layoutIfNeeded()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellProjectTab", for: indexPath) as! CellProjectTab
        
        let currentProject = projectsList[indexPath.item]
        
        cell.project = currentProject
        cell.grid = (self.gridView!)
        
        // set label
        cell.labelProjectName.text = currentProject.name
        cell.labelProjectName.sizeToFit()
        
        // colors
        cell.viewFooterCenter.backgroundColor = UIColor.projectTabNotSelected
        cell.labelProjectName.textColor = UIColor.projectTabNotSelected
        
        // shadow
        cell.viewFooterCenter.layer.shadowColor = UIColor.white.cgColor
        cell.viewFooterCenter.layer.shadowOpacity = 0
        
        // constrains
        constrain(cell.labelProjectName, cell.viewFooterCenter) { label, footerCenter in
            label.top == label.superview!.topMargin
            label.left == label.superview!.leftMargin + 15
            label.right == label.superview!.rightMargin + 15
            
            footerCenter.top == label.bottom + 5
            footerCenter.width == cell.labelProjectName.frame.width
            footerCenter.left == label.left

            footerCenter.height == 5
        }
        
        if indexPath.item == 0 {
            cell.changeToSelected()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        
        if context.previouslyFocusedIndexPath != nil && context.nextFocusedIndexPath == nil {
            shouldSelectEspecificTab = true
        } else {
            shouldSelectEspecificTab = false
        }
        if context.nextFocusedIndexPath != nil {
            if context.previouslyFocusedIndexPath != nil {
                selectedIndex = context.nextFocusedIndexPath!
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        let cells = projectsTab.subviews.sorted(by: { (a, b) -> Bool in
            return a.center.x < b.center.x
        })
                
        guideHelper.deseable()
        
        guideHelper.linkByFocus(from: containerView, to: cells[selectedIndex.row], inPosition: .Left, reduceMeasurement: .Width, inView: self.view)
    }
    
    // Focus
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {

        if shouldSelectEspecificTab && indexPath.row != selectedIndex.row {
            return false
        }
        return true
    }
}
