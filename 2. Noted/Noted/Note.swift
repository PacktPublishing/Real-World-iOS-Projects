//
//  Note.swift
//  Noted
//
//  Created by Packt on 01.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import Foundation

protocol NoteProtocol: Codable {
    var title: String { get }
    var date: Date { get }

    func body(trimmed: Bool) -> String
    func update(body: String) -> String
}

final class Note: NoteProtocol {

    private(set) var title: String = Note.emptyNote
    private(set) var date: Date = Date()

    private var body: String = "" {
        didSet {
            let trimmed = body(trimmed: true)
            let components = trimmed.components(separatedBy: "\n")

            if components.isEmpty {
                title = Note.emptyNote
            } else {
                title = components[0]
            }

            date = Date()
        }
    }

    func body(trimmed: Bool) -> String {
        if trimmed {
            return body.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return body
        }
    }

    func update(body: String) -> String {
        self.body = body
        return title
    }

    static let emptyNote = NSLocalizedString("New note", comment: "Empty note title")
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.date == rhs.date
    }


}




