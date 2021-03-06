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
    @State var photos: [Photo] = []
    @State var showLikedOnly = false
    @State var likedByUser = [Bool](repeating: false, count: 28)
    @State var likedPhotos: [Photo] = []
    @State var noresults = false
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
        NavigationView {
            
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
                        self.page = 1
                        likedByUser = [Bool](repeating: false, count: 28)
                        self.photos = []
                        fetchPhoto()
                    }
                    .disabled(search.isEmpty)
                    
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! * CGFloat(7/10))
                .padding()
                .background(Color.white)
                
                
                Toggle("Liked", isOn: $showLikedOnly.didSet {_ in 
                    likedByUser = showLikedOnly ? [Bool](repeating: true, count: 28) : [Bool](repeating: false, count: 28)
                })
                .padding()
                .padding(.top, -15)
                .padding(.bottom, -15)
                

                Spacer(minLength: 15)
                
                PhotoListView(photos: showLikedOnly ? $likedPhotos : $photos, search: $search, likedByUser: $likedByUser, likedPhotos: $likedPhotos, showLikedOnly: $showLikedOnly)
            
                //hstack
                HStack{
                    if(self.page>1)
                    {
                        Button(action:{
                        self.page-=1
                        self.photos = []
                        fetchPhoto()
                    }) {
                        Text("Prev")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    }

                    Spacer()
                    
                    Text("Page \(self.page)")
                    
                    Spacer()
                    
                    Button(action:{
                        self.page+=1
                        self.photos = []
                        fetchPhoto()
                    }) {
                        Text("Next")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }.padding(.horizontal, 25)
                //hstack
                
                
            }.navigationBarTitle("Where do you want to go?", displayMode: .inline)
        }
    }
    
    
    
    func fetchPhoto() {
        self.noresults = false
        
        let key = "xMTW2-DMELMK-DOsDuQcoeeAV_TBlRenbpumI70Ive4"
        let query = self.search

        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=\(self.page)&per_page=30&query=\(query)&client_id=\(key)") else {
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
                print("not")
                return
            }
            
            if response.results.isEmpty {
                self.noresults = true
            } else
            {
                self.noresults = false
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



