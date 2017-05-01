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
    var gridView: EmbededGridController?
    var projectsList: [Project] = []

    var selectedIndex = IndexPath()
    
    var guideHelper = FocusGuideHelper(withArrayOfFocus: [])
    
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

}
