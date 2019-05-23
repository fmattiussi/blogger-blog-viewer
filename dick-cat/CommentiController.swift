//
//  CommentiController.swift
//  dick-cat
//
//  Created by Francesco Mattiussi on 22/05/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import UIKit

class CommentiController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autori.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cella = tableview.dequeueReusableCell(withIdentifier: "comme") as! UITableViewCell
        cella.textLabel?.text = commenti_post[indexPath.row]
        cella.detailTextLabel?.text = autori[indexPath.row]
        
        return cella
    }
    
    var autori: [String] = []
    var commenti_post: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        let spazio = UserDefaults(suiteName: "DICKCAT")
        autori = spazio?.value(forKey: "autori") as! [String]
        commenti_post = spazio?.value(forKey: "commenti") as! [String]
        
        commenti.text = "\(commenti_post.count) commenti"
        print(autori)
        tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func indietro(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var commenti: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
