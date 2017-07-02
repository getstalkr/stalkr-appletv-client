//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//
import UIKit
import TvLightSegments
import FocusGuideHelper
import PromiseKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var dashboardsTab: TvLightSegments!
    @IBOutlet weak var containerView: UIView!
    let guideHelper = FocusGuideHelper()
    var gridView: EmbededGridController?
    var projectsList: [Project] = []

    var selectedIndex = IndexPath()
    
    
    var shouldSelectEspecificTab = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dashboardsTab.setup(viewDisplay: gridView!)
        loadProjectsList()
    }
    
    func loadProjectsList() {
        firstly {
            GetDashboardTask().execute()
        }.then { r -> Void in
            self.projectsList = r
            
            if self.projectsList.count > 0 {
                self.dashboardsTab.set(segmentsItems: self.projectsList)
            }
        }.catch { error in
            // todo: show this error in UI
            print("ERROR IN LOAD PROJECT: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueEmbededGrid" {
            self.gridView = (segue.destination as! EmbededGridController)
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        guideHelper.updateFocus(in: context)
    }
}
