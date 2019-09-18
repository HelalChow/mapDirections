//
//  ViewController.swift
//  mapRoute
//
//  Created by Helal Chowdhury on 9/17/19.
//  Copyright © 2019 Helal. All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitile: String?
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitile = pinSubTitle
        self.coordinate = location
    }
    
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let sourceLocation = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.7061, longitude: -73.9969)
        
        let sourcePin = customPin(pinTitle: "Prospect Park", pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: "Brooklyn Bridge", pinSubTitle: "", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {(response, error) in
            guard let directionResponse = response else {
                if let error = error{
                    print("There was an error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }


}

