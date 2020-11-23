//
//  NewsView.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 9/1/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import WebKit

struct NewsView: View {
    @ObservedObject var list = CovidFetchRequst()
    var body: some View {
        NavigationView{
            List(list.datas){i in
                
//                NavigationLink(destination: WebView(url: i.url)
//                                .navigationBarTitle("",displayMode: .inline )){
                    HStack(spacing: 15){
                        if i.image != ""{
                            WebImage(url: URL(string: i.image), options: .highPriority, context: nil).resizable().frame(width: 140, height: 130, alignment: .leading).cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(i.title).fontWeight(.heavy).lineLimit(3)
                            Text(i.desc).foregroundColor(.primary).lineLimit(2)
                            if #available(iOS 14.0, *) {
                                Link("See more",
                                     destination: URL(string: i.url)!)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        
                    }.padding(.vertical,15)
//                }
                
            }.navigationBarTitle(Text("Headlines"))
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
struct WebView: UIViewRepresentable {
    
    var url: String
    func makeUIView(context: Context) -> WKWebView {
        
        let view = WKWebView()
        DispatchQueue.main.async {
            view.load(URLRequest(url: URL(string: url)!))
        }
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    typealias UIViewType = WKWebView
}
