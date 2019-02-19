//
//  PoiViewController.swift
//  tinderPet
//
//  Created by Ashitha L on 13/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import Foundation
import UIKit
import Poi
import Kingfisher
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

// second screen
class PoiViewController: UIViewController, PoiViewDataSource, PoiViewDelegate {
   
    @IBOutlet weak var poiView: PoiView!

    @IBOutlet weak var logOut: UIBarButtonItem!
    
    var sampleCards = [ Card ] ()
    var fetched_info : [petImageData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePetList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func updatePetList() {
        // keychain wrapper is used to store secure information and for retrival of the same
        
        let token : HTTPHeaders = ["Authorization" : KeychainWrapper.standard.string(forKey: "retrievedToken")!]
        print(token)
        
        let url = URL (string: "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/pets" )
        Alamofire.request(url!, method: .get, parameters: nil, headers: token).responseObject {(response: DataResponse<PetImage>) in
            
            if response.response?.statusCode == 200 {
                let getResponse = response.result.value
                self.fetched_info = getResponse?.PetResonseClass?.petData?.petImageData
                self.createViews()
                self.poiView.dataSource = self
                self.poiView.delegate = self
            }
            else {
                print ("Something is wrong")
            }
        }
    }
    
    
    // log out function
    
    @IBAction func logOut(_ sender: Any) {
        let url = URL(string: "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/logout" )
        Alamofire.request(url!, method: .post, headers: nil) .responseObject {( response: DataResponse<PetImage>) in
            print( "status\(String(describing: response.response?.statusCode))")
            if response.response?.statusCode == 200 {
                let removeSuccesfull : Bool = KeychainWrapper.standard.removeObject(forKey: "retrievedToken")
                if removeSuccesfull == true{
                    self.performSegue(withIdentifier: "logout", sender: self)
                    print("log out is working")
                } else {
                    print("Error")
                }
            }
            else {
                print("Logout function is not working")
            }
            
        }
    }
    private func createViews () {
        for i in (0 ..< self.fetched_info!.count){
            let Card = UINib(nibName: "Card", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! Card
            Card.prepareUI(text: fetched_info![i].pname!, img: fetched_info![i].pimage!, desc: fetched_info![i].pdesc!)
            sampleCards.append(Card)
        }
    }
    
    
    func numberOfCards( _ poi: PoiView) -> Int {
        return self.fetched_info!.count
    }
    
    func poi( _ poi: PoiView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
    
    func poi( _ poi: PoiView, viewForCardOverLayFor direction: SwipeDirection) -> UIImageView? {
        switch direction {
        case .right:
            return UIImageView(image: #imageLiteral(resourceName: "good"))
        case .left:
            return UIImageView(image: #imageLiteral(resourceName: "bad"))
        }
    }
    // swipping function
    func poi( _ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection) {
        let tok : HTTPHeaders? = ["Authorization": KeychainWrapper.standard.string(forKey: "retrievedToken")!]
        let urlString = URL(string: "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/pets/likes/" + fetched_info![didSwipeCardAt-1].pid!)
        
        switch direction {
        case .left:
            let params = ["liked" : false]
            Alamofire.request(urlString!, method: .put, parameters: params, headers: tok).responseObject { ( response: DataResponse<PetImage>) in
                print(response.response!)
                print("left")}
        case .right:
            let params  = ["liked" : true]
            Alamofire.request(urlString!, method: .put, parameters: params, headers: tok).responseObject { ( response: DataResponse<PetImage>) in
                print(response.response!)
                print("right")}
            
            }
        }
    
    func poi ( _ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection) {
        print("last")
    }
    
    @IBAction func like(_ sender: UIButton) {
        poiView.swipeCurrentCard(to: .right)
    }
    
    
    @IBAction func undo(_ sender: UIButton) {
        poiView.undo()
    }
    
    @IBAction func dislike(_ sender: UIButton) {
        poiView.swipeCurrentCard(to: .left)
    }
}

