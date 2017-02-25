//
//  ProjectsViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    
    var parentController: SegmentedViewController?
    
    var gridView: GridViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gridIdentifier" {
            
        }
    }
}

extension ProjectsViewController: ProjectViewProtocol {
    
    func didChangeProject(toProjectNamed name: String) {
        //labelTitle.text = name
    }
}
