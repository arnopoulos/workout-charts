//
//  ExerciseListViewController.swift
//  App
//
//  Created by Andrew Arnopoulos on 2/28/21.
//

import Business
import UIKit

class ExerciseListViewController: UITableViewController {
    private static let location: URL = {
        //TODO error handling
        let path = Bundle.main.path(forResource: "WorkoutData", ofType: "txt")!
        return URL(string: "file://\(path)")!
    }()
    private let service = ExerciseService(location: ExerciseListViewController.location)
    private var indexer = ExerciseIndexer([]) {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calling in view did load to prevent multiple calls
        //to this service. If we need to reload data from
        //here we can revisit this when it becomes an issue
        service.load { (result: Result<ExerciseIndexer, Error>) in
            //TODO Handle error if we get one
            guard case let .success(value) = result else { return }
            DispatchQueue.main.async { [weak self] in
                self?.indexer = value
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath,
              let viewController = segue.destination as? ExerciseSummaryViewController else {
            return
        }
        viewController.exercise = indexer.exercises[indexPath.row]
    }
}

// MARK: UITableViewDataSource
extension ExerciseListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        indexer.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Summary") as? ExerciseSummaryCell else {
            return UITableViewCell()
        }
        let exercise = indexer.exercises[indexPath.row]
        cell.title.text = exercise.name
        cell.weight.text = String(
            format: "%.1f lbs", exercise.data.last?.oneRepMax ?? 0
        )
        return cell
    }
}

//MARK: UITableViewDelegate
extension ExerciseListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Summary", sender: indexPath)
    }
}

class ExerciseSummaryCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var weight: UILabel!
    
    override func prepareForReuse() {
        title.text = ""
        weight.text = ""
    }
}

