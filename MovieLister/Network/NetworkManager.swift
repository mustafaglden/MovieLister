//
//  NetworkManager.swift
//  MovieLister
//
//  Created by Mustafa on 17.12.2024.
//


import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Create the URL
        guard let url = endpoint.url else {
            print("❌ [Request] Invalid URL for endpoint: \(endpoint.path)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // Debug: Log the request details
        print("🌐 [Request] URL: \(url.absoluteString)")
        print("🌐 [Request] Method: \(endpoint.method.rawValue)")

        // Add headers
        if let headers = endpoint.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
            print("📝 [Request] Headers: \(headers)")
        } else {
            print("📝 [Request] No headers provided")
        }

        // Add body for POST/PUT
        if let body = endpoint.body {
            request.httpBody = body
            if let bodyString = String(data: body, encoding: .utf8) {
                print("📦 [Request] Body: \(bodyString)")
            } else {
                print("📦 [Request] Body could not be converted to string")
            }
        } else {
            print("📦 [Request] No body provided")
        }

        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Debug: Check the response
            if let error = error {
                print("❌ [Response] Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🔄 [Response] Status Code: \(httpResponse.statusCode)")
            } else {
                print("🔄 [Response] No valid HTTPURLResponse")
            }

            guard let data = data else {
                print("❌ [Response] No data received")
                completion(.failure(NetworkError.noData))
                return
            }

            // Debug: Log the raw response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 [Response] Data: \(responseString)")
            } else {
                print("📥 [Response] Data could not be converted to string")
            }

            // Decode the data
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("✅ [Response] Decoded Data: \(decodedData)")
                completion(.success(decodedData))
            } catch {
                print("❌ [Response] Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
