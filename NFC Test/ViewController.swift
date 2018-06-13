//
//  ViewController.swift
//  NFC Test
//
//  Created by Justin Vallely on 6/7/18.
//  Copyright © 2018 Ibotta. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    // Reference the NFC session
    private var nfcSession: NFCNDEFReaderSession!

    // Reference the found NFC messages
    private var nfcMessages: [[NFCNDEFMessage]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.borderColor = UIColor.blue.cgColor
        scanButton.layer.borderWidth = 2
        scanButton.layer.cornerRadius = 3

        createNfcSession()

        // A custom description that helps users understand how they can use NFC reader mode in your app.
        self.nfcSession.alertMessage = "You can hold your NFC-tag to the back-top of your iPhone"
    }

    @IBAction func scanButtonAction(_ sender: Any) {
        // nuke the old session and start fresh
        self.nfcSession.invalidate()
        createNfcSession()

        // Begin scanning
        self.nfcSession.begin()
    }

    private func createNfcSession() {

        // Create the NFC Reader Session when the app starts
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }

}

extension ViewController: NFCNDEFReaderSessionDelegate {

    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }

    // Called when a new set of NDEF messages is found
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")

        for message in messages {
            for record in message.records {
                let name = "Type name format: \(record.typeNameFormat)"
                let payload = "Payload: \(record.payload)"
                let type = "Type: \(record.type)"
                let identifier = "Identifier: \(record.identifier)"

                textView.text = "name: \(name)\npayload: \(payload)\ntype: \(type)\nidentifier: \(identifier)\n"
            }
        }

        // Add the new messages to our found messages
        self.nfcMessages.append(messages)

//        // Reload our table-view on the main-thread to display the new data-set
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
}
