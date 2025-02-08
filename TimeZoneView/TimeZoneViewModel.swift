import SwiftUI

@MainActor
final class TimeZoneViewModel: ObservableObject {
    @Published private(set) var state: TimeZoneState = .initial
    
    func dispatch(_ intent: TimeZoneIntent) {
        switch intent {
        case .selectDate(let date):
            state.selectedDate = date
        case .addTimezone(let timezone):
            if !state.selectedTimezones.contains(where: { $0.identifier == timezone.identifier }) {
                state.selectedTimezones.append(timezone)
            }
            state.showingTimezonePicker = false
        case .deleteTimezone(let indexSet):
            state.selectedTimezones.remove(atOffsets: indexSet)
        case .showTimezonePicker:
            state.showingTimezonePicker = true
        case .hideTimezonePicker:
            state.showingTimezonePicker = false
        }
    }
}