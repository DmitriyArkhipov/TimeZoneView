import Foundation

enum RegionDetailIntent {
    case selectDate(Date)
    case addTimezone(TimeZone)
    case deleteTimezone(IndexSet)
    case showTimezonePicker
    case hideTimezonePicker
} 