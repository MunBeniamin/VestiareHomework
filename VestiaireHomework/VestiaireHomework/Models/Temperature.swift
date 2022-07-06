struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

extension Temperature {
    static var mock: Temperature {
        Temperature(day: 10, min: 10, max: 10, night: 10, eve: 10, morn: 10)
    }
}
