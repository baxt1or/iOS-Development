


import SwiftUI
import SwiftData


struct User: Codable, Identifiable {
    let login : String
    let id : Int
    let avatarUrl : String
    let htmlUrl : String
    
    
    enum CodingKeys : String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

struct SearchView : View {
    
    @State private var users : [User] = []
    @State private var searchText : String = ""
    
    var usersFilter  : [User] {
        
        guard !searchText.isEmpty else { return users }
        
        return users.filter { $0.login.localizedCaseInsensitiveContains(searchText) }
    }
    
    
    
    var body : some View{
        
        NavigationStack {
            
            List(usersFilter, id: \.id ) { user in
                
               
                HStack(spacing : 20) {
                    
                    AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 44, height: 44)
                        } else if phase.error != nil {
                            
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                        } else {
                            
                            ProgressView()
                                .frame(width: 44, height: 44)
                        }
                    }
                    
                    
                    Text(user.login)
                        .font(.title2)
                        .fontWeight(.light)
                }
                
            }
            .navigationTitle("Users")
            .searchable(text: $searchText, prompt: "Search users")
            .textInputAutocapitalization(.never)
            
            
        }
        .task {
            users = await getUsers()
        }
        
    }
    
    
    func getUsers() async -> [User] {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            print("JSON file not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([User].self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return []
        }
    }
}


#Preview {
    SearchView()
}
