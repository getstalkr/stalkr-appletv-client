//
//  SegmentedViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 14/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {

    @IBOutlet weak var segmentedActivities: UISegmentedControl!
    
    @IBOutlet weak var collectionCells: UICollectionView!
    
    @IBOutlet weak var tableProjects: UITableView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var mainViewController: MainViewController {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return viewController
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        segmentedActivities.addTarget(self, action: #selector(SegmentedViewController.controlSegmented), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controlSegmented() {
        
    }

}
