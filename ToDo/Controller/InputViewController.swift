//
//  InputViewController.swift
//  ToDo
//
//  Created by Cesar Paiva on 22/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    let dateFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyy"
           return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutButtons()
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.count > 0 else { return }
        
        let date: Date?
        
        if let dateText = dateTextField.text, dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        
        let descriptionString: String?
        
        if descriptionTextField.text?.count ?? 0 > 0 {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }
        
        if let locationName = locationTextField.text, locationName.count > 0 {
            if let address = addressTextField.text, address.count > 0 {
                geocoder.geocodeAddressString(address) { (placeMarks, error) in
                    
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                    
                    DispatchQueue.main.async {
                        self.itemManager?.addItem(item)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName))
                self.itemManager?.addItem(item)
                dismiss(animated: true, completion: nil)
                
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: nil)
            self.itemManager?.addItem(item)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func layoutButtons() {
        cancelButton.layer.cornerRadius = 8.0
        saveButton.layer.cornerRadius = 8.0
    }

}
