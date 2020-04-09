//
//  MapViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 09.04.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var workTask: WorkTask!
    var annotationIdentifier = "annotationIdentifier"
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlacemark()
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Место задачи"
        self.navigationItem.backBarButtonItem?.title = "Назад"
        
    }
    

    
    private func setupPlacemark() {
        
        guard let location = workTask.taskLocation else {return}
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
        

            guard let placemarks = placemarks else {return}

            let placemark = placemarks.first

            let annotation = MKPointAnnotation()
            annotation.title = self.workTask.name ?? ""
            let dateString = (self.workTask.taskDate)?.toString(dateFormat: "dd MMM HH:mm")
            annotation.subtitle = dateString
            
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
}
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        if let imageData = workTask.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    
}