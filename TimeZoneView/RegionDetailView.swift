import SwiftUI

struct RegionDetailView: View {
    @StateObject private var viewModel: RegionDetailViewModel
    
    init(timezone: TimeZone, timezones: [TimeZone], currentDate: Date, onTimezonesChange: @escaping ([TimeZone]) -> Void) {
        _viewModel = StateObject(wrappedValue: RegionDetailViewModel(
            timezone: timezone,
            timezones: timezones,
            currentDate: currentDate,
            onTimezonesChange: onTimezonesChange
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Main timezone and additional timezones
                VStack {
                    // Additional timezones
                    List {
                        ForEach(viewModel.state.timezones, id: \.identifier) { timezone in
                            TimeZoneRowView(
                                date: viewModel.state.date,
                                timezone: timezone
                            )
                        }
                        .onDelete { indexSet in
                            viewModel.dispatch(.deleteTimezone(indexSet))
                        }
                    }
                    
                    Button(action: { viewModel.dispatch(.showTimezonePicker) }) {
                        Label("Add Timezone", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                    .padding()
                }
                .frame(width: geometry.size.width / 2)
                
                // Time picker
                TimePicker(
                    date: viewModel.state.date,
                    onDateChange: { viewModel.dispatch(.selectDate($0)) }
                )
                .environment(\.timeZone, viewModel.state.timezone)
                .frame(width: geometry.size.width / 2)
                .clipped()
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel.state.showingTimezonePicker },
            set: { if !$0 { viewModel.dispatch(.hideTimezonePicker) } }
        )) {
            TimeZonePickerView(
                selectedTimezones: viewModel.state.timezones,
                onSelect: { viewModel.dispatch(.addTimezone($0)) }
            )
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = viewModel.state.timezone
        return formatter.string(from: viewModel.state.date)
    }
}

#Preview {
    RegionDetailView(
        timezone: TimeZone.current,
        timezones: [TimeZone.current],
        currentDate: Date(),
        onTimezonesChange: { _ in }
    )
} 