import SwiftUI

struct RegionDetailView: View {
    @StateObject private var viewModel: RegionDetailViewModel
    let previousRegionName: String
    
    init(timezone: TimeZone, timezones: [TimeZone], currentDate: Date, onTimezonesChange: @escaping ([TimeZone]) -> Void, previousRegionName: String? = nil) {
        _viewModel = StateObject(wrappedValue: RegionDetailViewModel(
            timezone: timezone,
            timezones: timezones,
            currentDate: currentDate,
            onTimezonesChange: onTimezonesChange
        ))
        self.previousRegionName = previousRegionName ?? "Regions"
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Main timezone and additional timezones
                VStack {
                    // Additional timezones
                    List {
                        ForEach(viewModel.state.timezones, id: \.identifier) { timezone in
                            NavigationLink(value: NestedTimeZoneDestination(timezone: timezone)) {
                                TimeZoneRowView(
                                    date: viewModel.state.date,
                                    timezone: timezone,
                                    isActive: timezone.identifier == viewModel.state.timezone.identifier
                                )
                            }
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(viewModel.state.timezone.identifier.components(separatedBy: "/").last ?? viewModel.state.timezone.identifier)
                    .foregroundColor(.primary)
                    .font(.headline)
            }
        }
        .navigationDestination(for: NestedTimeZoneDestination.self) { destination in
            RegionDetailView(
                timezone: destination.timezone,
                timezones: viewModel.state.timezones,
                currentDate: viewModel.state.date,
                onTimezonesChange: { newTimezones in
                    viewModel.dispatch(.updateTimezones(newTimezones))
                },
                previousRegionName: destination.timezone.identifier.components(separatedBy: "/").last ?? "Region"
            )
        }
        .sheet(isPresented: Binding(
            get: { viewModel.state.showingTimezonePicker },
            set: { if !$0 { viewModel.dispatch(.hideTimezonePicker) } }
        )) {
            TimeZonePickerView(
                selectedTimezones: viewModel.state.timezones,
                onSelect: { timezone in
                    viewModel.dispatch(.addTimezone(timezone))
                }
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