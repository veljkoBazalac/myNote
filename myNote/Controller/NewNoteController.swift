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
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        noteTextField.delegate = self
    }
    
    //MARK: - Title Writing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if titleTextField.text != "" {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 30
    }
    
    //MARK: - Note Writing
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if noteTextField.text != "" {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    //MARK: - Buttons Manipulation
    
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
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        noteTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        doneButton.isHidden = true
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
