import Foundation
enum FormatterFactory {
    case iso8601
    
    func build(format: String = "yyyy-mm-dd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = .current
        formatter.dateFormat = format
        
        return formatter
    }
}

extension Date {
    var dayName: String {
        return FormatterFactory.iso8601.build(format: "EE").string(from: self)
    }
    
    var time: String {
        return FormatterFactory.iso8601.build(format: "HH:mm").string(from: self)
    }
}


