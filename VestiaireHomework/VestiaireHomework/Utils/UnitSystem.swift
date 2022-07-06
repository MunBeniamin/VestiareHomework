import Foundation
enum UnitSystem: String, CaseIterable {
    case metric
    case imperial
    
    var unitTemperature: UnitTemperature {
        switch self {
        case .imperial: return .fahrenheit
        case .metric: return .celsius
        }
    }
    
    var unitPressure: UnitPressure {
        switch self {
        case .imperial: return .millibars
        case .metric: return .millibars
        }
    }
}
