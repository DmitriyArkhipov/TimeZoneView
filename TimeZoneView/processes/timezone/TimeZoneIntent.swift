import Foundation

enum TimeZoneIntent {
    case selectDate(Date)
    case addTimezone(TimeZone)
    case deleteTimezone(IndexSet)
    case showTimezonePicker
    case hideTimezonePicker
    case updateTimezones([TimeZone])
}