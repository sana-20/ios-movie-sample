//
//  MainViewModel.swift
//  ios-quest
//
//  Created by Schive on 2022/02/10.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieListViewModel {
    let moviesVM: [MovieViewModel]
}

extension MovieListViewModel {
    
    init(_ movies: [Movie]) {
        self.moviesVM = movies.compactMap(MovieViewModel.init)
    }
    
    func movieAt(_ index: Int) -> MovieViewModel {
        return self.moviesVM[index]
    }
    
}


struct MovieViewModel {
    
    let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
}

extension MovieViewModel {
    
    var title: Observable<String> {
        return Observable<String>.just(movie.title)
    }
    
    var rating: Observable<String> {
        return Observable<String>.just(String(movie.rating))
    }
    
}
