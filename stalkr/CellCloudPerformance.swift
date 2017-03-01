//
//  CellCloudPerformance.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 18/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Charts

class CellCloudPerformance: SlotableCellDefault, SlotableCell {
    
    @IBOutlet weak var viewChart: LineChartView!
    @IBOutlet weak var viewDivision: UIView!
    static let cellName = "Cloud Performances"
    let slotWidth = 1
    let slotHeight = 1
    let haveZoom = false
    
    static let configurations: [ConfigInput] = []

    func load(params: [String: Any]) {
        var dataEntry: [ChartDataEntry] = []
        for i in 0..<5 {
            dataEntry.append(ChartDataEntry(x: Double(i), y: Double(i)))
        }
        
        let lineDataSet = LineChartDataSet(values: dataEntry, label: nil)
        lineDataSet.lineWidth = 1.75
        lineDataSet.circleRadius = 5.0
        lineDataSet.circleHoleRadius = 2.5
        lineDataSet.setColors(UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.7))
        lineDataSet.setCircleColors(UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.7))
        
        let chartData = LineChartData(dataSet: lineDataSet)
        
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
