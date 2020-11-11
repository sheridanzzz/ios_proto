//
//  KolodaViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import Koloda
import UIKit

class KolodaViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {
    
    
    @IBOutlet weak var myContentsKolodaView: KolodaView!
    
    var imageStock = [UIImage]() // array of images
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
        setupForKoloda()
        reloadImages()
    }
    
    // fetch added images and appended to imageStock
    func fetchImages() {
        guard let swipeRight = UIImage(named: "swipe_right.jpg"), let swipeLeft = UIImage(named: "swipe_left.png"), let basketball = UIImage(named: "basketball.png"), let football = UIImage(named: "football.png"), let rugby = UIImage(named: "rugby.png") else { return } // fetch images
        imageStock.append(swipeRight)
        imageStock.append(swipeLeft)
        imageStock.append(basketball)
        imageStock.append(football)
        imageStock.append(rugby)
    }
    
    // initialized koloda
    func setupForKoloda() {
        
        myContentsKolodaView.delegate = self
        myContentsKolodaView.dataSource = self
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: imageStock[index]) // sorting
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast // fast swiping
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return imageStock.count // images count
    }
    
    func reloadImages() {
        myContentsKolodaView.reloadData() // reload kolodaView after images pull the images
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        fetchImages() // pull images again
        reloadImages() // reload kolodaView
    }
    
}



