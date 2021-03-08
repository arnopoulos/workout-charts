//
//  ExerciseSummaryViewController.swift
//  App
//
//  Created by Andrew Arnopoulos on 3/6/21.
//

import Business
import Charts
import UIKit

class ExerciseSummaryViewController: UIViewController {
    
    var exercise: ExerciseIndexer.Exercise! {
        didSet {
            setup()
        }
    }
    
    private let builder = ChartBuilder()
    private lazy var chart = builder.oneRepMaxChart()

    override func viewDidLoad() {
        super.viewDidLoad()

        let container = UIView()
        container.backgroundColor = .black
        container.clipsToBounds = true
        container.layer.cornerRadius = 16

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: 2.0 / 3.0).isActive = true
        
        
        container.addSubview(chart)
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(
            equalTo: container.layoutMarginsGuide.leadingAnchor
        ).isActive = true
        chart.topAnchor.constraint(
            equalTo: container.layoutMarginsGuide.topAnchor
        ).isActive = true
        chart.trailingAnchor.constraint(
            equalTo: container.layoutMarginsGuide.trailingAnchor
        ).isActive = true
        chart.bottomAnchor.constraint(
            equalTo: container.layoutMarginsGuide.bottomAnchor
        ).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var margins = view.directionalLayoutMargins
        margins.top = margins.leading
        view.directionalLayoutMargins = margins
    }
    
    private func setup() {
        title = exercise.name
        chart.points = exercise.data.map {
            Point2D(x: $0.date.timeIntervalSince1970, y: $0.oneRepMax)
        }
    }
}
