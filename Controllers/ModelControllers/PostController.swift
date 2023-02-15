//
//  PostController.swift
//  Reddit
//
//  Created by Andrew Acton on 2/14/23.
//

import UIKit

//https://www.reddit.com/r/funny.json

class PostController {
    
    //String Constants
    static let baseURL = URL(string: "https://www.reddit.com")
    static let rComponent = "r"
    static let jsonExtension = "json"
    
    static func fetchPosts(searchTerm: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
        
        // URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        let rURL = baseURL.appendingPathComponent(rComponent)
        
        let searchURL = rURL.appendingPathComponent(searchTerm)
        
        let finalURL = searchURL.appendingPathExtension(jsonExtension)
        
        print(finalURL)
        
        //Data Task
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelObject = topLevelObject.data
                let thirdLevelObject = secondLevelObject.children
                
                var arrayOfPosts: [Post] = []
                
                for dict in thirdLevelObject {
                    let post = dict.data
                    arrayOfPosts.append(post)
                }
                
                return completion(.success(arrayOfPosts))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
        
    }
    
    static func fetchThumbnailFor(post: Post, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
        guard let thumbnailURL = URL(string: post.thumbnail) else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("THUMBNAIL STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(thumbnail))
            
        }.resume()
        
    }
    
    
} //End of Class
