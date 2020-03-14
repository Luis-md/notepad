//
//  NoteTableViewCell.swift
//  Notepad
//
//  Created by Luis Domingues on 14/03/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.config()
        self.accessoryType = .disclosureIndicator
     }
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    let textContent: UILabel = {
        let txt = UILabel()
//        txt.isEditable = false
//        txt.tintColor = .black
        txt.numberOfLines = 0
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let cellView: UIView = {
        let cell = UIView()
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }()
    
    func bind(txt: String) {
        self.textContent.text = txt
    }
    
    private func config() {
        self.configCell()
        self.configTxt()
    }
    
    private func configTxt() {
        self.cellView.addSubview(self.textContent)
        NSLayoutConstraint.activate([
            self.textContent.centerYAnchor.constraint(equalTo: self.cellView.centerYAnchor),
            self.textContent.leftAnchor.constraint(equalTo: self.cellView.leftAnchor),
            self.textContent.rightAnchor.constraint(equalTo: self.cellView.rightAnchor)
        ])
    }
    
    private func configCell() {
        self.addSubview(self.cellView)
        NSLayoutConstraint.activate([
            self.cellView.topAnchor.constraint(equalTo: self.topAnchor),
            self.cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cellView.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }

}
