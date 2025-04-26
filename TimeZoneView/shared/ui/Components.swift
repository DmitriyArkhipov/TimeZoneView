import SwiftUI

struct TimeZoneListView: View {
    let date: Date
    let timezones: [TimeZone]
    let onAddTap: () -> Void
    let onDelete: (IndexSet) -> Void
    let onTimezoneTap: (TimeZone) -> Void
    let activeTimezone: TimeZone
    
    var body: some View {
        VStack {
            List {
                ForEach(timezones, id: \.identifier) { timezone in
                    TimeZoneRowView(
                        date: date,
                        timezone: timezone,
                        isActive: timezone.identifier == activeTimezone.identifier
                    )
                    .onTapGesture {
                        onTimezoneTap(timezone)
                    }
                }
                .onDelete(perform: onDelete)
            }
            
            Button(action: onAddTap) {
                Label("Add Timezone", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .padding()
        }
    }
}

struct TimePicker: View {
    let date: Date
    let onDateChange: (Date) -> Void
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Time",
                selection: Binding(
                    get: { date },
                    set: onDateChange
                ),
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
}

struct TimeZoneRowView: View {
    let date: Date
    let timezone: TimeZone
    let isActive: Bool
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timezone
        return formatter.string(from: date)
    }
    
    var name: String {
        timezone.identifier.components(separatedBy: "/").last ?? timezone.identifier
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(isActive ? .accentColor : .primary)
                Text(time)
                    .font(.system(size: 32, weight: .light))
            }
        }
        .padding(.vertical, 8)
    }
}
