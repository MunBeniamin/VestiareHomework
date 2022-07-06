struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

extension Weather {
    static var mock: Weather {
        Weather(main: "Clear", description: "desc", icon: "icon")
    }
}
