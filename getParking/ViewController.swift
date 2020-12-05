//
//  ViewController.swift
//  getParking
//
//  Created by Krishna Kushwaha on 05/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var itemAr = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        getJSON()
         
    }
    
       func getJSON(){
        
           guard let gitUrl = URL(string: "https://www.googleapis.com/books/v1/volumes?q=f") else { return }
           
           URLSession.shared.dataTask(with: gitUrl) { (data, response
               
               , error) in
               
               guard let data = data else { return }
               
               
               do {
                   
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                     // try to read out a string array
                    if let items = json["items"] as? [[String : Any]] {
                        self.itemAr = items
                        DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        }
                        
                    }
                    
               
                }
    
               } catch let err {
                   
                   print("Err", err)
                   
               }
               
           }.resume()
           
       }

    

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return itemAr.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            if let volumeInfo = itemAr[indexPath.row]["volumeInfo"] as? [String:Any] {

            cell.titleNM.text = volumeInfo["title"] as? String
                cell.subtitleNM.text = volumeInfo["subtitle"] as? String

                
                let imageLinks = volumeInfo["imageLinks"] as? [String: Any]
                if  let image = imageLinks?["smallThumbnail"] as? String {

                    if let url = URL(string: image ){
                    
                    do {
                        let data = try Data(contentsOf: url)
                        cell.ImG.image = UIImage(data: data)
                        
                    }
                    catch let err {
                        print(" Error : \(err.localizedDescription)")
                    }
                    
                }
                }
                
            }
      
    
            return cell
        }
    
    
    
}
