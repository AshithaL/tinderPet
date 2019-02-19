//
//  tokenFile.swift
//  tinderPet
//
//  Created by Ashitha L on 13/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import Foundation
import ObjectMapper

class TokenResponse: Mappable {
    var eresponse: ResponseClass?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        eresponse <- map["response"]
    }
}

class ResponseClass : Mappable {
    var data : data?
    var status : status?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
    }
}

class data: Mappable {
    var token: String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        token <- map["token"]
    }
    
}
class status: Mappable {
    var code: Int?
    var message: String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
    
}
