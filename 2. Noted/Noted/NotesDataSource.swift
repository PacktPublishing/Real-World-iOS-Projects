//
//  NotesDataSource.swift
//  Noted
//
//  Created by Packt on 01.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import Foundation

protocol NotesDataSourceUpdate {
    func update(note: Note, body: String) -> String
}

protocol NotesDataSourceProtocol: NotesDataSourceUpdate {
    var notes: [Note] { get }

    func load(completion: @escaping (Error?) -> Void)
    func new(at index: Int)
    func delete(at index: Int) -> Note?
}

final class NotesDataSource: NotesDataSourceProtocol {

    private(set) var notes = [Note]()
    let url: URL

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue.global()

    init(filename: String) {
        url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(self, selector: #selector(save(notification:)), name: .UIApplicationDidEnterBackground, object: nil)
        noteCenter.addObserver(self, selector: #selector(save(notification:)), name: .UIApplicationWillTerminate, object: nil)
    }

    func new(at index: Int) {
        if index <= notes.count {
            notes.insert(Note(), at: index)
        }
    }

    func delete(at index: Int) -> Note? {
        if index < notes.count {
            let note = notes[index]
            notes.remove(at: index)
            return note
        } else {
            return nil
        }
    }

    func update(note: Note, body: String) -> String {
        let title = note.update(body: body)
        return title
    }

    @objc private func save(notification: Notification) {
        queue.async {
            do {
                let data = try self.encoder.encode(self.notes)
                try data.write(to: self.url)
                NSLog("Saved %d notes", self.notes.count)
            } catch {
                NSLog("Save error %@", error.localizedDescription)
            }
        }
    }

    func load(completion: @escaping (Error?) -> Void) {
        queue.async {
            do {
                let data = try Data(contentsOf: self.url)
                self.notes = try self.decoder.decode([Note].self, from: data)
            } catch let error as NSError where error.code == NSFileNoSuchFileError {
                // No saved notes yet
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }

            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

}
