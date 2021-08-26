//
//  ReadViewController.swift
//  myNote
//
//  Created by Veljko on 23.8.21..
//

import UIKit
import CoreData


class ReadViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var notesArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cellTitle : String?
    var cellBody : String?
    var complitionHandlerTitle : ((String?) -> Void)?
    var complitionHandlerNote : ((String?) -> Void)?
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        loadNotes()
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextField.delegate = self
        titleTextField.delegate = self
        
        noteTextField.text = cellBody
        titleTextField.text = cellTitle
        
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4863265157, blue: 0, alpha: 1)
        
    }
    
    
    //MARK: - Title Change
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if titleTextField.text != cellTitle {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - Note Change
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextField.text != cellBody {
            backButton.setTitle("SAVE", for: .normal)
        }
    }
    
    
    //MARK: - Button Manipulation
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        if sender.currentTitle == "SAVE" {
            
            let alert = UIAlertController(title: "Are you sure you want to save changes?", message: "Your previous note will be deleted.", preferredStyle: .alert)
            let actionNO = UIAlertAction(title: "NO", style: .default) { action in
                sender.setTitle("BACK", for: .normal)
            }
            let actionYES = UIAlertAction(title: "YES", style: .default) { [self] action in
                
                if titleTextField.text != "", noteTextField.text != "" {
                    
                    complitionHandlerTitle?(titleTextField.text!)
                    complitionHandlerNote?(noteTextField.text!)
                    sender.setTitle("BACK", for: .normal)
                    self.saveNotes()
                    
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
                
            }
            
            alert.addAction(actionYES)
            alert.addAction(actionNO)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Note Save
    
    func saveNotes() {
        
        do {
            try context.save()
            
            let alert = UIAlertController(title: "Note saved successfully", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
            
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadNotes (with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error fetching the context, \(error)")
        }
    }
    
}
