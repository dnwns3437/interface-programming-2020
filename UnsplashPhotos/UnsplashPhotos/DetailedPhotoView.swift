//
//  DetailedPhotoView.swift
//  UnsplashPhotos
//
//  Created by 고민정 on 2020/12/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailedPhotoView: View {
    @Binding var photos: [Photo]
    @Binding var likedByUser: [Bool]
    @Binding var likedPhotos: [Photo]
    @Binding var showLikedOnly: Bool

    @State var isUserSwiping: Bool = false
    @State var offset: CGFloat = 0
    @State var curr: Int = 0
    @State var downloaded = false
    var location: String

    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack(){
            
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 1) {
                        ForEach(self.photos, id: \.self) { photo in
                            Image(systemName: "photos")
                                .data(url: URL(string: photo.urls["thumb"]!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width)
                                .cornerRadius(5)
                                .padding(.leading, -0.5)
                        }
                    }
                }
                .content
                .offset(x: self.isUserSwiping ? self.offset : CGFloat(curr) * -geometry.size.width)
                .frame(width: geometry.size.width, alignment: .leading)
                .animation(.spring())
                .gesture ( DragGesture()
                .onChanged({ value in
                    self.isUserSwiping = true
                    self.offset = value.translation.width - geometry.size.width * CGFloat(curr)
                })
                            .onEnded({ value in
                                if (value.translation.width < 0) {
                                    if value.translation.width < geometry.size.width/2, curr < photos.count - 1 {
                                        curr += 1
                                    }
                                }
                                else if (value.translation.width > 0) {
                                    if value.translation.width > 30.0, curr > 0 {
                                        curr -= 1
                                    }
                                }
                                withAnimation {
                                    self.isUserSwiping = false
                                }

                            })
                )
            }
            
            HStack{
                Spacer(minLength:0)
                
                Text("Like")
                Button(action: {
                    likedByUser[curr].toggle()
                    setLiked()
                }) {
                    if (likedByUser[curr]){
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    else{
                    Image(systemName: "heart")
                        .renderingMode(.original)
                    }
                }.padding(.trailing, 10)
                
                Text("Download")
                Button(action: {
                    SDWebImageDownloader().downloadImage(with: URL(string: photos[curr].urls["thumb"]!)!) { (image, _, _, _) in
                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)}
                    self.downloaded = true
                }) {Image(systemName: "arrow.down")
                        .renderingMode(.original)
                }.padding(.trailing, 18)
                .alert(isPresented: $downloaded) {
                    Alert(title: Text("Download Complete"), message: Text("Saved to your photo library"), dismissButton: .default(Text("OK!")))
                }
            }
            
        Spacer()
            
        }.navigationBarTitle(showLikedOnly ? "Liked" : location, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                    
                })
        
    }
    
    func setLiked() {
        if likedByUser[curr] {
            if !likedPhotos.contains(photos[curr]) {
                likedPhotos.append(photos[curr]);
            }
        }
        else {
            likedPhotos.remove(at: likedPhotos.firstIndex {$0 == photos[curr]}!)
        }
    }
}

//struct DetailedPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedPhotoView(imageCode: URL)
//    }
//}

