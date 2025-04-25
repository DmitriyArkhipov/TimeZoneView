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
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                TimeZoneListView(
                    date: state.selectedDate,
                    timezones: state.selectedTimezones,
                    onAddTap: { intent(.showTimezonePicker) },
                    onDelete: { intent(.deleteTimezone($0)) },
                    onTimezoneTap: { selectedTimezone = $0 }
                )
                .frame(width: geometry.size.width / 2)
                
                TimePicker(
                    date: state.selectedDate,
                    onDateChange: { intent(.selectDate($0)) }
                )
                .frame(width: geometry.size.width / 2)
                .clipped()
            }
        }
        .sheet(isPresented: Binding(
            get: { state.showingTimezonePicker },
            set: { if !$0 { intent(.hideTimezonePicker) } }
        )) {
            TimeZonePickerView(
                selectedTimezones: state.selectedTimezones,
                onSelect: { intent(.addTimezone($0)) }
            )
        }
        .sheet(item: Binding(
            get: { selectedTimezone },
            set: { selectedTimezone = $0 }
        )) { timezone in
            RegionDetailView(
                timezone: timezone,
                timezones: state.selectedTimezones,
                currentDate: state.selectedDate,
                onTimezonesChange: { newTimezones in
                    intent(.updateTimezones(newTimezones))
                }
            )
        }
    }
}

extension TimeZone: Identifiable {
    public var id: String { identifier }
}

struct TimeZoneRootView_Prview: PreviewProvider {
    @StateObject private var viewModel = TimeZoneViewModel()

    static var previews: some View {
        ContentView()
    }
}
