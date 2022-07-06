import Foundation
import Combine

protocol WeatherManager {
    func getWeatherForecast(city: String, units: UnitSystem, days: Int) -> AnyPublisher<Forecast, Error>
}

class RealWeatherManager: WeatherManager {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getWeatherForecast(city: String, units: UnitSystem = .metric, days: Int) -> AnyPublisher<Forecast, Error> {
        let endpoint = Endpoint.forecast(city: city, units: units, days: days)
        
        return networkManager.get(type: Forecast.self, url: endpoint.url, headers: endpoint.headers)
    }
}
