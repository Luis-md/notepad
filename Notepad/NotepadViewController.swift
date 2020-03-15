//
//  ViewController.swift
//  Notepad
//
//  Created by Luis Domingues on 14/03/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
import CoreData

class NotepadViewController: UIViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var content: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    private func config() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addContent))
        self.navigationItem.title = "Notes"
        self.configTableView()
        self.loadNotes()
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44  
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private func configTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    private func saveNote() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    private func loadNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            self.content = try self.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    @objc private func addContent() {
        let alert = UIAlertController(title: "Add a note", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let add = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newNote = Note(context: self.context)
            newNote.title = textField.text!
            
            if(newNote.title?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return self.dismiss(animated: true, completion: nil)
            }
            
            self.content.append(newNote)
            
            self.saveNote()
        }
        
        alert.addTextField( configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Note's title"
            textField = alertTextField
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension NotepadViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteTableViewCell
        cell.bind(txt: content[indexPath.row].title!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(content[indexPath.row])
            self.content.remove(at: indexPath.row)
            self.saveNote()
        }
    }
}

