//
//  EditNoteViewController.swift
//  notez
//
//  Created by Nabyl Bennouri on 5/6/19.
//  Copyright © 2019 Three14. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import NotificationBannerSwift

class EditNoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentNote: Note! = nil
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        noteTextView.delegate = self
        titleTextField.delegate = self
        
        if (currentNote != nil) {
            noteTextView.text = currentNote!.note
            titleTextField.text = currentNote!.title
        }
    }
    @IBAction func onBackPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSavePress(_ sender: Any) {
        titleTextField.isEnabled = false
        noteTextView.isEditable = false
        saveButton.isEnabled = false
        
        if (titleTextField.text?.isEmpty ?? true) {
            let banner = NotificationBanner(title: "Error", subtitle: "Title cannot be empty", style: .danger)
            banner.show()
        } else if (noteTextView.text?.isEmpty ?? true) {
            let banner = NotificationBanner(title: "Error", subtitle: "Note cannot be empty", style: .danger)
            banner.show()
        } else {
            let userId = Auth.auth().currentUser?.uid
            let database = Database.database().reference().child("\(userId!)/notes")
            let note = ["title": titleTextField.text, "note": noteTextView.text]
            let dataNode = (currentNote != nil) ? database.child(currentNote.key): database.childByAutoId()
            dataNode.setValue(note) {
                (error, reference) in
                if (error != nil) {
                    let banner = NotificationBanner(title: "Error", subtitle: error!.localizedDescription, style: .danger)
                    banner.show()
                    print(error!.localizedDescription)
                } else {
                    let banner = NotificationBanner(title: "Success", subtitle: "Note saved", style: .success)
                    banner.show()
                }
                self.titleTextField.isEnabled = true
                self.noteTextView.isEditable = true
                self.saveButton.isEnabled = true
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
