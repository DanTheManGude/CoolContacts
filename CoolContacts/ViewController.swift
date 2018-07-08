//
//  ViewController.swift
//  CoolContacts
//
//  Created by Daniel Gude on 7/7/18.
//  Copyright © 2018 Daniel Gude. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController , CNContactPickerDelegate {

    @IBAction func allContacts(_ sender: Any) {
        let store = CNContactStore()

        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var contacts: [CNContact] = []
        
        // Loop the containers
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                // Put them into "contacts"
                contacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        for contact in contacts {
            changeContact(contact)
        }
    }
    
    @IBAction func someContacts(_ sender: UIButton) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            
            
            changeContact(contact)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    func changeContact(_ contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        let initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        
        let mutableContact = contact.mutableCopy() as! CNMutableContact
        
        let h = Float(arc4random()) / 0xFFFFFFFF
        let color = "(\(h), 0.5, 0.95)"
        
        print("Initials: \(initials)")
        print("Color: \(color)")
        
        mutableContact.nickname.append(initials)
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.update(mutableContact)
        try! store.execute(saveRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
