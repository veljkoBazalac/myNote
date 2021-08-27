//
//  ViewController.swift
//  myNote
//
//  Created by Veljko on 20.8.21..
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notesArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            loadNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        searchBar.delegate = self
    }
    
    //MARK: - Table View SourceData
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notesArray[indexPath.row]
        cell.textLabel?.text = note.title
        
        return cell
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "readNoteSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readNoteSegue" {
            let destinationVC = segue.destination as! ReadViewController
            
            if let indexPath = myTableView.indexPathForSelectedRow {
                destinationVC.cellBody = notesArray[indexPath.row].body
                destinationVC.cellTitle = notesArray[indexPath.row].title
                destinationVC.complitionHandlerTitle = { text in
                    self.notesArray[indexPath.row].title = text
                    
                }
                destinationVC.complitionHandlerNote = { text in
                    self.notesArray[indexPath.row].body = text
                }
            }
        }
    }
    
    //MARK: - Move Cells
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let note = notesArray[sourceIndexPath.row]
        notesArray.remove(at: sourceIndexPath.row)
        notesArray.insert(note, at: destinationIndexPath.row)
    }
    
    @IBAction func editRows(_ sender: UIBarButtonItem) {
        myTableView.isEditing = !myTableView.isEditing
    }
    
    //MARK: - Delete Cells on Swipe
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            context.delete(notesArray[indexPath.row])
            notesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveNotes()
        }
    }
    
    //MARK: - Context Manipulation
    
    func loadNotes (with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error fetching the context, \(error)")
        }
        self.myTableView.reloadData()
    }
    
    func saveNotes() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}

//MARK: - Search Bar

extension NoteViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            let request : NSFetchRequest<Note> = Note.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            searchBar.resignFirstResponder()
            loadNotes(with: request)
  
        } else {
      
            let alert = UIAlertController(title: "Enter your note title", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
            loadNotes()
        }
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        loadNotes()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadNotes()
        }
    }
}

