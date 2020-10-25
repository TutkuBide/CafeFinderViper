//
//  apiManager.swift
//  CafeFinder
//
//  Created by tutkubide on 24.10.2020.
//

import Foundation
import UIKit
import Alamofire

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    
    typealias completionHandler  = (_ success : Bool, _ response: AFDataResponse<Any>)-> Void
    
    func fetchData(_ url: String, completionBlock: @escaping completionHandler) {
        AF.request(url).responseJSON { (result) in
            if result.response?.statusCode != 200 {
                completionBlock(false, result)
            }else{
                completionBlock(true, result)
            }
        }
    }
}
