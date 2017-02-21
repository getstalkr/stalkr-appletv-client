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
        
        addGradientToBackground()
    }
    
    func addGradientToBackground() {
        
        self.view.backgroundColor = .white
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(netHex: 0x543663).cgColor
        let color2 = UIColor(netHex: 0x483159).cgColor
        let color3 = UIColor(netHex: 0x453158).cgColor
        let color4 = UIColor(netHex: 0x242741).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.startPoint = CGPoint(x: 0.35, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.zPosition = -1
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectionChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
        } else if sender.selectedSegmentIndex == 1 {

        }
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
