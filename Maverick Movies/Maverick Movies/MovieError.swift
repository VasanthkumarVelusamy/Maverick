//
//  MovieError.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

enum MovieError: Error {
    case invalidMovieName(String)
    case movieNotFound(String)
    case unknown(String)
}
