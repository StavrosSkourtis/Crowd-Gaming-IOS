//
//  MapViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 25/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate{

    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    var group : QuestionGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        
        print("Group \(group.id) Map on Location \(group.latitude!) \(group.longitude!) \(group.radius!)")
        let initialLocation = CLLocation(latitude: group.latitude!, longitude: group.longitude! )
        
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
            group.radius! * 10.0, group.radius! * 10.0)
        

        let newCircle = MKCircle(centerCoordinate: initialLocation.coordinate, radius: group.radius! as CLLocationDistance)
        
        
        mapView.removeOverlays(mapView.overlays)
        
        mapView.addOverlay(newCircle)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(group.latitude!, group.longitude!)
        
        let objectAnnotation = MKPointAnnotation()
        
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = group.name
        
        mapView.addAnnotation(objectAnnotation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 50/255.0)
            circleRenderer.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
