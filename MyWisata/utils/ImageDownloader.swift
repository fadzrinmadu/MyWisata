//
//  ImageDownloader.swift
//  MyWisata
//
//  Created by Mac Mini on 26/11/22.
//

import UIKit

class ImageDownloader: Operation {
    private var wisata: WisataModel
    
    init(wisata: WisataModel) {
        self.wisata = wisata
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let imageData = try? Data(contentsOf: self.wisata.image) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            self.wisata.imageView = UIImage(data: imageData)
            self.wisata.state = .downloaded
        } else {
            self.wisata.imageView = nil
            self.wisata.state = .failed
        }
    }
}

class PendingOperations {
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.refactory.imageDownloaded"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
}
