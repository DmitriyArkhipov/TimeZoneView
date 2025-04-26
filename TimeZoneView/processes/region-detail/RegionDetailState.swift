import Foundation

struct RegionDetailState {
    let timezone: TimeZone
    var date: Date
    var timezones: [TimeZone]
    var showingTimezonePicker: Bool
    
    static func initial(timezone: TimeZone, timezones: [TimeZone], currentDate: Date) -> RegionDetailState {
        RegionDetailState(
            timezone: timezone,
            date: currentDate,
            timezones: timezones,
            showingTimezonePicker: false
        )
    }
} 