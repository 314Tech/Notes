//
//  NoteViewController.swift
//  notez
//
//  Created by Nabyl Bennouri on 5/5/19.
//  Copyright © 2019 Three14. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import NotificationBannerSwift
import SVProgressHUD

class NoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var notesArray: [Note] = [Note]()
    var selectedNote: Note! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.dismiss()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the cell xib file
        tableView.register(UINib(nibName:"NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
        
        // Configure the table size
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        
        // User email
        emailLabel.text = Auth.auth().currentUser?.email
        // Sync with Firebase
        observeData()
    }
    
    @IBAction func onAddNotePress(_ sender: Any) {
        
    }
    @IBAction func onLogOutPress(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch {
            let banner = NotificationBanner(title: "Error", subtitle: error.localizedDescription as? String, style: .danger)
            banner.show()
        }
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let edit = segue.destination as! EditNoteViewController
            edit.currentNote = selectedNote
        }
    }
    
    //MARK: Table View Data Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        customCell.titleLabel.text = notesArray[indexPath.row].title
        return customCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notesArray[indexPath.row]
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    //MARK: Firebase data
    func observeData() {
        let userId = Auth.auth().currentUser?.uid
            let database = Database.database().reference().child("\(userId!)/notes")
            database.observe(.childAdded) {
            (snapshot) in
                let valuesDict = snapshot.value as! Dictionary<String, String>
                
                let title = valuesDict["title"]!
                let note = valuesDict["note"]!
                
                let oneNote = Note(withTitle: title, withNote: note, withKey: snapshot.key)
                self.notesArray.append(oneNote)
                
                self.tableView.reloadData()
            }
    }
    
    
    
}

