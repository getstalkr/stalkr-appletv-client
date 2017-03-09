//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//
import UIKit
import Cartography

struct Project {
    let name: String
    
    func show(grid: ProjectViewProtocol) {
        grid.didChangeProject(toProjectNamed: self.name)
    }
}

class ProjectsViewController: UIViewController {

    @IBOutlet weak var projectsTab: UICollectionView!
    @IBOutlet weak var viewProjectsTabFooter: UIView!
    var gridView: GridViewController?
    var projectsList: [Project] = []
    @IBOutlet weak var containerView: UIView!

    var selectedIndex = IndexPath()
    
    var guideHelper = FocusGuideHelper(withArrayOfFocus: [])
    
    var shouldSelectEspecificTab = false
    
    var parentController: MainViewController?

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        
        let cells = projectsTab.subviews.sorted(by: { (a, b) -> Bool in
            return a.center.x < b.center.x
        })
        return [cells[selectedIndex.row]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectsTab.delegate = self
        projectsTab.dataSource = self
        projectsTab.backgroundColor = UIColor(white: 0, alpha: 0)
        
        viewProjectsTabFooter.backgroundColor = UIColor.projectTabNotSelected
        
        projectsList = [Project(name: "Blau"), Project(name: "Save my nails"), Project(name: "Eta bicho doido")]
        projectsList[0].show(grid: (self.gridView as! ProjectViewProtocol))
        
        selectedIndex = IndexPath(row: 0, section: 0)
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
        cell.grid = (self.gridView as! ProjectViewProtocol)
        
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


        //
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
        print("\nselect = \(shouldSelectEspecificTab)\n")
        if context.nextFocusedIndexPath != nil {
            if context.previouslyFocusedIndexPath != nil {
                selectedIndex = context.nextFocusedIndexPath!
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedIndexPath != nil && context.previouslyFocusedIndexPath == nil {
            projectsTab.cellForItem(at: selectedIndex)?.setNeedsFocusUpdate()
            projectsTab.cellForItem(at: selectedIndex)?.updateFocusIfNeeded()
        }
        
        let cells = projectsTab.subviews.sorted(by: { (a, b) -> Bool in
            return a.center.x < b.center.x
        })
        
        print("\n\nNUM = \(cells.count)\n\n")
        
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
