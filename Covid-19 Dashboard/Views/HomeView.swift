//
//  HomeView.swift
//  Covid-19 Dashboard
//
//  Created by Hamed on 5/19/1399 AP.
//  Copyright © 1399 AP Hamed Naji. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var covidFetch = CovidFetchRequst()
    @State var searchText = ""
    @State var isSearchVisible = false
    
    var body: some View {
        NavigationView{
            VStack{
                SearchView(searchText: $searchText)
                
                ZStack{
                    ColorCard().shadow(radius: 20).edgesIgnoringSafeArea(.top)
                    TotalDataView(totalData: covidFetch.totalData)
                }
                ListHeaderView()
                List{
                    ForEach(covidFetch.countries.filter{
                        self.searchText.isEmpty ? true:
                            $0.Country.lowercased().contains(self.searchText.lowercased())
                    }, id: \.Country){ CountryDetails in
                        
                        
                        NavigationLink(destination: CellView(countryData: CountryDetails)){
                            
                            RowView(countryData: CountryDetails)
                        }
                    }
                }.listStyle(PlainListStyle())
                .navigationBarTitle("Covid-19 Dashboard", displayMode: .automatic)
            }
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
    struct ListHeaderView: View {
        var body: some View{
            HStack{
                Text("Country")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(width: 110,height: 40, alignment: .leading )
                    .padding(.leading,15)
                Spacer()
                
                Text("Conf.")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(height: 40 )
                    .padding(.leading,5)
                Spacer()
                Text("Death")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(height: 40 )
                    .padding(.leading,5)
                Spacer()
                Text("Recover")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .frame(height: 40 )
                    .padding(.trailing,15)
            }.background(Color("CustomBlue2"))
            
        }
    }
    struct RowView: View {
        var countryData: CountryDetails
        var body: some View{
            HStack{
                Text(countryData.Country)
                    .font(.headline)
                    .frame(width: 110,height: 40,alignment: .leading )
                    .lineLimit(1)
                Spacer()
                HStack{
                    Text(countryData.TotalCases.formatNumber())
                        .font(.subheadline)
                        .scaledToFill()
                        .frame(height: 40, alignment: .leading )
                        .padding(.leading)
                        .lineLimit(1)
                    Spacer(minLength: 10)
                    Text(countryData.TotalDeaths.formatNumber())
                        .font(.subheadline)
                        .scaledToFill()
                        .frame(height: 40, alignment: .leading )
                        .foregroundColor(.red)
                        .lineLimit(1)
                    
                    Spacer(minLength: 10)
                    Text(countryData.TotalRecovered.formatNumber())
                        .font(.subheadline)
                        .scaledToFill()
                        .frame(width: 60,height: 40, alignment: .leading )
                        .foregroundColor(.green)
                        .lineLimit(1)
                    }
                }
            }
        }
    struct TotalDataCard: View {
            var number:String = "err"
            var name: String = "Confirmed"
            var color: Color = .primary
            
            var body: some View{
                GeometryReader{geometry in
                    ZStack{
                        VStack{
                            Text(self.number)
                                .font(.body)
                                .padding(5)
                                .foregroundColor(self.color)
                            Text(self.name)
                                .font(.body)
                                // .padding()
                                .foregroundColor(self.color)
                        }.frame(width: geometry.size.width, height: 80, alignment: .center)
                        .background(Color("CustomBlue2"))
                        .shadow(radius: 30)
                        .cornerRadius(8.0)
                    }
                    
                    
                }
            }
        }
    struct TotalDataView: View {
            var totalData: TotalData
            var body: some View{
                VStack{
                    HStack{
                        TotalDataCard(number: totalData.confirmed.formatNumber(), name: "Confirmed",color: .black)
                        TotalDataCard(number: totalData.critical.formatNumber(), name: "Critical", color: .black)
                        TotalDataCard(number: totalData.deaths.formatNumber(), name: "Deaths", color: .red)
                    }
                    HStack{
                        TotalDataCard(number: String(format:"%.2f",totalData.fatalityRate), name: "Death %",color: .red)
                        TotalDataCard(number: totalData.recovered.formatNumber(), name: "Recovered", color: .green)
                        TotalDataCard(number: String(format:"%.2f",totalData.recoveredRate), name: "Recovery%", color: .green)
                        
                    }
                }.frame( height: 170)
                .padding(10)
                
            }
        }
    struct ColorCard:View {
            let color1 = Color("CustomDarkBlue")
            let color2 = Color("CustomOrange")
            var body: some View{
                LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .bottom, endPoint: .top).cornerRadius(20)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    struct CellView: View {
            var countryData: CountryDetails
            var body: some View{
                VStack(alignment: .leading, spacing: 15){
                    
                    HStack(spacing: 15){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Active Cases")
                                .foregroundColor(.black)
                                .font(.title)
                            Text(countryData.TotalCases.formatNumber())
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        VStack(alignment: .leading, spacing: 12){
                            VStack(alignment: .leading, spacing: 10){
                                Text("Deaths")
                                    .foregroundColor(.black)
                                Text(countryData.TotalDeaths.formatNumber())
                                    .foregroundColor(.red)
                            }
                            Divider()
                            VStack(alignment: .leading, spacing: 10){
                                Text("Death%")
                                    .foregroundColor(.black)
                                Text(String(format: "%.2f", countryData.fatalityRate))
                                    .foregroundColor(.red)
                            }
//                            Divider()
//                            VStack(alignment: .leading, spacing: 10){
//                                Text("Critical")
//                                    .foregroundColor(.black)
//                                Text(countryData.critical.formatNumber())
//                                    .foregroundColor(.orange)
//                            }
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text("Recovered")
                                    .foregroundColor(.black)
                                Text(countryData.TotalRecovered.formatNumber())
                                    .foregroundColor(.green)
                            }
                            Divider()
                            VStack(alignment: .leading, spacing: 10){
                                Text("Recovered%")
                                    .foregroundColor(.black)
                                Text(String(format: "%.2f", countryData.recoveredRate))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color("CustomBlue2"))
                    .cornerRadius(20)
                    Spacer()
                }.padding(.top,50)
                .navigationBarTitle(countryData.Country)
                
            }
        }
    }

