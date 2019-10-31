//
//  DetailViewController.swift
//  ToDo
//
//  Created by Cesar Paiva on 20/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let dateFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyy"
           return dateFormatter
    }()
    
    var itemInfo: (ItemManager, Int)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemInfo = itemInfo else { return }
        let item = itemInfo.0.itemAtIndex(itemInfo.1)
        
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let coordinate = item.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapView.region = region
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        checkItem()
        navigationController?.popViewController(animated: true)
    }
    
    func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.0.checkItemAtIndex(itemInfo.1)
        }
    }
    
}
