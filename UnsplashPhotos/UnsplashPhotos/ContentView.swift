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
    @State private var photos: [Photo] = []
    @State private var showLikedOnly = false
    private var columns : [GridItem] = [
        GridItem(spacing:4),
        GridItem(spacing:4)
    ]
    
//    var filteredPhotos: [[Photo]] {
//            photos.filter { i in
//                ForEach(i) { photo in
//                 (!showLikedOnly || photo.liked_by_user)
//                }
//            }
//        } 일단 무시
    
    
    var body: some View {
        NavigationView{
            
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
            // Photo List(normal)
            
            ScrollView {
                
                LazyVGrid(columns: columns){
                    ForEach(photos, id:\.self) {photo in
                        
                        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom))
                        {
                     
                        NavigationLink(  //detailed view when clicked
                            destination: DetailedPhotoView(imageCode: URL(string: photo.urls["raw"]!)!, location: self.search)){
                        Image(systemName: "photos")
                            .data(url: URL(string: photo.urls["thumb"]!)!)
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width - 10) / 2, height: 200)
                            .cornerRadius(5)}
                            
                            
//                                    if (photo.liked_by_user) {
//                                        Image(systemName: "heart.fill")
//                                            .foregroundColor(.pink)
//                                    }
//                                    else {
//                                        Image(systemName: "heart")
//                                            .foregroundColor(.pink)
//                                    }
                            
                       }
                    }
                }

            } //photolist(normal)
            
            
            
                Spacer()
            }
            .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.top)
            
        }.navigationBarTitle("Where do you want to go?", displayMode: .inline)
        }
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
            
            for i in 0..<response.results.count {

                DispatchQueue.main.async {
                    self.photos.append(response.results[i])
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


