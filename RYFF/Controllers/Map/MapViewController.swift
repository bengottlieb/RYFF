//
//  MapViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	@IBOutlet var mapView: MKMapView!
	
	var coords: CLLocationCoordinate2D!
	
	convenience init(lat: Double, lon: Double) {
		self.init(nibName: "MapViewController", bundle: nil)
		self.coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		let region = MKCoordinateRegion(center: self.coords, span: span)
		
		self.mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
