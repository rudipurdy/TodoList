import Foundation



final class TodoService: TodoServiceProtocol {
    static let shared = TodoService()
    private init() {}
    
    private let urlSession = URLSession(configuration: .default)
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // Добавляем таймаут
    private let timeoutInterval: TimeInterval = 10
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeoutInterval
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            // Проверка ошибки сети
            if let error = error {
                let nsError = error as NSError
                if nsError.domain == NSURLErrorDomain {
                    switch nsError.code {
                    case NSURLErrorTimedOut:
                        completion(.failure(NetworkError.timeout))
                    case NSURLErrorNotConnectedToInternet:
                        completion(.failure(NetworkError.noInternet))
                    default:
                        completion(.failure(NetworkError.networkError(error)))
                    }
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            // Проверка HTTP статуса
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
                return
            }
            
            // Проверка данных
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Парсинг
            do {
                let response = try self?.jsonDecoder.decode(TodosResponse.self, from: data)
                if let todos = response?.todos {
                    completion(.success(todos))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
    }
}

// Расширяем enum ошибок
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case timeout
    case noInternet
    case serverError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid server response", comment: "")
        case .noData:
            return NSLocalizedString("No data received", comment: "")
        case .decodingError:
            return NSLocalizedString("Data parsing error", comment: "")
        case .timeout:
            return NSLocalizedString("Request timeout", comment: "")
        case .noInternet:
            return NSLocalizedString("No internet connection", comment: "")
        case .serverError(let code):
            return String(format: NSLocalizedString("Server error: %d", comment: ""), code)
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
