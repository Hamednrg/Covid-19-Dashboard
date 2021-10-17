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
    @Published var datas = [dataType]()
    
    init() {
        getCurrentTotal()
        getAllCountries()
        getMapInfo()
        getNews()
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

        let headers = [
            "x-rapidapi-host": "vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com",
            "x-rapidapi-key": "adbe7bcd77msh84b38286d9d79e0p10388bjsneaad22d69613"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com/api/npm-covid-data/countries")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _ , error in
            guard let data = data, error == nil else{ return }
            
            do {
                let countries = try JSONDecoder().decode([CountryDetails].self, from: data)
                DispatchQueue.main.async {
                    self.countries = countries
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func getMapInfo(){
        
        let source = "https://www.trackcorona.live/api/countries"
        let url = URL(string: source)!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data,_,err) in
            guard err == nil else{
                print(err!)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSON(data: data)
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
            } catch {
                print(error)
            }
            
            
        }.resume()
    }
    func getNews(){
        let source = "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=59a81e37879b4bc198676c45fc8cdee4"
        let url = URL(string: source)!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){(data,_,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            for i in json["articles"]{
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: image))
                }
            }
        }.resume()
    }
}
