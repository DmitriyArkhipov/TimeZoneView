import Foundation

struct TimeZoneState {
    var selectedDate: Date
    var selectedTimezones: [TimeZone]
    var showingTimezonePicker: Bool
    
    static let initial = TimeZoneState(
        selectedDate: Date(),
        selectedTimezones: [TimeZone.current],
        showingTimezonePicker: false
    )
}