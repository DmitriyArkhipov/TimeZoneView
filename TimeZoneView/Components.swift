import SwiftUI

struct TimeZoneListView: View {
    let date: Date
    let timezones: [TimeZone]
    let onAddTap: () -> Void
    let onDelete: (IndexSet) -> Void
    let onTimezoneTap: (TimeZone) -> Void
    
    var body: some View {
        VStack {
            List {
                ForEach(timezones, id: \.identifier) { timezone in
                    TimeZoneRowView(date: date, timezone: timezone)
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
                    .font(.headline)
                Text(time)
                    .font(.system(size: 34, weight: .light))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}