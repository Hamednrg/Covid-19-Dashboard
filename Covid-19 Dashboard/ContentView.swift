//
//  ContentView.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/19/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house.fill")
                        .font(.title)
                    Text("Home")
                }.tag(0)
            MapView()
                .tabItem{
                    Image(systemName: "map.fill")
                        .font(.title)
                    Text("Map")
                }.tag(1)
        }.accentColor(colorScheme == .dark ? Color("CustomOrange") : Color("CustomDarkBlue"))
        .animation(.easeInOut)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
