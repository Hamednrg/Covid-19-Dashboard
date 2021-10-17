//
//  Model.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/19/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import Foundation


struct TotalData {
    let confirmed:  Int
    let critical:   Int
    let deaths:     Int
    let recovered : Int
    
    var fatalityRate: Double{
        return (100.00 * Double(deaths))/Double(confirmed)
    }
    var recoveredRate: Double{
        return (100.00 * Double(recovered))/Double(confirmed)
    }
}

struct  CountryDetails: Codable, Hashable {
    
    let Country : String
    let TotalCases: Int
    let TotalDeaths: Int
    let TotalRecovered: Int
    var fatalityRate: Double{
        return (100.00 * Double(TotalDeaths))/Double(TotalCases)
    }
    var recoveredRate: Double{
        return (100.00 * Double(TotalRecovered))/Double(TotalCases)
    }
}

struct MapInfo: Codable {
    let location:   String
    let confirmed:  Int
    let dead:       Int
    let recovered:  Int
    let latitude:   Double
    let longitude:  Double
    
}
struct dataType: Identifiable {
    var id: String
    var title: String
    var desc: String
    var url: String
    var image: String
}

let testTotalData = TotalData(confirmed: 0, critical: 0, deaths: 0, recovered: 0)


