//
//  WeatherLocationService.swift
//  CodeTest
//
//  Created by Ajay Rawat on 2021-03-13.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

enum Request {
  case getWeatherLocations
  case addLocation(location: Data)
  case deleteLocation(locationId: String)

  // MARK: Internal

  var endpoint: String {
    switch self {
      case .getWeatherLocations, .addLocation:
        return "https://app-code-test.kry.pet/locations"
      case .deleteLocation(let locationId):
        return "https://app-code-test.kry.pet/locations/\(locationId)"
    }
  }

  var httpMethod: String {
    switch self {
      case .getWeatherLocations:
        return "GET"
      case .addLocation:
        return "POST"
      case .deleteLocation:
        return "DELETE"
    }
  }

  var httpBody: Data? {
    switch self {
      case .addLocation(let locationData):
        return locationData
      default:
        return nil
    }
  }

  var apiKey: String {
    guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
      let key = UUID().uuidString
      UserDefaults.standard.set(key, forKey: "API_KEY")
      return key
    }
    return apiKey
  }

  var urlRequest: URLRequest {
    var urlRequest = URLRequest(url: URL(string: endpoint)!)
    urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
    urlRequest.httpMethod = httpMethod
    guard let locationData = httpBody else {
      return urlRequest
    }
    urlRequest.httpBody = locationData
    return urlRequest
  }
}

struct LocationsResult: Decodable {
  var locations: [WeatherLocation]
}

enum NetworkError: Error {
  case badRequest
  case requestTimeOut
  case noNetworkConnection
  case unknown

  // MARK: Internal

  var errorMessage: String {
    switch self {
      case .badRequest:
        return "Check your network connection"
      case .unknown:
        return "Internal Server error: Server is not responding"
      default:
        return "Not connected to network or poor connection, check your network"
    }
  }

  var debugDescription: String {
    switch self {
      case .badRequest:
        return "Bad API request, some field is missing in the request"
      case .unknown:
        return "Internal Server error"
      default:
        return "Request Time out"
    }
  }

  static func error(code: Int? = 0) -> NetworkError {
    switch code {
      case 400:
        return .badRequest
      case 500:
        return .unknown
      default:
        return requestTimeOut
    }
  }
}


final class WeatherLocationService {
  private static let TIMEOUT_INTERVAL = 10.0
  
  static func getLocations(completion: @escaping (Swift.Result<LocationsResult, NetworkError>) -> Void) {
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = TIMEOUT_INTERVAL
    URLSession(configuration: urlconfig).dataTask(with: Request.getWeatherLocations.urlRequest) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
        (200 ... 299).contains(httpResponse.statusCode)
      else {
        completion(.failure(NetworkError.error()))
        return
      }
      do {
        guard let data = data else {
          completion(.failure(NetworkError.error()))
          return
        }
        let result = try JSONDecoder().decode(LocationsResult.self, from: data)
        completion(.success(result))
      } catch (_) {
        completion(.failure(NetworkError.error(code: httpResponse.statusCode)))
      }
    }.resume()
  }

  static func addLocation(parameters: Data, completion: @escaping (Swift.Result<WeatherLocation, NetworkError>) -> Void) {
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = TIMEOUT_INTERVAL

    URLSession(configuration: urlconfig).dataTask(with: Request.addLocation(location: parameters).urlRequest) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode)
      else {
        completion(.failure(NetworkError.error()))
        return
      }

      do {
        guard let data = data else {
          completion(.failure(NetworkError.error()))
          return
        }
        let result = try JSONDecoder().decode(WeatherLocation.self, from: data)
        completion(.success(result))
      } catch (_) {
        completion(.failure(NetworkError.error(code: httpResponse.statusCode)))
      }
    }.resume()
  }

  static func deleteLocation(weatherLocationId: String, completion: @escaping (Swift.Result<Bool, NetworkError>) -> Void) {
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = TIMEOUT_INTERVAL

    URLSession(configuration: urlconfig).dataTask(with: Request.deleteLocation(locationId: weatherLocationId).urlRequest) { _, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode)
      else {
        completion(.failure(NetworkError.error()))
        return
      }

      completion(.success(true))
    }.resume()
  }
}
