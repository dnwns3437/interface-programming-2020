//
//  DetailedPhotoView.swift
//  UnsplashPhotos
//
//  Created by 고민정 on 2020/12/19.
//

import SwiftUI

struct DetailedPhotoView: View {
    var imageCode: URL
    var location = ""
    @State var likedbyuser = false
    
    var body: some View {
        VStack(){
        
            Image(systemName: "photos")
                .data(url: imageCode)
                .resizable()
                .scaledToFit()
                .cornerRadius(5)
                .padding(.all, 10)
            
            HStack{
                Spacer(minLength:0)
                
                Text("Like")
                Button(action: {likedbyuser.toggle()}) {
                    if (likedbyuser){
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    else{
                    Image(systemName: "heart")
                        .renderingMode(.original)
                    }
                }.padding(.trailing, 10)
                
                Text("Download")
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "arrow.down")
                        .renderingMode(.original)
                }.padding(.trailing, 18)
                
            }
            
        Spacer()
            
        }.navigationBarTitle("\(location)",displayMode: .inline)
     
        
    }
    
}

//struct DetailedPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedPhotoView(imageCode: URL)
//    }
//}
