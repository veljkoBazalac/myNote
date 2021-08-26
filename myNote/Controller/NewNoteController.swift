//
//  NewNoteController.swift
//  myNote
//
//  Created by Veljko on 20.8.21..
//

import UIKit
import CoreData


class NewNoteController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var notes = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        titleTextField.delegate = self
        noteTextField.delegate = self
        
        
    }
    
    
    //MARK: - Title Change
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if titleTextField.text != "" {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - Note Change
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if noteTextField.text != "" {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    
    //MARK: - Add New Note
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if sender.currentTitle != "BACK" {
            
            if titleTextField.text != "", noteTextField.text != "" {
                
                let newNote = Note(context: self.context)
                newNote.title = titleTextField.text
                newNote.body = noteTextField.text
                self.notes.append(newNote)
                
                saveNotes()
                sender.setTitle("BACK", for: .normal)
                
            } else if titleTextField.text == "" {
                
                let alert = UIAlertController(title: "Please enter your Title", message: "", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else if noteTextField.text == "" {
                
                let alert = UIAlertController(title: "Please enter your Note", message: "", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - Note Save
    
    func saveNotes() {
        
        do {
            try context.save()
            
            let alert = UIAlertController(title: "Note successfully saved", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
            
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}
