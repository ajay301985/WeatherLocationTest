//
//  weatherViewModel.swift
//  CodeTest
//
//  Created by Ajay Rawat on 2021-03-13.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

final class WeatherViewModel {
  // MARK: Public

  public var weatherLocations: [WeatherLocation] = []

  // MARK: Internal

  func weatherLocations(completion: @escaping (Bool, NetworkError?) -> Void) {
    WeatherLocationService.getLocations { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let locationResult):
          self.weatherLocations = locationResult.locations
          completion(true, nil)
        case .failure(let error):
          completion(false, error)
      }
    }
  }

  func addLocation(location: WeatherLocation) {
    weatherLocations.append(location)
  }

  func deleteLocation(location: WeatherLocation) {
    weatherLocations = weatherLocations.filter { $0.id != location.id }
  }

  func addWeatherLocation(locationToAdd: WeatherLocation, completion: @escaping (WeatherLocation?, NetworkError?) -> Void) {
    do {
      let data = try JSONEncoder().encode(locationToAdd)
      WeatherLocationService.addLocation(parameters: data) { [weak self] result in
        guard let self = self else { return }
        switch result {
          case .success(let location):
            self.addLocation(location: location)
            completion(location, nil)
          case .failure(let error):
            completion(nil, error)
        }
      }
    } catch {
      print(error)
    }
  }

  func deleteWeatherLocation(location: WeatherLocation, completion: @escaping (Bool, NetworkError?) -> Void) {
    WeatherLocationService.deleteLocation(weatherLocationId: location.id) {[weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let isSuccess):
          self.deleteLocation(location: location)
          completion(isSuccess, nil)
        case .failure(let error):
          completion(false, error)
      }
    }
  }
}
