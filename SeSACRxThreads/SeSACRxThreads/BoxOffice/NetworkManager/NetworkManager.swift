//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/8/24.
//

import Foundation

import RxSwift

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknownError
}

final class NetworkManager {
    private let APIKey: String = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String ?? ""
    
    static let shared = NetworkManager()
    private init() { }
    
    func callMovie(dateString: String) -> Observable<Movie> {
        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey)&targetDt=\(dateString)"
        
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(NetworkError.unknownError)
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                if let data,
                   let result = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(result)
                    // ⭐️onCompleted()를 해주지 않으면 스트림이 지속되어 API 호출때마다 새로운 스트림을 생성하여 메모리 누수 발생.
                    // onCompleted를 부른다는 것 => Notification -> stream 끝내.
                    observer.onCompleted()
                } else {
                    observer.onError(NetworkError.invalidData)
                }
                
            }.resume()
            
            return Disposables.create()
        }
    }
}
