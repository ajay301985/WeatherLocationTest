//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

final class WeatherViewController: UITableViewController {
  // MARK: Internal

  static func create() -> WeatherViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadWeatherLocations()
    setup()
  }

  // MARK: Private

  private let viewModel = WeatherViewModel()

  @objc
  private func addLocaion(_ sender: Any) {
    let viewController = AddWeatherViewController.create(viewModel: viewModel)
    viewController.didAddLocation = { [weak self] in
      guard let self = self else { return }
      self.reloadWeatherLocation()
    }
    present(viewController, animated: true, completion: nil)
  }

  @objc
  private func refreshLocaion(_ sender: Any) {
    loadWeatherLocations()
  }

  private func addBarButtonItem() {
    let doneButton = UIBarButtonItem(title: "+ Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addLocaion(_:)))
    navigationItem.rightBarButtonItem = doneButton

    let refreshButton = UIBarButtonItem(title: "Refresh", style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshLocaion(_:)))
    navigationItem.leftBarButtonItem = refreshButton
  }

  private func loadWeatherLocations() {
    addProgressBar(with: .whiteLarge)
    viewModel.weatherLocations { [weak self] isSuccess, error in
      guard let self = self else { return }
      self.removeProgressBar()
      DispatchQueue.main.async {
        if isSuccess {
          self.reloadWeatherLocation()
        } else {
          self.displayAlertMessage(message: error?.errorMessage)
        }
      }
    }
  }

  private func setup() {
    navigationItem.title = "Weather Code Test"
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    addBarButtonItem()
  }

  private func reloadWeatherLocation() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  private func deleteLocation(inWeatherLocation: WeatherLocation) {
    addProgressBar(with: .whiteLarge)
    viewModel.deleteWeatherLocation(location: inWeatherLocation) { [weak self] _, error in
      guard let self = self else { return }
      self.removeProgressBar()
      if error != nil { // Failed To delete location
        self.displayAlertMessage(message: error?.errorMessage)
      } else {
        self.reloadWeatherLocation()
      }
    }
  }
}



extension WeatherViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.weatherLocations.count // viwe.entries.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell

    let entry = viewModel.weatherLocations[indexPath.row]
    cell.setup(entry)

    return cell
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let location = viewModel.weatherLocations[indexPath.row]
      deleteLocation(inWeatherLocation: location)
    }
  }
}
