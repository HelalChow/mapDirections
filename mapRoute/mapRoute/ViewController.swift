//
//  ViewController.swift
//  mapRoute
//
//  Created by Helal Chowdhury on 9/17/19.
//  Copyright © 2019 Helal. All rights reserved.
//

import UIKit
import MapKit
import FlyoverKit

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
        self.mapSetup()
        
        let sourceLocation = getSourceLocation()
        let destinationLocation = getDestinationLocation()
        
        let sourcePin = customPin(pinTitle: "Prospect Park", pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: "Brooklyn Bridge", pinSubTitle: "", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
    }
    
    func getSourceLocation() ->CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
    }
    
    func getDestinationLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 40.7061, longitude: -73.9969)
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    
    @IBAction func showRoute(_ sender: Any) {
        let sourcePlaceMark = MKPlacemark(coordinate: getSourceLocation())
        let destinationPlaceMark = MKPlacemark(coordinate: getDestinationLocation())
        
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
    
    
    
    func mapSetup() {
        self.mapView.mapType = .hybridFlyover
        self.mapView.showsBuildings = true
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true

        let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 6.0, altitude: 40000, pitch: 45.0, headingStep: 40.0))
        camera.start(flyover: FlyoverAwesomePlace.newYork)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(100), execute:{
            camera.stop()
        })
    }


}

