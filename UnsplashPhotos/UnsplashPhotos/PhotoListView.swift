//
//  PhotoListView.swift
//  UnsplashPhotos
//
//  Created by 김시연 on 2020/12/20.
//

import SwiftUI

struct PhotoListView: View {
    @State var photos: [Photo]
    @State var search=""
    @State private var columns : [GridItem] = [
        GridItem(spacing:4),
        GridItem(spacing:4)
    ]
    @State var likedbyuser = [Bool](repeating: false, count: 10)
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(photos, id:\.self) {photo in
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom))
                    {
                 
                    NavigationLink(  //detailed view when clicked
                        destination: DetailedPhotoView(imageCode: URL(string: photo.urls["raw"]!)!, location: self.search, photos: $photos, likedbyuser: $likedbyuser, curr: photos.firstIndex {$0 == photo}!))
                    {
                    Image(systemName: "photos")
                        .data(url: URL(string: photo.urls["thumb"]!)!)
                        .frame(width: (UIScreen.main.bounds.width - 10) / 2, height: 200)
                        .cornerRadius(5) }
                        
                        
                    if (likedbyuser[photos.firstIndex {$0 == photo}!])
                        {
                        Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                        }
                    else
                        {
                        Image(systemName: "heart")
                                .foregroundColor(.pink)
                        }
                    }//Zstack
                    
                }

            }
        }
    }
    
}

//struct PhotoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoListView()
//    }
//}

