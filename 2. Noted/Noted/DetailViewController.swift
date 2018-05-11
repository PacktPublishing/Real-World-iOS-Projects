//
//  DetailViewController.swift
//  Noted
//
//  Created by Packt on 01.04.18.
//  Copyright © 2018 Packt. All rights reserved.
//

import UIKit

protocol DetailViewControllerProtocol {
    var note: Note? { get }
    func set(note: Note, delegate: DetailViewControllerDelegate)
    func clear()
}

protocol DetailViewControllerDelegate: class, NotesDataSourceUpdate {}

class DetailViewController: UIViewController, DetailViewControllerProtocol {

    var textView: UITextView? {
        return view as? UITextView
    }

    private weak var delegate: DetailViewControllerDelegate?

    private(set) var note: Note? {
        didSet {
            configureView()
        }
    }

    func set(note: Note, delegate: DetailViewControllerDelegate) {
        self.note = note
        self.delegate = delegate
    }

    func clear() {
        self.note = nil
        self.delegate = nil
    }

    func configureView() {
        if let note = note {
            title = note.title
            textView?.text = note.body(trimmed: false)
            textView?.isUserInteractionEnabled = true
            textView?.becomeFirstResponder()
        } else {
            title = nil
            textView?.text = nil
            textView?.isUserInteractionEnabled = false
            textView?.resignFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(self, selector: #selector(keyboardFrameWillChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        configureView()
    }

}

extension DetailViewController {
    @objc private func keyboardFrameWillChange(notification: Notification) {
        if
            let userInfo = notification.userInfo,
            let window = view.window,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let textView = textView
        {
            let keyboard = window.convert(value.cgRectValue, to: view)
            let offset = keyboard.height - view.safeAreaInsets.bottom

            UIView.animate(withDuration: duration.doubleValue,
                           delay: 0,
                           options: UIViewAnimationOptions(rawValue: curve.uintValue << 16),
                           animations:
                {
                    var insets = textView.contentInset
                    insets.bottom = offset
                    textView.contentInset = insets
                    textView.scrollIndicatorInsets = insets
            }, completion: nil)
        }

    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let note = note {
            title = delegate?.update(note: note, body: textView.text)
        }
    }
}

