//
//  ChartBuilder.swift
//  App
//
//  Created by Andrew Arnopoulos on 3/7/21.
//

import Charts
import UIKit

struct ChartBuilder {
    func oneRepMaxChart() -> LineChart {
        //TODO Create single source of truth for view customization
        //Due to the charting library dispersed data sources for
        //setting up the chart there are currently two places where
        //we setup custom view code. Here and in the LineChartWrapperView.setup
        //function.
        //We also do not want to put this setup code in the LineChartWrapperView
        //because this will hurt the LineChartWrapperView's reusablility in the
        //future.
        let chart = LineChartView()
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.gridBackgroundColor = .chartGridColor
        let xAxis = chart.xAxis
        xAxis.valueFormatter = EPOCHValueFormatter()
        xAxis.labelPosition = .bottom
        chart.legend.enabled = false
        
        //TODO Might want to toggle based on locale
        let rightAxis = chart.rightAxis
        rightAxis.drawLabelsEnabled = false
        
        let wrapper = LineChartWrapperView(chart, yAxisLabel: "Weight")
        return wrapper
    }
}

struct Point2D {
    var x: Double
    var y: Double
}

protocol LineChart: UIView {
    var points: [Point2D] { get set }
}

extension ChartBuilder {
    private class EPOCHValueFormatter: AxisValueFormatter {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            //TODO Handle different locales
            formatter.dateFormat = "MMM dd"
            return formatter
        }()

        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let date = Date(timeIntervalSince1970: value)
            return formatter.string(from: date)
        }
    }
}
