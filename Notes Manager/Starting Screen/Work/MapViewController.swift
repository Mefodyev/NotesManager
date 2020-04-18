//
//  MapViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 09.04.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var workTask: WorkTask!
    var annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showUserLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlacemark()
        checkLocationServices()
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Место задачи"
        self.navigationItem.backBarButtonItem?.title = "Назад"
        
    }
    
    
    @IBAction func showUserLocationInCenter() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 300000, longitudinalMeters: 300000)
            mapView.setRegion(region, animated: true)
        }
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
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            showUserLocationButton.alpha = 1
        } else {
            showUserLocationButton.alpha = 0
            //alert может не появиться, поскольку загружается из вью дид лод, поэтому нужно вызвать после отображения
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let ac = UIAlertController(title: "Упс..на проблемку напали", message: "Для определения местоположения разрешите приложению использовать вашу геопозицию в настройках", preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil   )
                self.present(ac, animated: true)
                ac.addAction(cancel)
                ac.addAction(ok)
            }
            
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy =  kCLLocationAccuracyBest
    }
    
    //проверка прил-я на разрешения использовать геолокацию
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            //разрешено ис-ть геолокацию только в момент использования
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied:
            let ac = UIAlertController(title: "Упс..на проблемку напали", message: "Для определения местоположения разрешите приложению использовать вашу геопозицию", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil   )
            present(ac, animated: true)
            ac.addAction(cancel)
            ac.addAction(ok)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
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

extension MapViewController: CLLocationManagerDelegate {
    //вызывается каждый раз при изменении статуса отслеживания геолокации (нужно в самый первый раз когда пользователь разрешил доступ)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
