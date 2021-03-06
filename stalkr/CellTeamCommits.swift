//
//  CellTeamCommits.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 18/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import PusherSwift
import GridView

class CellTeamCommits: SlotableCellDefault, SlotableCell, StalkrCell, SubscriberCell {

    @IBOutlet weak var viewChart: BarChartView!
    static let cellName = "Team Commits"
    static let slotWidth = 1
    static let slotHeight = 1
    static let haveZoom = true
    
    // config
    static let configurations: [StalkrCellConfig] = [
        StalkrCellConfig(name: "pusher_key", label: "Pusher key", obligatory: true),
        StalkrCellConfig(name: "owner", label: "Github's user", obligatory: true),
        StalkrCellConfig(name: "project", label: "Github's repository", obligatory: true)
    ]

    
    // subscriber
    var pusher: Pusher?
    
    let webSockets = [
        WebSocketConfig(
            channel: { config in
                let owner = config["owner"] as! String
                let project = config["project"] as! String
                
                return "participation-\(owner)-\(project)"
            },
            event: "status-requested",
            
            handle: { json, cell in
                // TODO: need be update with the new architecture
                let commits = json["payload"].arrayValue.map { $0.intValue }
                (cell as! CellTeamCommits).drawChart(commits: Array(commits.suffix(5)))
            }
        )
    ]
    
    //
    func load() {
        drawChart(commits: [])
    }
    
    func drawChart(commits: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        let visitorCounts = commits
        for i in 0..<visitorCounts.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(visitorCounts[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
        chartDataSet.colors = [UIColor](repeating: UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.7), count: visitorCounts.count)
        let chartData = BarChartData(dataSet: chartDataSet)
        viewChart.backgroundColor = UIColor(white: 1, alpha: 0.0)
        viewChart.legend.enabled = false
        viewChart.chartDescription?.text = ""
        
        viewChart.xAxisRenderer.axis?.enabled = false
        viewChart.leftYAxisRenderer.axis?.labelTextColor = UIColor.white
        viewChart.leftYAxisRenderer.axis?.labelFont = NSUIFont.systemFont(ofSize: 16.0)
        viewChart.leftYAxisRenderer.axis?.gridColor = UIColor.white
        viewChart.leftYAxisRenderer.axis?.axisLineColor = UIColor(white: 1, alpha: 0.0)
        viewChart.rightYAxisRenderer.axis?.axisLineColor = UIColor(white: 1, alpha: 0.0)
        
        viewChart.data = chartData
    }
    
}
