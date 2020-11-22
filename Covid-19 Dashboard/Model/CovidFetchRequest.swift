//
//  CovidFetchRequest.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/19/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CovidFetchRequst: ObservableObject{
    @Published var totalData : TotalData = testTotalData
    @Published var countries = [CountryDetails]()
    @Published var maps = [MapInfo]()
   

    init() {
        getCurrentTotal()
        getAllCountries()
        getMapInfo()
    }
    deinit {
        print("deinit")
    }
    func getCurrentTotal(){
       let headers: HTTPHeaders = [
           "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
           "x-rapidapi-key": "430f789df3mshd914a7f4cd52737p109b30jsn93bafccc73f9"
       ]
        AF.request("https://covid-19-data.p.rapidapi.com/totals?format=json", headers: headers).responseJSON {  response in
            
            
            let result = response.data
            if result != nil{
                let json = JSON(result!)
//                print(json)
                
                let confimed    = json[0]["confirmed"].intValue
                let recovered   = json[0]["recovered"].intValue
                let critical    = json[0]["critical"].intValue
                let deaths      = json[0]["deaths"].intValue
                
                self.totalData = TotalData(confirmed: Int(Double(confimed)), critical: critical, deaths: deaths, recovered: recovered)
            }else{
                self.totalData = testTotalData
            }
        }
    }
    
    func getAllCountries() {
        var allcount: [CountryDetails] = [] 
        AF.request("https://corona.lmao.ninja/v3/covid-19/countries").responseJSON{ response in
            let result = response.value
            if result != nil{
                let dataDictionary = result as! [Dictionary<String,AnyObject>]
                for countryData in dataDictionary{
              //print(dataDictionary)
                    let country     = countryData["country"] as? String ?? "error"
                    let cases       = countryData["cases"] as? Int ?? 0
                    let recovered   = countryData["recovered"]as? Int ?? 0
                    let critical    = countryData["critical"]as? Int ?? 0
                    let deaths      = countryData["deaths"]as? Int ?? 0
            
            let countryObject = CountryDetails(country: country, cases: cases, critical: critical, deaths: deaths, recovered: recovered)
                    allcount.append(countryObject)
                }
            }
            self.countries = allcount.sorted(by: {$0.cases > $1.cases})
        }
    }
    
    func getMapInfo(){
    
       let source = "https://www.trackcorona.live/api/countries"
        let url = URL(string: source)!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data,_,err)in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            for i in json["data"]{
                let location = i.1["location"].stringValue
                let latitude = i.1["latitude"].doubleValue
                let longitude = i.1["longitude"].doubleValue
                let confirmed = i.1["confirmed"].intValue
                let dead = i.1["dead"].intValue
                let recovered = i.1["recovered"].intValue
                
                DispatchQueue.main.async {
                    self.maps.append(MapInfo(location: location, confirmed: confirmed, dead: dead, recovered: recovered, latitude: latitude, longitude: longitude))
                }
                
            }
        }.resume()
    }
}
