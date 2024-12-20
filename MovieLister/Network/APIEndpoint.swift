//
//  APIEndpoint.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//


import Foundation

struct APIEndpoint {
    let baseUrl: String
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    var body: Data?

    var url: URL? {
        URL(string: baseUrl + path)
    }

    static func popularMovies(page: Int) -> APIEndpoint {
        APIEndpoint(
            baseUrl: NetworkConstants.tmdbHost,
            path: "movie/popular?page=\(page)",
            method: .get,
            headers: [
                NetworkConstants.defaultContentTypeKey : NetworkConstants.defaultContentType,
                NetworkConstants.authTypeKey : NetworkConstants.accessTokenAuth
            ],
            body: nil
        )
    }

    static func movieDetail(movieId: Int) -> APIEndpoint {
        APIEndpoint(
            baseUrl: NetworkConstants.tmdbHost,
            path: "movie/\(movieId)",
            method: .get,
            headers: [
                NetworkConstants.defaultContentTypeKey : NetworkConstants.defaultContentType,
                NetworkConstants.authTypeKey : NetworkConstants.accessTokenAuth
            ],
            body: nil
        )
    }
    
    static func uploadImage() -> APIEndpoint {
        APIEndpoint(
            baseUrl: NetworkConstants.imageHost,
            path: NetworkConstants.imageUploadPath,
            method: .post,
            headers: [
                NetworkConstants.defaultContentTypeKey : NetworkConstants.defaultContentType,
                NetworkConstants.contentTypeKey : NetworkConstants.defaultContentType
            ],
            body: nil
        )
    }
}
