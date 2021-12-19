//
//  MovieDetail.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 19/12/21.
//

import Foundation

struct MovieDetail: Codable {
    var title: String?
    var year: String?
    var genre: String?
    var runtime: String?
    var imdbRating: String?
    var plot: String?
    var imdbVotes: String?
    var metascore: String?
    var director: String?
    var writer: String?
    var actors: String?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case runtime = "Runtime"
        case imdbRating = "imdbRating"
        case plot = "Plot"
        case imdbVotes = "imdbVotes"
        case metascore = "Metascore"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case poster = "Poster"
    }
    
}
