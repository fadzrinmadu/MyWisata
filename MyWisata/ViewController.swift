//
//  ViewController.swift
//  MyWisata
//
//  Created by Mac Mini on 02/11/22.
//

import UIKit

class ViewController: UIViewController {
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyWisataData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WisataCell", for: indexPath) as? WisataTableViewCell {
            let wisata = dummyWisataData[indexPath.row]
            cell.setData(data: WisataTableViewCellData(
                name: wisata.name,
                image: wisata.image,
                description: wisata.description
            ))
            return cell
        } else {
            return UITableViewCell()
        }
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
