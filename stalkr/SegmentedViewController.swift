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
    
    var projectTable: ProjectTableViewController? = nil
    
    @IBOutlet weak var dashboardContainer: UIView!
    
    var seletionBar: UIView = UIView()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(netHex: 0x543663).cgColor
        let color2 = UIColor(netHex: 0x483159).cgColor
        let color3 = UIColor(netHex: 0x453158).cgColor
        let color4 = UIColor(netHex: 0x242741).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.4)
        gradientLayer.zPosition = -1
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
        
        seletionBar.frame = CGRect(x: 0.0, y: self.segmentedActivities.frame.size.height, width: self.segmentedActivities.frame.size.width/CGFloat(self.segmentedActivities.numberOfSegments), height: 5.0)
        seletionBar.backgroundColor = UIColor(colorLiteralRed: 141/255, green: 102/255, blue: 189/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectionChanged(_ sender: UISegmentedControl) {
        
        let placeSelectionBar = { () -> () in
            var barFrame = self.seletionBar.frame
            barFrame.origin.x = barFrame.size.width * CGFloat(sender.selectedSegmentIndex)
            self.seletionBar.frame = barFrame
        }
        
        if seletionBar.superview == nil {
            sender.addSubview(seletionBar)
            placeSelectionBar()
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                placeSelectionBar()
            })
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableIdentifier" {
            self.projectTable = segue.destination as? ProjectTableViewController
            self.projectTable?.projectDelegate = self
        }
    }
    
}

//MARK: ProjectViewProtocol

extension SegmentedViewController: ProjectViewProtocol {
    
    func didChangeProject(toProjectNamed name: String) {
        labelTitle.text = name
    }
}
