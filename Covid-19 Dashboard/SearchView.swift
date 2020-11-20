//
//  SearchView.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/23/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    var body: some View {
        HStack{
            TextField("Country...", text: $searchText)
            .padding()
            .cornerRadius(50)
        }
        .frame(height: 50)
        .background(Color("CustomBlue2"))
    }
}


