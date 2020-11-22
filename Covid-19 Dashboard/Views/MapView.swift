//
//  MapView.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/19/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: View {
    @ObservedObject var covidFetch = CovidFetchRequst()
    var body: some View {
        MapContainer(mapData: $covidFetch.maps).edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct MapContainer: UIViewRepresentable {
    @Binding var mapData: [MapInfo]
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapContainer>) {
        var allAnnotations: [CoronaCaseAnnotation] = []
        for data in mapData{
            let title = data.location + "\n Confirmed: " + data.confirmed.formatNumber() + "\n Deaths: " + data.dead.formatNumber() + "\n Recovered: " + data.recovered.formatNumber()
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            allAnnotations.append(CoronaCaseAnnotation(title: title, coordinate: coordinate))
        }
        uiView.annotations.forEach  {uiView.removeAnnotation($0)}
        uiView.addAnnotations(allAnnotations)
    }
    func makeUIView(context: UIViewRepresentableContext<MapContainer>) -> MKMapView {
        return MKMapView()
    }
}
class CoronaCaseAnnotation: NSObject, MKAnnotation{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String?, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
