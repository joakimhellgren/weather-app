//
//  ViewController.swift
//  weather-app
//
//  Created by Joakim Hellgren on 2021-02-27.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.alwaysBounceVertical = true
        return scrollview
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for a location.."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    
    private func setupUI() {
        
        searchTextField.frame = CGRect(x: 16, y: 16,
                                       width: view.frame.size.width - 48, height: 32)
        scrollView.addSubview(searchTextField)
        
        searchButton.frame = CGRect(x: searchTextField.frame.width + 16, y: 16,
                                    width: 32, height: 32)
        searchButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        scrollView.addSubview(searchButton)
        
        cityLabel.frame = CGRect(x: 16, y: 0,
                                 width: view.frame.size.width - 32, height: 48)
        cityLabel.center = CGPoint(x: view.center.x, y: 84)
        scrollView.addSubview(cityLabel)
        
        conditionImageView.frame = CGRect(x: 16, y: 0,
                                          width: 48, height: 48)
        conditionImageView.center = CGPoint(x: view.center.x, y: view.center.y)
        scrollView.addSubview(conditionImageView)
        
        tempLabel.frame = CGRect(x: 16, y: 100,
                                 width: view.frame.width, height: 48)
        scrollView.addSubview(tempLabel)
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    
    @objc func buttonAction(sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search for weather"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        textField.text = ""
        
    }
}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {

    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
