import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        formatted(.dateTime.day().month(.wide).year())
    }
}
