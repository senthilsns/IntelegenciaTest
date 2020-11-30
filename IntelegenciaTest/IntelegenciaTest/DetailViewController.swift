//
//  DetailViewController.swift
//  IntelegenciaTest
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var specificImageView: UIImageView!
    var imgID :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        specificImageView.layer.borderWidth = 1.0
        specificImageView.layer.borderColor =  UIColor.red.cgColor
         
        // Download Image from specific Id
        downloadImage(imgID:String(imgID))
        
      
      
    }
    
    
    func downloadImage(imgID:String)
    {
        
       let fullURL : String = kImage_Specific_URL+imgID
       AF.request( fullURL,method: .get).response{ response in

        switch response.result {
            case .success(let responseData):
            self.specificImageView.image = UIImage(data: responseData!, scale:1)

            case .failure(let error):
            print("error",error)
                 }
            }
    }
  


}
