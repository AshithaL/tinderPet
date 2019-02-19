//
//  retrivePets.swift
//  tinderPet
//
//  Created by Ashitha L on 13/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import Foundation
import Poi
import UIKit
import ObjectMapper

class PetImage : Mappable {
    var PetResonseClass: PetResponseClass?
    required init?(map: Map) {
        
    }
    func mapping (map : Map) {
        PetResonseClass <- map["response"]
    }
    
}

class PetResponseClass : Mappable {
    var petData : petData?
    var petStatus : petStatus?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        petData <- map["data"]
        petStatus <- map["status"]
        
    }
}
class petData : Mappable {
    var petImageData : [petImageData]?
    required init?(map: Map) {
        
    }
    func mapping (map: Map) {
        petImageData <- map["pets"]
    }
}

class petImageData : Mappable {
    var pid : String?
    var pimage : String?
    var pname : String?
    var pliked : String?
    var pdesc : String?
    var v : Int?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        pid <- map ["_id"]
        pimage <- map ["image"]
        pname <- map ["name"]
        pliked <- map ["liked"]
        pdesc <- map ["description"]
        v <- map ["v"]
    }
}
class petStatus : Mappable {
    var code : Int?
    var message : String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        
    }
}
