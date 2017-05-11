//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//
import UIKit
import TvLightSegments

class ProjectsViewController: UIViewController {

    @IBOutlet weak var dashboardsTab: TvLightSegments!
    @IBOutlet weak var containerView: UIView!
    let guideHelper = FocusGuideHelper(withArrayOfFocus: [])
    var gridView: EmbededGridController?
    var projectsList: [Project] = []

    var selectedIndex = IndexPath()
    
    
    var shouldSelectEspecificTab = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dashboardsTab.setup(viewDisplay: gridView!)
    }
    
    func reloadProjectsList() {
        projectsList = UserSession.shared.projects!
        if projectsList.count > 0 {
            dashboardsTab.set(segmentsItems: projectsList)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueEmbededGrid" {
            self.gridView = (segue.destination as! EmbededGridController)
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if (context.previouslyFocusedItem as? CellSegment) != nil &&
            (context.nextFocusedItem as? SlotableCellDefault) != nil {
            
            guideHelper.enable()
        } else if (context.nextFocusedItem as? CellSegment) != nil {
            
            guideHelper.deseable()
        }
    }
}
