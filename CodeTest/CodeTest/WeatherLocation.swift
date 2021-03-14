//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

struct WeatherLocation: Codable {
    enum Status: String, Codable, CaseIterable {
        case cloudy = "CLOUDY"
        case sunny = "SUNNY"
        case mostlySunny = "MOSTLY_SUNNY"
        case partlySunnyRain = "PARTLY_SUNNY_RAIN"
        case thunderCloudAndRain = "THUNDER_CLOUD_AND_RAIN"
        case tornado = "TORNADO"
        case barelySunny = "BARELY_SUNNY"
        case lightening = "LIGHTENING"
        case snowCloud = "SNOW_CLOUD"
        case rainy = "RAINY"
    }
    let id: String
    let name: String
    let status: Status
    let temperature: Int
}


extension WeatherLocation.Status {
  var emoji: String {
    switch self {
      case .cloudy: return "☁️"
      case .sunny: return "☀️"
      case .mostlySunny: return "🌤"
      case .partlySunnyRain: return "🌦"
      case .thunderCloudAndRain: return "⛈"
      case .tornado: return "🌪"
      case .barelySunny: return "🌥"
      case .lightening: return "🌩"
      case .snowCloud: return "🌨"
      case .rainy: return "🌧"
    }
  }

  var title: String {
    return rawValue.replacingOccurrences(of: "_", with: " ")
  }

  var backgroundColor: UIColor {
    switch self {
      case .cloudy, .rainy, .snowCloud: return .lightGray
      case .tornado, .thunderCloudAndRain, .lightening: return UIColor(red: 255 / 255, green: 113 / 255, blue: 113 / 255, alpha: 1)
      case .sunny, .mostlySunny, .barelySunny, .partlySunnyRain: return UIColor(red: 114 / 255, green: 168 / 255, blue: 255 / 255, alpha: 1)
    }
  }
}
