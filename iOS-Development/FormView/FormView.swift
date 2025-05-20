

import SwiftUI
import SwiftData

struct FormView : View {
    
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate = Date()
    @State private var sendNewsletter = false
    @State private var totalLikes = 1
    
    var body : some View {
        
        NavigationView {
            
            Form {
                
                Section(header : Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birthdate", selection: $birthDate, displayedComponents: .date)
                }
                
                
                Section(header: Text("Action")) {
                    
                    Toggle("Send Newsletter", isOn: $sendNewsletter)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    Stepper("Number of likes", value: $totalLikes, in: 1...100)
                    Text("This post has \(totalLikes) likes")
                    Link("Terms of Service", destination: URL("https://localhost.com")!)
                    
                    
                    
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                
                ToolbarItemGroup {
                    Button {
                        saveUser()
                    } label : {
                        Text("Save")
                    }
                }
            }
            
        }
    }
    
    func saveUser(){
        print("Profile Saved")
    }
}

#Preview {
    FormView()
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif
