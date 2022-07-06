import Foundation

struct DayWeather: Codable {
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let temp: Temperature
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
}

extension DayWeather {
    static var mock: DayWeather {
        DayWeather(dt: 100,
                   sunrise: 100,
                   sunset: 100,
                   temp: Temperature.mock,
                   pressure: 10,
                   humidity: 10,
                   weather: [Weather.mock])
    }
}
