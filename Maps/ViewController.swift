//
//  ViewController.swift
//  Maps
//
//  Created by Students on 06/03/2019.
//  Copyright © 2019 students. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    //GLOBALIE MAINIGIE
    @IBOutlet var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var localPosition = CLLocationCoordinate2D()
    
    let bingo = MKPointAnnotation()
    let tinte = MKPointAnnotation()
    let puce = MKPointAnnotation()
    
    var selectedAnnotation: MKPointAnnotation?
    
    var switchBool: Bool = false
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        locationManager.delegate = self
        startTrackingLocation()
        
        
        bingo.coordinate = CLLocationCoordinate2D(latitude: 57.172832, longitude: 26.757250)
            bingo.title = "Bingo"
            mapView.addAnnotation(bingo)
        
        tinte.coordinate = CLLocationCoordinate2D(latitude: 57.540862, longitude: 25.4264813)
            tinte.title = "Tinte"
            mapView.addAnnotation(tinte)
        
        puce.coordinate = CLLocationCoordinate2D(latitude: 56.945916, longitude: 24.107605)
            puce.title = "Pūce"
            mapView.addAnnotation(puce)
        
        mapView.showsUserLocation = true
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }

    //sarkanais markeris
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            //izveidojam annotation info pogu
            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    // Here we add disclosure button inside annotation window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton(type: UIButton.ButtonType.detailDisclosure) as UIButton
        // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    //registrejam, ka tiek nospiesta markera poga
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.selectedAnnotation = view.annotation as? MKPointAnnotation //nolasa, kuru pinu nospieda
        
        //when button is pressed, do something...
        calculate(annot: selectedAnnotation!)
        
    }
    
    //sak meklet atrasanas vietu
    func startTrackingLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //izprinte atrasanas vietu
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        localPosition = manager.location!.coordinate
        print("Location: \(localPosition.latitude) , \(localPosition.longitude) ")
        print("Mana atrašanās vieta: \(locations[0])")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    //dinamiski aprekina route
    func calculate( annot: MKAnnotation){
        let directionRequest = MKDirections.Request()
        
        mapView.removeOverlays(mapView.overlays)//nodzēš iepriekšējo route

        //sakuma punkts - pasreizeja atrasanas vieta
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: localPosition.latitude, longitude: localPosition.longitude)))

        //gala punkts - uzspiestais pins
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: annot.coordinate.latitude , longitude: annot.coordinate.longitude)))

        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            }
        }
        
    }

    //sarkanais route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        
        return renderer
    }
    
    //nodod datus otram viewControllerim
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filterViewController = segue.destination as? SecondViewController
        
        //nodod SecondViewControllera mainīgajiem šī controllera vērtības
        filterViewController?.mapViewSecond = mapView
        filterViewController?.localPosition = localPosition
        filterViewController?.switchBool = switchBool
    }
    
    
}
