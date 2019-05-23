//
//  Blogger.swift
//  dick-cat
//
//  Created by Francesco Mattiussi on 21/05/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import Foundation

class Blogger: NSObject {
    
    //elementi di configurazione
    
    var apiKey: String?
    let gruppo = DispatchGroup() // Dispatch Group usato per gestire i tempi di download
    
    //init con l'API KEY
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // struttura del modello Post
    
    struct Post {
        let autore: String
        let data: String
        let titolo: String
        let url: URL
        let numeroCommenti: Double
        let contenuto: String
        let postId: String
    }
    
    // funzione per ottenere un dizionario di commenti con il relativo autore
    
    func getComments(postId: String, id: String) -> [[String:String]] { //richiede come postId l'id del post sul quale cercherà i commenti e come id l'id del blog
        
        var comments: [[String:String]] = []
        let url_raw = "https://www.googleapis.com/blogger/v3/blogs/" + id + "/posts/" + postId + "/comments?key=" + apiKey!
        let url = URL(string: url_raw)
        var dati: NSDictionary?
        
        gruppo.enter() //entra nel gruppo
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in //esegue il download del json in risposta

            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) //json convertito in NSDictionary
            dati = json as? NSDictionary

            self.gruppo.leave() //lascia il gruppo
        }
        task.resume()
        
        gruppo.wait() //attende la fine delle azioni di download
        
        //compone il dizionario in riposta
        
        if let items = dati?.object(forKey: "items") as? NSMutableArray {
            
            //Autori
            let author = items.value(forKey: "author") as! NSArray
            let displayName = author.value(forKey: "displayName") as! NSArray
            
            // Testo in HTML
            let contenuto = items.value(forKey: "content") as! NSArray
            
            for a in 0...items.count-1 {
                comments.append([displayName[a] as! String:contenuto[a] as! String])
            }
        }
        
        return comments
    }
    
    // funzione per ottenere i post come dizionario ordinati per numero e definiti nel modello Post
    
    func getPosts(id: String) -> [[Int:Post]] { // richiede il blogId
        
        var posts: [[Int:Post]] = []
        var dati: NSDictionary?
        let url_raw = "https://www.googleapis.com/blogger/v3/blogs/" + id + "/posts?key=" + self.apiKey!
        let url = URL(string: url_raw)
        
        gruppo.enter()
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            dati = json as? NSDictionary

            self.gruppo.leave()
        }
        task.resume()
        
        gruppo.wait()
        
        let items = dati!.object(forKey: "items")! as! NSMutableArray
        
        //Autori
        let author = items.value(forKey: "author") as! NSArray
        let displayName = author.value(forKey: "displayName") as! NSArray
        
        //Data pubblicazione
        let date = items.value(forKey: "published") as! NSArray
        
        //Titolo
        let title = items.value(forKey: "title") as! NSArray
        
        //URL
        let postURL = items.value(forKey: "url") as! NSArray
        
        //Commenti
        let comments = items.value(forKey: "replies") as! NSArray
        let commentsNumber = comments.value(forKey: "totalItems") as! NSArray
        
        // Testo in HTML
        let contenuto = items.value(forKey: "content") as! NSArray
        
        //PostID
        let postId = items.value(forKey: "id") as! NSArray
        
        //Compone il dizionario
        for a in 0...items.count-1 {
            print("\(a) \(title[a]): pubblicato da \(displayName[a]) il \(date[a]) con \(commentsNumber[a]) commenti")
            posts.append([a:Post(autore: displayName[a] as! String, data: date[a] as! String, titolo: title[a] as! String, url: URL(string: postURL[a] as! String)!, numeroCommenti: Double(commentsNumber[a] as! String) as! Double, contenuto: contenuto[a] as! String, postId: postId[a] as! String)])

        }

        return posts
    }
}
