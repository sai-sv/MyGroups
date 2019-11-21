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
    
    var group = Group()
    let annotationIdentifier = "AnnotationIdentifier"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func closeAction() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        setupPlacemark()
    }
    
    private func setupPlacemark() {
        
        guard let location = group.location else { return }
        
        let coder = CLGeocoder()
        
        coder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarkLocation = placemarks?.first?.location else { return }
            
            let annotation = MKPointAnnotation()
            annotation.title = location
            annotation.subtitle = self.group.genre
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil } // не должно быть положением пользователя
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true // отображение банера
        }
        
        if let imageData = group.imageData {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            
            annotationView?.rightCalloutAccessoryView = imageView
        }
            
        return annotationView
    }
}
