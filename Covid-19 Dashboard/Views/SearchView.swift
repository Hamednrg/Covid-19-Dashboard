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
    @State private var showCancelButton: Bool = false
    var onCommit: () -> Void = {print("onCommit")}
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty { // Separate text for placeholder to give it the proper color
                        Text("Search")
                    }
                    TextField("", text: $searchText, onEditingChanged: { isEditing in
                        withAnimation{
                            self.showCancelButton = true
                            
                        }
                    }, onCommit: onCommit).foregroundColor(.primary)
                }
                // Clear button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary) // For magnifying glass and placeholder test
            .background(Color(.tertiarySystemFill))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                // Cancel button
                Button("Cancel") {
                    withAnimation{   UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                        
                    }
                }
                .foregroundColor(Color("CustomOrange"))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(showCancelButton)
        .animation(.default)
    }
}
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        withAnimation{
            UIApplication.shared.endEditing(true)
        }
    }
    func body(content: Content) -> some View {
        withAnimation{
            content.gesture(gesture)
        }
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}


