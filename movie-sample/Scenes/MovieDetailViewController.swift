//
//  MovieDetailViewController.swift
//  ios-quest
//
//  Created by Schive on 2022/02/10.
//

import Foundation
import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var item : MovieViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = item!.movie.title
        ratingLabel.text = String(item!.movie.rating)
        guard let url = URL(string: item!.movie.large_cover_image) else {return}
        imageView.kf.setImage(with: url)
    }
    
    func receiveItem(_ item: MovieViewModel) {
        self.item = item
    }
}
