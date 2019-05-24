//
//  PostController.swift
//  dick-cat
//
//  Created by Francesco Mattiussi on 22/05/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import UIKit

class PostController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // grafica del titolo e del pulsante commenti
        titolo.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: titolo.bounds)
        titolo.layer.masksToBounds = false
        titolo.layer.shadowColor = UIColor.black.cgColor
        titolo.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        titolo.layer.shadowOpacity = 0.35
        titolo.layer.shadowPath = shadowPath2.cgPath
        titolo.layer.backgroundColor = UIColor.white.cgColor
        
        let shadowPath3 = UIBezierPath(rect: commenti_lo.bounds)
        commenti_lo.layer.masksToBounds = false
        commenti_lo.layer.shadowColor = UIColor.black.cgColor
        commenti_lo.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        commenti_lo.layer.shadowOpacity = 0.35
        commenti_lo.layer.shadowPath = shadowPath3.cgPath
        
        // carica il post nella view
        caricapost()
        
        //controlla i commenti
        let blogger = Blogger(apiKey: self.apiKey)
        let commenti = blogger.getComments(postId: self.postId!, id: self.blogId)
        
        // se non ci sono commenti rende il button inattivo
        if commenti.count <= 0 {
            commenti_lo.setTitle("Non ci sono commenti", for: .normal)
            commenti_lo.isEnabled = false
        } else {
            commenti_lo.setTitle("\(commenti.count) commenti", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    var postId: String? //verrà fornito dal viewcontroller precedente
    
    //MARK: Da personalizzare
    let apiKey = ""
    
    var blogId = "8901166936755470190"
    
    // variabili di caching
    var autori: [String] = []
    var commenti_post: [String] = []
    
    func caricapost() {
        //definisce gli user defaults
        let spazio_ud = UserDefaults(suiteName: "DICKCAT")
        
        //testo ricavato e titolo
        let html_post = spazio_ud?.value(forKey: "testo_post") as! String
        let titolo_post = spazio_ud?.value(forKey: "titolo_post") as! String
        postId = spazio_ud?.value(forKey: "id_post") as? String

        let dati_raw = html_post.data(using: .utf16) // in utf16 per mostrare anche gli accenti
        
        //converte l'html in testo attribuito (con blogger non ci sono mai problemi)
        if let attributedString = try? NSAttributedString(data: dati_raw!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            testo.attributedText = attributedString
        }
        
        //imposta il titolo
        titolo.text = titolo_post
    }
    
    // outlets
    @IBOutlet weak var titolo: UILabel!
    
    @IBOutlet weak var testo: UITextView!
    
    @IBOutlet weak var commenti_lo: UIButton!
    
    @IBAction func commenti(_ sender: UIButton) {
        // inizializza Blogger
        let blogger = Blogger(apiKey: self.apiKey)
        let commenti = blogger.getComments(postId: self.postId!, id: self.blogId)
        
        // popola le variabili di caching
        for a in commenti {
            let b = a
            commenti_post.append(Array(b.values)[0])
            autori.append(Array(b.keys)[0])
        }
        
        //definisce lo userdefaults privato e imposta i commenti per il viewcontroller successivo
        let spazio = UserDefaults(suiteName: "DICKCAT")
        spazio?.set(commenti_post, forKey: "commenti")
        spazio?.set(autori, forKey: "autori")
        
        // se ci sono commenti apre il view controller dei commenti
        if commenti.count >= 1 {
            performSegue(withIdentifier: "commenti", sender: nil)
        }
        
    }
    
    // condivide il link del post (da testare su device reale)
    @IBAction func condividi(_ sender: UIBarButtonItem) {
        
        //testo da condividere preso dagli userdefaults
        let spazio_ud = UserDefaults(suiteName: "DICKCAT")
        let text = spazio_ud?.value(forKey: "url_post") as! String
        // imposta l'activity controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // carica il menu
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // chiude la view
    @IBAction func indietro(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
