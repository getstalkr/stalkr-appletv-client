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
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var dashboardContainer: UIView!
    
    @IBOutlet weak var ProjectListContainer: UIView!
        
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        //self.__addChildViewController(controller: mainViewController, to: dashboardContainer)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //segmentedActivities.addTarget(self, action: #selector(SegmentedViewController.controlSegmented), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectionChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            //switchViewController(controller: blueViewController, to: mainViewController)
        } else if sender.selectedSegmentIndex == 1 {
            //switchViewController(controller: mainViewController, to: blueViewController)
        }
    }
    
    func switchViewController(controller oldController: UIViewController, to newController: UIViewController) {
        
        self.__removeChildViewController(controller: oldController)
        self.__addChildViewController(controller: newController, to: dashboardContainer)
    }
    
    private func __addChildViewController(controller: UIViewController, to view: UIView) {

        self.addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    private func __removeChildViewController(controller: UIViewController) {

        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
}
