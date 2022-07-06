import Foundation

struct Forecast: Codable {
    let city: City
    let list: [DayWeather]
}

extension Forecast {
    static var mock: Forecast {
        Forecast(city: City(name: "Paris"), list: [DayWeather.mock])
    }
}

struct City: Codable {
    let name: String
}
