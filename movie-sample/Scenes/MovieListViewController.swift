//
//  MovieListViewController.swift
//  ios-quest
//
//  Created by Schive on 2022/02/10.
//

import Foundation
import UIKit
import RxSwift

class MovieListViewController: UITableViewController {
    
    var movies: [Movie]? = nil
    
    let disposeBag = DisposeBag()
    
    private var movieListVM: MovieListViewModel!
    
    @IBOutlet var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    func receiveItem(_ item: [Movie]?){
        movieListVM = MovieListViewModel(item!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListVM == nil ? 0: self.movieListVM.moviesVM.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("MovieCell is not found")
        }
        
        let movieVM = self.movieListVM.movieAt(indexPath.row)
        
        movieVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieVM.rating.asDriver(onErrorJustReturn: "")
            .drive(cell.ratingLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            let cell = sender as! MovieCell
            let indexPath = self.movieTableView.indexPath(for: cell)
            let detailView = segue.destination as! MovieDetailViewController
            detailView.receiveItem(movieListVM.moviesVM[(indexPath! as NSIndexPath).row])
        }
    }
    
    
    
}
