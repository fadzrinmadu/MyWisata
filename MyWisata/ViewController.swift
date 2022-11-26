//
//  ViewController.swift
//  MyWisata
//
//  Created by Mac Mini on 02/11/22.
//

import UIKit

class ViewController: UIViewController {
    private let pendingOperations = PendingOperations()
    
    @IBOutlet weak var wisataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wisataTableView.dataSource = self
        wisataTableView.delegate = self
        
        wisataTableView.register(
            UINib(nibName: "WisataTableViewCell", bundle: nil),
            forCellReuseIdentifier: "WisataCell"
        )
    }
    
    @IBAction func onGoToWebsitePressed(_ sender: Any) {
        let urlWikipedia = "https://id.wikipedia.org/wiki/Pariwisata_di_Indonesia"
        if let url = URL(string: urlWikipedia), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}


// MARK: Handle ketika user sedang scroll maka download akan dihentikan sementara
extension ViewController: UIScrollViewDelegate {
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
        pendingOperations.downloadQueue.isSuspended = isSuspended
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyWisataData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WisataCell", for: indexPath) as? WisataTableViewCell {
            let wisata = dummyWisataData[indexPath.row]
            
            let data = WisataTableViewCellData(
                name: wisata.name,
                description: wisata.description,
                image: wisata.imageView
            )
            
            cell.setData(data: data)
            
            if wisata.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startOperations(wisata: wisata, indexPath: indexPath)
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.indicatorLoading.isHidden = true
            }
        
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    fileprivate func startOperations(wisata: WisataModel, indexPath: IndexPath) {
        if wisata.state == .new {
            startDownload(wisata: wisata, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(wisata: WisataModel, indexPath: IndexPath) {
        guard pendingOperations.downloadInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(wisata: wisata)
        
        downloader.completionBlock = {
            if downloader.isCancelled { return }
            DispatchQueue.main.async {
                self.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                self.wisataTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moveToDetail", sender: dummyWisataData[indexPath.row])
    }
    
    
    /*
         Kode prepare segue digunakan untuk menyediakan data sebelum segue dieksekusi.
         Jadi ketika identifier/ID-nya adalah “moveToDetail” dan destination/tujuannya adalah DetailViewController, datanya akan dikirim.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.wisata = sender as? WisataModel
            }
        }
    }
}
