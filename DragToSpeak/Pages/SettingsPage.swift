//
//  SettingsView.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//

import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                dragTypeSection
                layoutSection
                if settings.dragType == .dwell {
                    dwellTimeSection
                }
                Section {
                    Toggle("Show Trail", isOn: $settings.showTrail)
                }
                Section(content: {
                    Toggle("Enlarge Keys on Hover", isOn: $settings.enlargeKeys)
                    Stepper(
                        value: settings.$fontSize,
                        in: 10...50,
                        step: 1
                    ) {
                        HStack {
                            Text("Font Size")
                            Spacer()
                            Text("\(settings.fontSize)")
                        }
                        
                    }
                }, header: {
                    Text("Font Settings")
                })
                Section(content: {
                    Toggle("Finish when you stop dragging", isOn: $settings.finishOnDragEnd)
//                    Toggle("Correct words on Finish", isOn: $settings.autocorrectEnabled)
                    Toggle("Add spaces on finish", isOn: $settings.writeWithoutSpacesEnabled)
                }, header: {
                    Text("Message")
                })
                resetOnboardingSection
            }
            .navigationTitle("Settings")
            .toolbar { doneButton }
        }
    }
    
    private var dragTypeSection: some View {
        Section {
            Picker("Drag Type", selection: $settings.dragType) {
                Text("Direction Change").tag(DragType.direction)
                Text("Dwell").tag(DragType.dwell)
            }
            .pickerStyle(.segmented)
        } footer: {
            Text("Change how we calculate letter selection")
        }
    }
    
    private var layoutSection: some View {
        Section {
            Picker("Layout", selection: $settings.layout) {
                Text("Alphabetical").tag(Layout.alphabetical)
                Text("Alphabetical - No Numbers").tag(Layout.alphabeticalNoNumbers)
                Text("Frequency").tag(Layout.frequency)
                Text("QWERTY").tag(Layout.qwerty)
            }
            VStack(alignment: .leading) {
                Text("Insert column of spaces to side")
                Picker("Spaces Column", selection: $settings.spacesColumn) {
                    Text("Left").tag(SpacesColumn.left)
                    Text("None").tag(SpacesColumn.none)
                    Text("Right").tag(SpacesColumn.right)
                }
                .pickerStyle(.segmented)
            }
        } footer: {
            Text("The layout of the letters on the grid")
        }
    }
    
    private var dwellTimeSection: some View {
        Section(content: {
            VStack {
                HStack {
                    Text("Dwell Time")
                    Spacer()
                    Text(String(format: "%.2f", settings.dwellTime))
                }
                
                Slider(
                    value: $settings.dwellTime,
                    in: 0.1...10,
                    step: 0.1
                ) {
                    Text("Dwell Time")
                } minimumValueLabel: {
                    Text("0.1s")
                } maximumValueLabel: {
                    Text("2s")
                }
            }
        }, footer: {
            Text("The amount of time you must keep your finger on a letter to register a click. This only work in Dwell mode")
        })
    }
    
    private var resetOnboardingSection: some View {
        Section(content: {
            Button("Reset Onboarding") {
                settings.hasLaunchedBefore = false
            }
        }, footer: {
            Text("If you want to watch the introduction video again turn this on")
        })
    }
    
    private var doneButton: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
