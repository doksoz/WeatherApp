//
//  WeatherViewModel.swift
//  WeatherProject
//
//  Created by berfin doksöz on 17.08.2023.
//

import Foundation

protocol WeatherViewModelProtocol {
    func didUpdateWeather(_ weatherVM: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherViewModel {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=13915482d193cd2611021d2b00e8eafb&units=metric"
    
    var delegate: WeatherViewModelProtocol?
    
    func fetchData(cityName: String) {
        
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            return nil
        }
    }
    
}
