import SwiftUI

@MainActor
final class TimeZoneViewModel: ObservableObject {
    @Published private(set) var state: TimeZoneState
    
    init() {
        // Загружаем сохраненные часовые пояса при инициализации
        let savedTimezones = TimeZoneStorage.loadTimezones()
        state = TimeZoneState(
            selectedDate: Date(),
            selectedTimezones: savedTimezones,
            showingTimezonePicker: false
        )
    }
    
    func dispatch(_ intent: TimeZoneIntent) {
        switch intent {
        case .selectDate(let date):
            state.selectedDate = date
        case .addTimezone(let timezone):
            if !state.selectedTimezones.contains(where: { $0.identifier == timezone.identifier }) {
                state.selectedTimezones.append(timezone)
                // Сохраняем изменения
                TimeZoneStorage.saveTimezones(state.selectedTimezones)
            }
            state.showingTimezonePicker = false
        case .deleteTimezone(let indexSet):
            state.selectedTimezones.remove(atOffsets: indexSet)
            // Сохраняем изменения
            TimeZoneStorage.saveTimezones(state.selectedTimezones)
        case .showTimezonePicker:
            state.showingTimezonePicker = true
        case .hideTimezonePicker:
            state.showingTimezonePicker = false
        }
    }
}
