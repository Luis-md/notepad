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

    var content: [NoteTest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.config()
    }
    
    private func config() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addContent))
        self.navigationItem.title = "Notes"
        self.configTableView()
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
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
    
    @objc private func addContent() {
                
        let alert = UIAlertController(title: "Add a note", message: "", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let textField = alert.textFields![0] as UITextField
            if let title = textField.text {
                let newNote = NoteTest(title: title, text: "")
                self.content.append(newNote)
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField( configurationHandler: { (textField) in
            textField.placeholder = "Note's title"
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
        cell.bind(txt: content[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

