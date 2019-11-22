//
//  MapViewController.swift
//  MyGroups
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var group = Group()
    let annotationIdentifier = "AnnotationIdentifier"
    let locationManger = CLLocationManager()
    let regionInMeters = 10_000.00 // 10км
    var segueIdentifier = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var userLocationPinImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!    
    
    @IBAction func closeAction() {
        dismiss(animated: true)
    }
    
    @IBAction func showUserLocationAction(_ sender: Any) {
        showUserLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        setupMapView()
        checkLocationServices()
    }
    
    // MARK: - Placemark
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
    
    // MARK: - Location
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorizationStatus()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert("Location services are Disabled", message: "To enable it Go to Settings -> Privacy -> Location Services and turn on")
            }
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" { showUserLocation() }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert("Your location is not available", message: "To give permission Go to Setting ->  MyGroups -> Location")
            }
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
            break
        case .restricted:
            //showAlert("Location are not available", message: "Go to Setting and enable it")
            break;
        case .authorizedAlways:
            break
        @unknown default:
            print("New case available")
        }
    }
    
    private func setupLocationManager() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showUserLocation() {
        // отображаем текущее положение пользователя по центру экрана с радиусом regionInMeters
        if let userCoordinate = locationManger.location?.coordinate {
            let region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
            addressLabel.isHidden = false
            userLocationPinImageView.isHidden = false
            doneButton.isHidden = false
        }
    }
    
    private func setupMapView() {
        
        if segueIdentifier == "showGroupLocation" {
            setupPlacemark()
            
            addressLabel.isHidden = true
            userLocationPinImageView.isHidden = true
            doneButton.isHidden = true
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

// MARK: - Location
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
}
