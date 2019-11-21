//
//  MapViewController.swift
//  MyGroups
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var group: Group?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func closeAction() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlacemark()
    }
    
    private func setupPlacemark() {
        guard let group = self.group, let location = group.location else { return }
        
        let coder = CLGeocoder()
        
        coder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarkLocation = placemarks?.first?.location else { return }
            
            let annotation = MKPointAnnotation()
            annotation.title = location
            annotation.subtitle = group.genre
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
}
