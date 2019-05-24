//
//  FirstViewController.swift
//  dick-cat
//
//  Created by Francesco Mattiussi on 21/05/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // protocolli per la collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titolo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection_view.dequeueReusableCell(withReuseIdentifier: "cella", for: indexPath) as! CellaPost
        
        //elementi delle celle
        cell.titolo.text = titolo[indexPath.row]
        cell.commenti.text = "\(numeroCommenti[indexPath.row]) commenti"
        cell.data.text = data[indexPath.row]
        cell.testo.text = preview[indexPath.row]
        
        //grafica delle celle
        cell.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        cell.layer.shadowOpacity = 0.35
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let spazio_ud = UserDefaults(suiteName: "DICKCAT") // suite userdefaults privata
        
        //imposta i valori necessari al successivo viewController
        spazio_ud?.set(contenuto[indexPath.row], forKey: "testo_post")
        spazio_ud?.set(titolo[indexPath.row], forKey: "titolo_post")
        spazio_ud?.set(postId[indexPath.row], forKey: "id_post")
        spazio_ud?.set(url[indexPath.row].path, forKey: "url_post")
        
        //apre la vista post
        performSegue(withIdentifier: "post", sender: nil)
    }

    //MARK: Da personalizzare
    
    let apiKey = ""
    
    let blogId = "8901166936755470190"
    
    // outlets
    @IBOutlet weak var collection_view: UICollectionView!
    
    @IBOutlet weak var barra_ricerca: UISearchBar!
    
    // variabili di caching
    var autore: [String] = []
    var data: [String] = []
    var titolo: [String] = []
    var url: [URL] = []
    var numeroCommenti: [Int] = []
    var contenuto: [String] = []
    var postId: [String] = []
    var preview: [String] = []
    
    // esegue tutto al viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barra_ricerca.isUserInteractionEnabled = false //disabilitata perchè non implementata
        
        // imposta i delegate
        collection_view.delegate = self
        collection_view.dataSource = self
        
        //inizializza Blogger
        let blogger = Blogger(apiKey: apiKey)
        
        let posts = blogger.getPosts(id: blogId) //posts sottoforma di dizionario
        
        var count = 0 //count (da inglobare nel ciclo for)
        
        // popola le variabili cache
        for a in posts {
            
            let b = a[count]!
            
            autore.append(b.autore)
            
            // configura e formatta la data
            let data = b.data
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            
            if let date = dateFormatterGet.date(from: data) {
                self.data.append(dateFormatterPrint.string(from: date))
            } else {
                print("There was an error decoding the string")
            }
            
            titolo.append(b.titolo)
            url.append(b.url)
            numeroCommenti.append(Int(b.numeroCommenti))
            postId.append(b.postId)
            contenuto.append(b.contenuto)
            
            // configura e formatta la preview (tutto il testo fino al primo punto)
            let contenuto = b.contenuto
            
            let dati_raw = contenuto.data(using: .utf16)
            
            var attributedText: NSAttributedString?
            
            //converte (tenta)
            if let attributedString = try? NSAttributedString(data: dati_raw!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                attributedText = attributedString
            }
            
            let contenutoString = attributedText!.string
            
            var testoPreview = ""
            
            if let range = contenutoString.range(of: ".") {
                let firstPart = contenutoString[contenutoString.startIndex..<range.lowerBound]
                testoPreview = String(firstPart)
            }
            
            preview.append(testoPreview)
            
            count += 1
        }
        
        collection_view.reloadData() //aggiorna i dati per farli comparire nella collectionView
    }


}

