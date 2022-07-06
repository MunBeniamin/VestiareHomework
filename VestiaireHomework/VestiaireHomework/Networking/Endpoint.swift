import Foundation

struct Endpoint {
    var path: String
    var querryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/" + path
        components.queryItems = querryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var headers : [String: Any] {
        return [:]
    }
}

extension Endpoint {
    static func forecast(city: String, units: UnitSystem, days: Int) -> Self {
        Endpoint(path: "forecast/daily", querryItems: [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: units.rawValue),
            URLQueryItem(name: "cnt", value: "\(days)"),
            URLQueryItem(name: "appid", value: "648a3aac37935e5b45e09727df728ac2")
        ])
    }
}
