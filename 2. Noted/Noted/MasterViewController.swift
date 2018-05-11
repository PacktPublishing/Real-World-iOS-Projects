//
//  MasterViewController.swift
//  Noted
//
//  Created by Packt on 01.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let dataSource = NotesDataSource(filename: "notes.json")

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.load { (error) in
            self.navigationItem.leftBarButtonItem = self.editButtonItem

            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.insertNewObject(_:)))
            self.navigationItem.rightBarButtonItem = addButton

            self.tableView.reloadData()
        }
    }

    @objc
    func insertNewObject(_ sender: Any) {
        dataSource.new(at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let detailViewController = navigationController?.topViewController as? DetailViewController
        let indexPath = tableView.indexPathForSelectedRow

        if let detailViewController = detailViewController, let indexPath = indexPath {
            let note = dataSource.notes[indexPath.row]
            detailViewController.set(note: note, delegate: self)
        }
    }

}

extension MasterViewController: DetailViewControllerDelegate {
    func update(note: Note, body: String) -> String {
        let title = dataSource.update(note: note, body: body)
        tableView.reloadData()
        return title
    }
}

extension MasterViewController {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let note = dataSource.delete(at: indexPath.row) {
            tableView.deleteRows(at: [indexPath], with: .automatic)

            let navigationController = splitViewController?.viewControllers.last as? UINavigationController
            let detailViewController = navigationController?.topViewController as? DetailViewController

            if detailViewController?.note == note {
                detailViewController?.clear()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = dataSource.notes[indexPath.item]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.date.description
        return cell
    }
}






