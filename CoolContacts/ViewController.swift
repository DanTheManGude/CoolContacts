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

    @IBAction func buttonPressed(_ sender: Any) {
        print("You, clicked the button")
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            
            
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
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
