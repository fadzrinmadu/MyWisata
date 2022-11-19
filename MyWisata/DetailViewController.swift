//
//  DetailViewController.swift
//  MyWisata
//
//  Created by Mac Mini on 07/11/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var wisataImage: UIImageView!
    @IBOutlet weak var wisataTitleLabel: UILabel!
    @IBOutlet weak var wisataDescriptionLabel: UILabel!
    
    var wisata: WisataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let result = wisata {
            wisataImage.downloaded(from: result.image)
            wisataTitleLabel.text = result.name
            wisataDescriptionLabel.text = result.description
        }
    }
}
