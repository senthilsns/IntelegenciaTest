//
//  ViewController.swift
//  IntelegenciaTest
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var arrayOfList = [DataModel](){
         // Reload data when data set
         didSet{
             DispatchQueue.main.async {
             self.intelliTableview.reloadData()
         }
         }
     }
    
    @IBOutlet weak var intelliTableview: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Intelegencia"
        intelliTableview.delegate = self
        intelliTableview.dataSource = self
        
        
        showImageList()
        

     
    }
    
    
//    func callListOfImages(){
//
//        let request = AF.request(kImage_List_URL)
//           // 2
//           request.responseJSON { (data) in
//           //  print(data)
//
//            switch data.result {
//
//                case .success(let value):
//
//                var tempArr = NSArray(array:[value], copyItems: true)
//
//
//                case.failure(let error):
//                print(error.localizedDescription)
//
//            }
//        }
//
//    }



func showImageList() {
    

        let urlString :String = kImage_List_URL
        
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: []) as! Array<AnyObject>
                
               // print(jsonResponse)
                for list in jsonResponse {
                guard let autherList = list["author"] as? String else { return }
                guard let fID = list["id"] as? Int else { return }
                
                let detail = DataModel(author: autherList, id: fID)
                self.arrayOfList.append(detail)
                 
                }
                       
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
        
    }
    

}


extension ViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let listObj = arrayOfList[indexPath.row]
        vc?.imgID = listObj.id!
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        return arrayOfList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell",
                    for: indexPath) as! ImageCell
        // set the text from the data model
        let listObj = arrayOfList[indexPath.row]
        cell.titleLbl?.text = listObj.author
        
        let urlStr = kImage_Specific_URL + "\(String(describing: listObj.id!))"
       // print(urlStr)
        cell.displayImageView.downloaded(from: urlStr)

        
        return cell

      }
    
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


