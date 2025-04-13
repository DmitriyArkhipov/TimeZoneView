import Foundation

struct TimeZoneStorage {
    private static let selectedTimezonesKey = "com.timeZoneView.selectedTimezones"
    
    static func saveTimezones(_ timezones: [TimeZone]) {
        // Сохраняем только идентификаторы часовых поясов, так как TimeZone нельзя напрямую сохранить
        let identifiers = timezones.map { $0.identifier }
        UserDefaults.standard.set(identifiers, forKey: selectedTimezonesKey)
    }
    
    static func loadTimezones() -> [TimeZone] {
        guard let identifiers = UserDefaults.standard.stringArray(forKey: selectedTimezonesKey) else {
            // Если данных нет, возвращаем текущий часовой пояс
            return [TimeZone.current]
        }
        
        // Преобразуем идентификаторы обратно в объекты TimeZone
        return identifiers.compactMap { TimeZone(identifier: $0) }
    }
}
