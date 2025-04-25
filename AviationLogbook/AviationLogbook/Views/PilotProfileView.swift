//
//  PilotProfileView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//

import SwiftUI

struct PilotProfileView: View {
    @State private var pilotName: String = "Kaveesh Passari"
        @State private var licenseNumber: String = "123456789"
        @State private var experience: Int = 5 // in years
        @State private var totalFlights: Int = 120
        @State private var totalHours: Int = 250
        @State private var editingProfile = false

    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()
                
                Text("Pilot Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(pilotName)
                }
                .font(.title3)
                .padding()
                
                HStack {
                    Text("FTN Number:")
                    Spacer()
                    Text(licenseNumber)
                }
                .font(.title3)
                .padding()
                
                HStack {
                    Text("Experience:")
                    Spacer()
                    Text("\(experience) years")
                }
                .font(.title3)
                .padding()
                
                Text("Flight Summary")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                HStack {
                    Text("Total Flights:")
                    Spacer()
                    Text("\(totalFlights)")
                }
                .font(.title3)
                .padding()
                
                HStack {
                    Text("Total Hours Flown:")
                    Spacer()
                    Text("\(totalHours) hours")
                }
                .font(.title3)
                .padding()
                
                Spacer()
                
                // Edit Profile Button
                Button(action: {
                    editingProfile.toggle()
                }) {
                    Text("Edit Profile")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding()
                .sheet(isPresented: $editingProfile) {
                    EditPilotProfileView(
                        pilotName: $pilotName,
                        licenseNumber: $licenseNumber,
                        experience: $experience
                    )
                }
            }
            .padding()
            .navigationTitle("Pilot Profile")
        }}
    }

    struct EditPilotProfileView: View {
        @Binding var pilotName: String
        @Binding var licenseNumber: String
        @Binding var experience: Int

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Profile Information")) {
                        TextField("Name", text: $pilotName)
                        TextField("License Number", text: $licenseNumber)
                        Stepper("Experience: \(experience) years", value: $experience, in: 0...100)
                    }
                }
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
#Preview {
    PilotProfileView()
}
