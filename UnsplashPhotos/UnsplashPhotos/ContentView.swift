//
//  ContentView.swift
//  UnsplashPhotos
//
//  Created by Woojun Park on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    @State var search = "" // Query
    @State var page = 1
    @State private var photos: [[Photo]] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
        
                TextField("Search...", text: self.$search)
                
                Button(action: {
                    self.search = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.leading,10)
                
                Button("Find") {
                    self.photos = []
                    fetchPhoto()
                }
                .disabled(search.isEmpty)
                
                Spacer()
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
        
            Spacer(minLength: 15)
                        
            // Photo List
            ScrollView {
                LazyVStack(spacing: 15) {
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

        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=\(self.page)&query=\(query)&client_id=\(key)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, taskError in
            guard let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode),
                    let data = data else {
                        fatalError()
            }
            
            let decoder = JSONDecoder()
        
            guard let response = try? decoder.decode(MediaResponse.self, from: data) else {
                return
            }
            
            for i in stride(from: 0, to: response.results.count, by: 2){
                var ArrayData : [Photo] = []
                for j in i..<i+2 {
                    if j < response.results.count{
                        ArrayData.append(response.results[j])
                    }
                }
                DispatchQueue.main.async {
                    self.photos.append(ArrayData)
                }
            }
        }.resume()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


