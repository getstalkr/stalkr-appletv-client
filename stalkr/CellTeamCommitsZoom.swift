//
//  CellTeamCommitsZoom.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 22/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Charts

class CellTeamCommitsZoom: ZoomCell, SlotableCell {
    
    @IBOutlet weak var viewChart: BarChartView!
    func load(params: [String: Any]) {
        var dataEntries: [BarChartDataEntry] = []
        let visitorCounts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
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
