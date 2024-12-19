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
            baseUrl: "https://api.themoviedb.org/3/",
            path: "movie/popular?page=\(page)",
            method: .get,
            headers: [
                "accept" : "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YjRiN2U4NTMzNGU2NGI0MDBhNWM5OGJlNzI0YjI4OSIsInN1YiI6IjY2NTQ5NzhmYTJjMzBhYTZhODliODFiOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oLjGkyl7pjiEifZbsyqYBs_XJhlAFBGjpR-0tyVFv9A"
            ],
            body: nil
        )
    }

    static func movieDetail(movieId: Int) -> APIEndpoint {
        APIEndpoint(
            baseUrl: "https://api.themoviedb.org/3/",
            path: "movie/\(movieId)",
            method: .get,
            headers: [
                "accept" : "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YjRiN2U4NTMzNGU2NGI0MDBhNWM5OGJlNzI0YjI4OSIsInN1YiI6IjY2NTQ5NzhmYTJjMzBhYTZhODliODFiOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oLjGkyl7pjiEifZbsyqYBs_XJhlAFBGjpR-0tyVFv9A"
            ],
            body: nil
        )
    }
    
    static func uploadImage() -> APIEndpoint {
        APIEndpoint(
            baseUrl: "https://www.nftcalculatorsapp.net/",
            path: "text_to_image_case_study",
            method: .post,
            headers: [
                "accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: nil
        )
    }
}
