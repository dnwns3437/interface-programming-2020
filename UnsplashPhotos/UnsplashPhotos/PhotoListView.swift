//
//  PhotoListView.swift
//  UnsplashPhotos
//
//  Created by 김시연 on 2020/12/20.
//

import SwiftUI

struct PhotoListView: View {
    @Binding var photos: [Photo]
    @Binding var search: String
    @Binding var likedByUser: [Bool]
    @Binding var likedPhotos: [Photo]
    @Binding var showLikedOnly: Bool
    
    @State private var columns : [GridItem] = [
        GridItem(spacing:4),
        GridItem(spacing:4)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns){
                ForEach(photos, id:\.self) {photo in
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            
                        NavigationLink (  //detailed view when clicked
                            destination: DetailedPhotoView(photos: $photos, likedByUser: $likedByUser, likedPhotos: $likedPhotos, showLikedOnly: $showLikedOnly, curr: photos.firstIndex {$0 == photo}!, location: self.search) ) {
                            Image(systemName: "photos")
                                .data(url: URL(string: photo.urls["thumb"]!)!)
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width - 10) / 2, height: 200)
                                .cornerRadius(5)
                            
                        }.simultaneousGesture(TapGesture().onEnded{
                            if likedPhotos.contains(photo) {
                                likedByUser[photos.firstIndex {$0 == photo}!] = true
                            }
                        })
                        
                        if (showLikedOnly || likedPhotos.contains(photo)) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)

                        }
                        else {
                            Image(systemName: "heart")
                                .foregroundColor(.pink)
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)
                        }
                        
                    }
                    
                }
                
            } //photolist(normal)
            Spacer()
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
    }
    
}

//struct PhotoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoListView()
//    }
//}

