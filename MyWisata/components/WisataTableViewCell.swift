//
//  WisataTableViewCell.swift
//  MyWisata
//
//  Created by Mac Mini on 04/11/22.
//

import UIKit

struct WisataTableViewCellData {
    let name: String
    let image: String
    let description: String
}

class WisataTableViewCell: UITableViewCell {
    @IBOutlet weak var wisataImageView: UIImageView!
    @IBOutlet weak var wisataTitleLabel: UILabel!
    @IBOutlet weak var wisataDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: WisataTableViewCellData) {
        wisataTitleLabel.text = data.name
        wisataDescriptionLabel.text = data.description
        wisataImageView.downloaded(from: data.image, contentMode: .scaleAspectFill)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
