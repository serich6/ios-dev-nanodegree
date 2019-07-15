//
//  PhotoAlbumVC.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumVC: UIViewController, MKMapViewDelegate, UICollectionViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
   // @IBOutlet weak var toolBarTitle: UIBarButtonItem!
    // TODO: add a photo album here - if it's nil when we preform the segue, add the label No Images
    var hasPhotos: Bool = false
    
    @IBOutlet weak var toolBarTitle: UIBarButtonItem!
    var mapCenterCoordinate: CLLocationCoordinate2D!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        if hasPhotos {
            toolBarTitle.title = "New Collection"
            
        } else {
            toolBarTitle.title = "No Images"
        }
        
    }
}
