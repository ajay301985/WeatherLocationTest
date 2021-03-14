//
//  AddWeatherLocationViewController.swift
//  CodeTest
//
//  Created by Ajay Rawat on 2021-03-13.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

final class AddWeatherViewController: UIViewController {
  // MARK: Internal

  @IBOutlet var locationNameTextField: UITextField!
  @IBOutlet var tempratureTextField: UITextField!

  @IBOutlet var pickerView: UIPickerView!
  @IBOutlet var weatherStatusLabel: UILabel!
  var didAddLocation: (() -> Void)?

  static func create(viewModel: WeatherViewModel) -> AddWeatherViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AddWeatherViewController") as! AddWeatherViewController
    viewController.weatherViewModel = viewModel
    return viewController
  }

  private func addBottomBarToTextFields() {
    locationNameTextField.applyBottomBorder()
    tempratureTextField.applyBottomBorder()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.isHidden = true
    guard !WeatherLocation.Status.allCases.isEmpty else {
      return
    }

    if WeatherLocation.Status.allCases.count > 0 {
      currentWeatherStatus = WeatherLocation.Status.allCases[0] // select SUNNY weather by default
    }

    addBottomBarToTextFields()
  }

  private func hideKeyboard() {
    locationNameTextField.resignFirstResponder()
    tempratureTextField.resignFirstResponder()
  }

  @IBAction func changeWeatherStatusClicked(_ sender: Any) {
    hideKeyboard()
    pickerView.isHidden.toggle()
  }

  @IBAction func addLocationClicked(_ sender: Any) {
    if !isValidData {
      displayAlertMessage(title: "Error", message: "All field are mandatory")
    }

    addProgressBar(with: .gray)
    let location = getWeatherData()
    weatherViewModel.addWeatherLocation(locationToAdd: location) { [weak self] _, error in
      self?.removeProgressBar()
      guard let selfObj = self, (error == nil) else {
        self?.displayAlertMessage(message: error?.errorMessage)
        return
      }

      selfObj.didAddLocation?()
      DispatchQueue.main.async {
        selfObj.dismiss(animated: true, completion: nil)
      }
    }
  }

  // MARK: Private

  private var weatherViewModel: WeatherViewModel!

  private var currentWeatherStatus: WeatherLocation.Status? {
    didSet {
      weatherStatusLabel.text = currentWeatherStatus?.title
      weatherStatusLabel.backgroundColor = currentWeatherStatus?.backgroundColor
    }
  }

  private var isValidData: Bool {
    guard !(locationNameTextField.text?.isEmpty ?? true), !(tempratureTextField.text?.isEmpty ?? true) else {
      return false
    }
    return true
  }

  private func getWeatherData() -> WeatherLocation {
    let location = WeatherLocation(id: "", name: locationNameTextField.text ?? "", status: currentWeatherStatus ?? .sunny, temperature: Int(tempratureTextField.text ?? "0") ?? 0)
    return location
  }
}

extension AddWeatherViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    WeatherLocation.Status.allCases.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    WeatherLocation.Status.allCases[row].title + " " + WeatherLocation.Status.allCases[row].emoji
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentWeatherStatus = WeatherLocation.Status.allCases[row]
  }
}
