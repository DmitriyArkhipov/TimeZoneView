import SwiftUI

@MainActor
final class RegionDetailViewModel: ObservableObject {
    @Published private(set) var state: RegionDetailState
    let onTimezonesChange: ([TimeZone]) -> Void
    
    init(timezone: TimeZone, timezones: [TimeZone], currentDate: Date, onTimezonesChange: @escaping ([TimeZone]) -> Void) {
        self.onTimezonesChange = onTimezonesChange
        state = RegionDetailState.initial(timezone: timezone, timezones: timezones, currentDate: currentDate)
        print("Init with timezone: \(timezone.identifier), offset: \(timezone.secondsFromGMT())")
    }
    
    func dispatch(_ intent: RegionDetailIntent) {
        switch intent {
        case .selectDate(let date):
            state.date = date
            print("Selected date: \(date)")
        case .addTimezone(let timezone):
            if !state.timezones.contains(where: { $0.identifier == timezone.identifier }) {
                state.timezones.append(timezone)
                onTimezonesChange(state.timezones)
            }
            state.showingTimezonePicker = false
        case .deleteTimezone(let indexSet):
            state.timezones.remove(atOffsets: indexSet)
            onTimezonesChange(state.timezones)
        case .showTimezonePicker:
            state.showingTimezonePicker = true
        case .hideTimezonePicker:
            state.showingTimezonePicker = false
        }
    }
    
    // Получаем время для отображения в других часовых поясах
    func getTimeForTimezone(_ targetTimezone: TimeZone) -> Date {
        // Получаем разницу в секундах между исходным и целевым часовыми поясами
        let sourceOffset = state.timezone.secondsFromGMT(for: state.date)
        let targetOffset = targetTimezone.secondsFromGMT(for: state.date)
        let difference = Double(targetOffset - sourceOffset)
        
        print("Converting time:")
        print("Source timezone: \(state.timezone.identifier), offset: \(sourceOffset)")
        print("Target timezone: \(targetTimezone.identifier), offset: \(targetOffset)")
        print("Difference: \(difference) seconds")
        
        // Применяем разницу к дате
        return state.date.addingTimeInterval(difference)
    }
    
    // Конвертируем время из одного часового пояса в другой
    func convertTime(date: Date, from sourceTimezone: TimeZone, to targetTimezone: TimeZone) -> Date {
        let sourceOffset = sourceTimezone.secondsFromGMT(for: date)
        let targetOffset = targetTimezone.secondsFromGMT(for: date)
        let difference = Double(targetOffset - sourceOffset)
        return date.addingTimeInterval(difference)
    }
} 