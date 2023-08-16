//
//  ViewController.swift
//  WeatherProject
//
//  Created by berfin doksöz on 16.08.2023.
//

import UIKit
import SnapKit

class WeatherView: UIViewController {
    
    var weatherVM = WeatherViewModel()

    private let imageView: UIImageView = {
        let image = UIImage(named: "dark_background")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let locationBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let textFieldSearch: UITextField = {
        let field = UITextField()
        field.placeholder = "Search"
        field.font = UIFont.systemFont(ofSize: 25)
        field.borderStyle = .roundedRect
        field.textColor = .white
        field.textAlignment = .right
        field.returnKeyType = .go
        field.backgroundColor = .systemFill
        return field
    }()
    
    private let searchBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            locationBtn,
            textFieldSearch,
            searchBtn
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let conditionImageView: UIImageView = {
        let image = UIImage(systemName: "cloud.rain")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    private var tempLabel1: UILabel = {
        let label = UILabel()
        label.text = "21"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .right
        label.contentMode = .left
        return label
    }()
    
    private let tempLabel2: UILabel = {
        let label = UILabel()
        label.text = "°"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .left
        label.contentMode = .left
        return label
    }()
    
    private let tempLabel3: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .left
        label.contentMode = .left
        return label
    }()
    
    private lazy var degreeStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
            tempLabel1,
            tempLabel2,
            tempLabel3
       ])
        stack.axis = .horizontal
        stack.spacing = 0
        return stack
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "London"
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            hStackView,
            conditionImageView,
            degreeStackView,
            cityLabel,
            UIView()
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .trailing
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherVM.delegate = self
        textFieldSearch.delegate = self
        layout()
    }
    
    @objc func searchPressed(){
        textFieldSearch.endEditing(true)
    }
    
    private func layout(){
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(vStackView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        locationBtn.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        hStackView.snp.makeConstraints { make in
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
    }


}

extension WeatherView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text{
            weatherVM.fetchData(cityName: city)
        }
        
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

extension WeatherView: WeatherViewModelProtocol {
    func didUpdateWeather(_ weatherVM: WeatherViewModel, weather: WeatherModel) {
        print(weather)
        DispatchQueue.main.async {
            self.tempLabel1.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

