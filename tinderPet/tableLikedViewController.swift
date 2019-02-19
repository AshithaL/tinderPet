//
//  tableLikedPetViewController.swift
//  tinderPet
//
//  Created by Ashitha L on 14/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftKeychainWrapper
import AlamofireObjectMapper


class tableLikedViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var likedPetTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var petlist = [petImageData]()
    var searchPetList = [petImageData]()
    var isSearching = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedPetInfoRetrival()
        setUpSearchbar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchPetList .count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // defining a resuable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "likedPets") as! likedPets
        let likedPetList = searchPetList [indexPath.row]
        
        cell.prepareUI (text: searchPetList [indexPath.row].pname!, img: likedPetList.pimage!, desc: likedPetList.pdesc!)
        return cell
    }
    
    func tableView (_ tableview: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
   // search
    private func setUpSearchbar()
    {
    SearchBar.delegate = self 
    }

    func searchBar( _ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isSearching = false
            likedPetTableView.reloadData()
            return
        }
        self.isSearching = true
        searchPetList = petlist.filter({ petImageData -> Bool in
            petImageData.pname!.contains(searchText)
        })
        likedPetTableView.reloadData()
    }
    func searchBar( _ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    //retrieve
    
    func likedPetInfoRetrival() {
        let url = URL(string: "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/pets/likes" )
        Alamofire.request(url!, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject {(response: DataResponse<PetImage>) in
            
            if response.response?.statusCode == 200 {
                let petResponse = response.result.value
                self.petlist = (petResponse?.PetResonseClass?.petData?.petImageData)!
                self.searchPetList = self.petlist
                self.likedPetTableView.delegate = self
                self.likedPetTableView.dataSource = self
                self.likedPetTableView.tableFooterView = UIView(frame: CGRect.zero)
                print(petResponse?.PetResonseClass?.petData?.petImageData! as Any)
            }
        }
    }
}

