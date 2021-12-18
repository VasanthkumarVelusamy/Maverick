//
//  Router.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

enum Router {
    case fetchMovies
    case fetchDetails

    var scheme: String {
      switch self {
      default:
        return "http"
      }
    }
    
    var method: String {
      switch self {
      default:
        return "POST"
      }
    }
    
    var port: Int {
        switch self {
        default:
            return 80
        }
    }
    
    var host: String {
      switch self {
      default:
        return "www.omdbapi.com"
      }
    }
    
    var path: String {
      switch self {
      default:
          return "/"
      }
    }
}
 
