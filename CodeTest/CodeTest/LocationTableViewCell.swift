//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    static var reuseIdentifier: String {
        return "cellReuseIdentifier"
    }

    func setup(_ entry: WeatherLocation) {
        cityNameLabel.text = entry.name
        statusLabel.text = entry.status.emoji
        temperatureLabel.text = "\(entry.temperature)ºC"
        cardView.backgroundColor = entry.status.backgroundColor
    }
}

