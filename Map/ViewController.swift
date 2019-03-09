//
//  ViewController.swift
//  Map
//
//  Created by Vanessa Latefa Pampilo on 2/26/19.
//  Copyright © 2019 Vanessa Latefa Pampilo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//final class MyAnnotationArray : NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//
//
//     init(coordinate : CLLocationCoordinate2D) {
//
//        self.coordinate = coordinate
//
//
//        super.init()
//
//    }
//
//}

                                            //protocol = interface //implementing the interfaces
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var annotationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    let defaults = UserDefaults.standard
    
 
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //; MKMapViewDelegate.self  //calls the method we provide
        locationManager.requestWhenInUseAuthorization() //calls to ask permission from the user
        locationManager.startUpdatingLocation() // only gets called when the permission got accepted and gets closed whenever you like
    }

    // _ external name the callers see, describes what the parameter is
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations:
        [CLLocation]) {
        
        //will get the first location //400 is the zoom meters
        if let coord2 = locations.first?.coordinate {
            
        let region = MKCoordinateRegion(center: coord2, latitudinalMeters: 400, longitudinalMeters: 400)
            
            //calling the mapView to move the right map on the screen
            mapView.setRegion(region, animated: true)
        }
    }
    
    //being called whenever the permission is changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:
        CLAuthorizationStatus) {
        
        // showing user location
        switch status {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
        default:
            mapView.showsUserLocation = false
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    
    @IBAction func longPress_is_pressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended {
           
            // you added a map annotation, after user is asked for a short text
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            let gpsCoord = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            
            var myAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = gpsCoord
            myAnnotation.title = annotationTextField.text
            
        
            mapView.addAnnotation(myAnnotation)
             print("long pressed at \(gpsCoord)")
        }
        
    }
    
  
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let myAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            
            myAnnotationView.animatesWhenAdded = true
            myAnnotationView.titleVisibility = .adaptive
            
            return myAnnotationView
        }
        
        return nil
    }
}

