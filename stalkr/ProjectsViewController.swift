//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    
    @IBOutlet weak var segmentShowGrid: UISegmentedControl!
    //var parentController: SegmentedViewController?
    var gridView: GridViewController?
    
//    var myprefered: UIView?
//    override var preferredFocusedView: UIView?{
//        return myprefered
//    }
    var mypreferredFocusEnvironments: [UIFocusEnvironment]?
//    override var preferredFocusEnvironments: [UIFocusEnvironment] {
//        return mypreferredFocusEnvironments
//    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.segmentShowGrid.replaceSegments(segments: ["Blau", "Save my Nails", "Eta bicho doido"])
        self.segmentShowGrid.selectedSegmentIndex = 0
        self.segmentShowGridChanged(self.segmentShowGrid)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gridIdentifier" {
            self.gridView = segue.destination as? GridViewController
        }
    }
    
    @IBAction func segmentShowGridChanged(_ sender: UISegmentedControl) {
        (self.gridView as! ProjectViewProtocol).didChangeProject(toProjectNamed: self.segmentShowGrid.getSelectedText())
    }

}
