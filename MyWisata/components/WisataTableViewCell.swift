//
//  WisataTableViewCell.swift
//  MyWisata
//
//  Created by Mac Mini on 04/11/22.
//

import UIKit

struct WisataTableViewCellData {
    var name: String
    var description: String
    var image: UIImage?
}

class WisataTableViewCell: UITableViewCell {
    @IBOutlet weak var wisataImageView: UIImageView!
    @IBOutlet weak var wisataTitleLabel: UILabel!
    @IBOutlet weak var wisataDescriptionLabel: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: WisataTableViewCellData) {
        wisataTitleLabel.text = data.name
        wisataDescriptionLabel.text = data.description
        wisataImageView.image = data.image
    }
}
