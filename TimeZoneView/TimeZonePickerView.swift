import SwiftUI

struct TimeZonePickerView: View {
    @Environment(\.dismiss) var dismiss
    let selectedTimezones: [TimeZone]
    let onSelect: (TimeZone) -> Void
    
    @State private var searchText = ""
    
    var filteredTimezones: [TimeZone] {
        let allTimezones = TimeZone.knownTimeZoneIdentifiers.compactMap { TimeZone(identifier: $0) }
        if searchText.isEmpty {
            return allTimezones
        }
        return allTimezones.filter { $0.identifier.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            List(filteredTimezones, id: \.identifier) { timezone in
                Button(action: { onSelect(timezone) }) {
                    Text(timezone.identifier)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Select Timezone")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}