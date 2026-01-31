import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimeZoneViewModel()
    
    var body: some View {
        TimeZoneRootView(
            state: viewModel.state,
            intent: viewModel.dispatch
        )
    }
}

struct TimeZoneRootView: View {
    let state: TimeZoneState
    let intent: (TimeZoneIntent) -> Void
    @State private var selectedTimezone: TimeZone?
    
    private var currentRegionName: String {
        (selectedTimezone ?? state.selectedTimezones.first ?? .current).identifier.components(separatedBy: "/").last ?? "Time Zones"
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    VStack {
                        List {
                            ForEach(state.selectedTimezones) { timezone in
                                NavigationLink(value: TimeZoneDestination(timezone: timezone)) {
                                    TimeZoneRowView(
                                        date: state.selectedDate,
                                        timezone: timezone,
                                        isActive: timezone.identifier == (selectedTimezone?.identifier ?? state.selectedTimezones.first?.identifier)
                                    )
                                }
                            }
                            .onDelete { intent(.deleteTimezone($0)) }
                        }
                        
                        Button(action: { intent(.showTimezonePicker) }) {
                            Label("Add Timezone", systemImage: "plus.circle.fill")
                                .font(.headline)
                        }
                        .padding()
                    }
                    .frame(width: geometry.size.width / 2)
                    
                    TimePicker(
                        date: state.selectedDate,
                        onDateChange: { intent(.selectDate($0)) }
                    )
                    .frame(width: geometry.size.width / 2)
                    .clipped()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(currentRegionName)
                        .foregroundColor(.primary)
                        .font(.headline)
                }
            }
            .navigationDestination(for: TimeZoneDestination.self) { destination in
                RegionDetailView(
                    timezone: destination.timezone,
                    timezones: state.selectedTimezones,
                    currentDate: state.selectedDate,
                    onTimezonesChange: { newTimezones in
                        intent(.updateTimezones(newTimezones))
                    },
                    previousRegionName: currentRegionName
                )
            }
            .navigationDestination(for: NestedTimeZoneDestination.self) { destination in
                RegionDetailView(
                    timezone: destination.timezone,
                    timezones: state.selectedTimezones,
                    currentDate: state.selectedDate,
                    onTimezonesChange: { newTimezones in
                        intent(.updateTimezones(newTimezones))
                    },
                    previousRegionName: destination.timezone.identifier.components(separatedBy: "/").last ?? "Region"
                )
            }
            .sheet(isPresented: Binding(
                get: { state.showingTimezonePicker },
                set: { if !$0 { intent(.hideTimezonePicker) } }
            )) {
                TimeZonePickerView(
                    selectedTimezones: state.selectedTimezones,
                    onSelect: { timezone in
                        intent(.addTimezone(timezone))
                    }
                )
            }
            .fadeNavigationTransition()
        }
    }
}

extension TimeZone: Identifiable {
    public var id: String { identifier }
}

struct TimeZoneRootView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
