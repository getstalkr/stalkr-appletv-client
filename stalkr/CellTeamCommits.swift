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

class CellTeamCommits: SlotableCellDefault, SlotableCell, SubscriberCell {

    @IBOutlet weak var viewChart: BarChartView!
    static let cellName = "Team Commits"
    let slotWidth = 1
    let slotHeight = 1
    let haveZoom = true
    
    // config
    static let configurations: [ConfigInput] = [
        ConfigInput(name: "owner", label: "Github's user", inputType: .text, obligatory: true),
        ConfigInput(name: "project", label: "Github's repository", inputType: .text, obligatory: true)
    ]

    
    // subscriber
    let webSockets = [
        WebSocketConfig(
            requestStartUrl: "https://stalkr-api-commits-history-git.herokuapp.com",
            requestStartParams: { config in
                return ["owner": config["owner"] as! String, "project": config["project"] as! String]
            },
            channel: { config in
                let owner = config["owner"] as! String
                let project = config["project"] as! String
                
                return "participation-\(owner)-\(project)"
            },
            event: "status-requested"
        )
    ]
    
    let webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] = [
        "status-requested": { json, cell in
            let commits = json["payload"].arrayValue.map { $0.intValue }
            (cell as! CellTeamCommits).drawChart(commits: Array(commits.suffix(5)))
        }
    ]
    
    //
    func load(params: [String: Any]) {
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
