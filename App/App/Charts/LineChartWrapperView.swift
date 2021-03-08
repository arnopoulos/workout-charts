//
//  LineChartWrapperView.swift
//  App
//
//  Created by Andrew Arnopoulos on 3/7/21.
//

import Charts
import UIKit

/// Class that is used to hide implementation details of the Charting library being used
/// in the eventuality that we switch out the charting library
class LineChartWrapperView: UIView, LineChart {
    /// The entires that should be displayed on the chart
    var points: [Point2D] = [] {
        didSet {
            setup()
        }
    }
    
    private let chart: LineChartView
    private let yAxisLabel: String

    init(_ chart: LineChartView, yAxisLabel: String) {
        self.chart = chart
        self.yAxisLabel = yAxisLabel
        super.init(frame: .zero)
        
        addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        chart.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        chart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let entires = self.points.enumerated().map {
            ChartDataEntry(x: $1.x, y: $1.y, data: $0)
        }
        let set = LineChartDataSet(entries: entires, label: yAxisLabel)
        set.highlightEnabled = true
        set.circleColors = [.chartValueTint]
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled =  false
        set.colors = [.white]

        set.mode = .cubicBezier
        set.lineWidth = 3
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        chart.data = data
    }
}
