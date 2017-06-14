//
//  CellCloudPerformance.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 18/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Charts
import GridView
import PusherSwift
import SwiftyJSON

class CellCloudPerformance: SlotableCellDefault, SlotableCell, StalkrCell, SubscriberCell {
    
    @IBOutlet weak var viewChart: LineChartView!
    @IBOutlet weak var viewDivision: UIView!
    static let cellName = "Cloud Performances"
    static let slotWidth = 1
    static let slotHeight = 1
    static let haveZoom = false
    
    var chartDots: [(latencyValue: Double, dateString: String)] = []
    
    // config
    static let configurations: [StalkrCellConfig] = [
        StalkrCellConfig(name: "pusher_key", label: "Pusher key", obligatory: true),
        StalkrCellConfig(name: "stalkr_project", label: "Stalkr Project", obligatory: true),
        StalkrCellConfig(name: "stalkr_team", label: "Stalkr Team", obligatory: true)
    ]
    
    // subscriber
    var pusher: Pusher?
    
    let webSockets = [
        WebSocketConfig(
            channel: { config in
                let stalkrProject = config["stalkr_project"] as! String
                let stalkrTeam = config["stalkr_team"] as! String
                
                return "\(stalkrProject)@\(stalkrTeam)"
            },
            event: "push",
            
            handle: { json, cell in
                let cell = cell as! CellCloudPerformance
                
                let jsonDate = TimeInterval(json["date"].intValue)
                let jsonValue = json["value"].doubleValue
                
                let date = Date(timeIntervalSince1970: TimeInterval(jsonDate))
                
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "dd hh:mm:ss"
                
                let dateString = dayTimePeriodFormatter.string(from: date)
                
                cell.chartDots.append((latencyValue: jsonValue, dateString: dateString))
                cell.updateChart()
            }
        )
    ]
    
    //
    func updateChart() {
        // todo: we need show chartDots[i].dateString in some place of this cell 
        
        var dataEntry: [ChartDataEntry] = []
        for i in 0..<chartDots.count {
            dataEntry.append(ChartDataEntry(x: Double(i), y: chartDots[i].latencyValue))
        }
        
        let lineDataSet = LineChartDataSet(values: dataEntry, label: nil)
        lineDataSet.lineWidth = 2.25
        lineDataSet.circleRadius = 7.0
        lineDataSet.setColors(#colorLiteral(red: 0.7215686275, green: 0.3960784314, blue: 0.8235294118, alpha: 0.7))
        lineDataSet.setCircleColors(#colorLiteral(red: 0.7215686275, green: 0.3960784314, blue: 0.8235294118, alpha: 0.7))
        lineDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSet: lineDataSet)
        
        viewChart.backgroundColor = .clear
        viewChart.legend.enabled = false
        viewChart.chartDescription?.text = ""
        
        viewChart.xAxisRenderer.axis?.enabled = false
        
        viewChart.leftYAxisRenderer.axis?.labelTextColor = .white
        viewChart.leftYAxisRenderer.axis?.labelFont = NSUIFont.systemFont(ofSize: 23.0)
        viewChart.leftYAxisRenderer.axis?.gridColor = .white
        viewChart.leftYAxisRenderer.axis?.axisLineColor = .clear
        
        viewChart.rightYAxisRenderer.axis?.axisLineColor = .clear
        viewChart.rightYAxisRenderer.axis?.drawLabelsEnabled = false
        
        viewChart.data = chartData
    }
    
    func load(params: [String: Any]) {
        updateChart()
    }
}
