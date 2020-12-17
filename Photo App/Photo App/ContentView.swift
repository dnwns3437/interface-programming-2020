//
//  ContentView.swift
//  Photo App
//
//  Created by Woojun Park on 2020/12/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var search = "" // Query
    @State private var photos: [[Photo]] = []
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Search Bar
            HStack {
            
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                
                TextField("Search...", text: self.$search)
                
                // Displaying Close Button....
                
                // Displaying search button when search txt is not empty...
                
                
                Button(action: {
                    self.search = ""
                    
//                    if self.isSearching{
//
//                        self.isSearching = false
//                        self.RandomImages.Images.removeAll()
//                        // updating home data....
//                        self.RandomImages.updateData()
//                    }
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.leading,10)
                
                
                    
                Button("Find") {
                    fetchPhoto()
                    // Search Content....
                    // deleting all existing data and displaying search data...
                    
//                        self.RandomImages.Images.removeAll()
//
//                        self.isSearching = true
//
//                        self.page = 1
//
//                        self.SearchData()
                    
                }
                .disabled(search.isEmpty)
                
                
                Spacer()
            

                
                
                

            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
        
            // Photo List
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    // Show two photos for each row
                    ForEach(photos, id: \.self) { i in
                        HStack(spacing: 20) {
                            ForEach(i) { j in
                                Image(systemName: "photos")
                                    .data(url: URL(string: j.urls["thumb"]!)!)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 200)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
        
    }
    
    func fetchPhoto() {
        let key = "xMTW2-DMELMK-DOsDuQcoeeAV_TBlRenbpumI70Ive4"
        let query = self.search

        guard let url = URL(string: "https://api.unsplash.com/photos/?query=\(query)&client_id=\(key)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, taskError in
            guard let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode),
                    let data = data else {
                        fatalError()
            }
            
            let decoder = JSONDecoder()
        
            guard let response = try? decoder.decode([Photo].self, from: data) else {
                return
            }
            
            for i in stride(from: 0, to: response.count, by: 2){
                var ArrayData : [Photo] = []
                for j in i..<i+2 {
                    if j < response.count{
                        ArrayData.append(response[j])
                    }
                }
                DispatchQueue.main.async {
                    self.photos.append(ArrayData)
                }
            }
        }.resume()
    }
}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
            
        }
        return self
            .resizable()
    }
}
