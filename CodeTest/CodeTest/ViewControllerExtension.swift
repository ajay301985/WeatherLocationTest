//
//  ViewControllerExtension.swift
//  CodeTest
//
//  Created by Ajay Rawat on 2021-03-14.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func addProgressBar(with style: UIActivityIndicatorView.Style) {
    DispatchQueue.main.async {
      let spinner = UIActivityIndicatorView(style: style)
      spinner.translatesAutoresizingMaskIntoConstraints = false
      spinner.startAnimating()
      spinner.tag = 1001
      self.view.addSubview(spinner)
      spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
      spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
      self.view.isUserInteractionEnabled = false
    }
  }

  func removeProgressBar() {
    DispatchQueue.main.async {
      self.view.viewWithTag(1001)?.removeFromSuperview()
      self.view.isUserInteractionEnabled = true
    }
  }

  func displayAlertMessage(title: String? = nil, message: String? = nil) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: title ?? "Error", message: message ?? "Something went wrong", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true)
    }
  }
}

extension UIViewController: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension UITextField {
  func applyBottomBorder() {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
    bottomLine.backgroundColor = UIColor.black.cgColor
    borderStyle = .none
    layer.addSublayer(bottomLine)
  }
}
