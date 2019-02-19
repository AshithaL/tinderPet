//
//  likedPets.swift
//  tinderPet
//
//  Created by Ashitha L on 14/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class likedPets: UITableViewCell {
    
    
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var petText: UILabel!
    
    @IBOutlet weak var petDescription: UILabel!
    
    func prepareUI( text: String, img: String , desc : String) {
        petText.text = text
        let url = URL (string: img)
        petImage.kf.setImage(with: url)
        petDescription.text = desc
    }
}
