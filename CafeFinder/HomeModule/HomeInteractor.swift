//
//  HomeInteractor.swift
//  CafeFinder
//
//  Created by tutkubide on 24.10.2020.
//

import Foundation
import Alamofire

protocol HomeInteractorInterface {
    func fetchCafeList()
    func getModel() -> [VenuesModel]
}

class HomeInteractor {
    var venuesArray: [VenuesModel] = []
}

extension HomeInteractor: HomeInteractorInterface {
    
    func fetchCafeList() {
        let url :String = "https://api.foursquare.com/v2/venues/search?near=istanbul&query=cafe&client_id=TVC22TPDEIBP1XIFTHG2W5YMKBO5GU0JQ5N1GVR2SEGOQBLL&client_secret=KHJZIJ030RH1R4ZFWYUM1ZHJK25XAKHNSY3GXDV55RW00AIN&v=20190520"
        ApiManager.shared.fetchData(url) { (success, response) in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let venuesArray = responseModel["venues"] as! NSArray;
                for object in venuesArray {
                    let venue = object as! NSDictionary;
                    let location = venue["location"] as! NSDictionary;
                    let categoriArray = venue["categories"] as! NSArray;
                    var id: String = ""
                    var name: String = ""
                    var adress: String = ""
                    var city: String = ""
                    var country: String = ""
                    var photo: String = ""
                    var latitude: Double = 0
                    var longitude: Double = 0
                    if venue["id"] != nil {
                        id = (venue["id"] as! String)
                    }
                    if venue["name"] != nil {
                        name = (venue["name"] as! String)
                    }
                    if location["address"] != nil {
                        adress = (location["address"] as! String)
                    }
                    if location["city"] != nil {
                        city = (location["city"] as! String)
                    }
                    if location["country"] != nil {
                        country = (location["country"] as! String)
                    }
                    if location["lat"] != nil {
                        latitude = (location["lat"] as! Double)
                    }
                    if location["lng"] != nil {
                        longitude = (location["lng"] as! Double)
                    }
                    for categori in categoriArray {
                        let model = categori as! NSDictionary;
                        let icon = model["icon"] as! NSDictionary;
                        photo = (icon["prefix"] as! String) + (icon["suffix"] as! String)
                    }
                    let mekan = VenuesModel(id: id, name: name, adress: adress, city: city, country: country, photo: photo, lat: latitude, lng: longitude)
                    self.venuesArray.append(mekan)
                }
            }
        }
    }
    
    func getModel() -> [VenuesModel] {
        return venuesArray
    }
}
