import Foundation

// Wrapper для навигации на первом уровне (из списка регионов)
struct TimeZoneDestination: Hashable {
    let timezone: TimeZone
}

// Wrapper для навигации на втором уровне (из детального просмотра региона)
struct NestedTimeZoneDestination: Hashable {
    let timezone: TimeZone
}
