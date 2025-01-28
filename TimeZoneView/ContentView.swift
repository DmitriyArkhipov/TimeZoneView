//
//  ContentView.swift
//  TimeZoneView
//
//  Created by Дмитрий Архипов on 28.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimezones: [TimeZone] = [TimeZone.current]
    @State private var showingTimezonePicker = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left side - Timezones list
                VStack {
                    List {
                        ForEach(selectedTimezones, id: \.identifier) { timezone in
                            TimeZoneRowView(date: selectedDate, timezone: timezone)
                        }
                        .onDelete(perform: deleteTimezone)
                    }
                    
                    Button(action: {
                        showingTimezonePicker = true
                    }) {
                        Label("Add Timezone", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                    .padding()
                }
                .frame(width: geometry.size.width / 2)
                
                // Right side - Time picker
                VStack {
                    DatePicker("Select Time",
                             selection: $selectedDate,
                             displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                .frame(width: geometry.size.width / 2)
            }
        }
        .sheet(isPresented: $showingTimezonePicker) {
            TimeZonePickerView(selectedTimezones: $selectedTimezones)
        }
    }
    
    private func deleteTimezone(at offsets: IndexSet) {
        selectedTimezones.remove(atOffsets: offsets)
    }
}

struct TimeZoneRowView: View {
    let date: Date
    let timezone: TimeZone
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
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
        }
        .padding(.vertical, 8)
    }
}

struct TimeZonePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTimezones: [TimeZone]
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
                Button(action: {
                    if !selectedTimezones.contains(where: { $0.identifier == timezone.identifier }) {
                        selectedTimezones.append(timezone)
                    }
                    dismiss()
                }) {
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

#Preview {
    ContentView()
}
