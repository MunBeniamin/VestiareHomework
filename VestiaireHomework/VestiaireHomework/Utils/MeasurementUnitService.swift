import Foundation
protocol MeasurementUnitService: AnyObject {
    var temperatureSymbol: String { get }
    var pressureSymbol: String { get }
    func displayTemperature(_ value: Double, from: UnitTemperature, decimalPlaces: Int) -> String
}

class RealMeasurementUnitService: MeasurementUnitService {
    let locale: Locale
    
    init(locale: Locale = .current) {
        self.locale = locale
    }
    
    func displayTemperature(_ value: Double, from: UnitTemperature, decimalPlaces: Int) -> String {
        let measurement = Measurement<UnitTemperature>(value: value, unit: from)
        return measurement.formatter(decimalPlaces: decimalPlaces, locale: locale)
    }
    
    var temperatureSymbol: String {
        DIContainer.current.unitSystem.unitTemperature.symbol
    }
    
    var pressureSymbol: String {
        DIContainer.current.unitSystem.unitPressure.symbol
    }
}

extension Measurement {
    func formatter(decimalPlaces: Int, locale: Locale = .current) -> String {
        NumberFormatter.decimal(decimalPlaces: decimalPlaces, locale: locale).string(from: NSNumber(value: value)) ?? ""
    }
}

extension NumberFormatter {
    internal static func build(numberStyle: Style = .none,
                      locale: Locale = .current,
                      decimalPlaces: Int = 0,
                      minimumIntegerDigits: Int = 0) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = numberStyle
        numberFormatter.locale = locale
        numberFormatter.minimumFractionDigits = decimalPlaces
        numberFormatter.maximumFractionDigits = decimalPlaces
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        
        return numberFormatter
    }
    
    static func decimal(decimalPlaces: Int, locale: Locale = .current) -> NumberFormatter {
        build(numberStyle: .decimal, locale: locale, decimalPlaces: decimalPlaces, minimumIntegerDigits: 1)
    }
}
