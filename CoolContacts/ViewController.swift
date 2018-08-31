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
        
        let circleFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let circleView = UIView(frame: circleFrame)
        
        let base = UIBezierPath(arcCenter: CGPoint(x: 190,y: 200), radius: CGFloat(150), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let stripe = UIBezierPath(arcCenter: CGPoint(x: 190,y: 200), radius: CGFloat(115), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let baseLayer = CAShapeLayer()
        let stripelayer = CAShapeLayer()
        let textLayer = CATextLayer()
        
        let string = String("AT")
        textLayer.string = string
        
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.font = "ArialMT" as CFTypeRef
        textLayer.fontSize = 128
        textLayer.frame = CGRect(x: 100, y: 130, width: 700, height: 900)

        baseLayer.path = base.cgPath
        stripelayer.path = stripe.cgPath
        
        baseLayer.fillColor = UIColor.blue.cgColor
        stripelayer.fillColor = UIColor.clear.cgColor
        
        stripelayer.strokeColor = UIColor.white.cgColor
        
        baseLayer.lineWidth = 0
        stripelayer.lineWidth = 15
        
        
        circleView.layer.addSublayer(baseLayer)
        circleView.layer.addSublayer(stripelayer)
        circleView.layer.addSublayer(textLayer)

        view.addSubview(circleView)
    }

    @IBAction func savePhoto(_ sender: Any) {
        print("savePhoto")
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
