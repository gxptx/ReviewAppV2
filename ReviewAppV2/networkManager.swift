import Foundation

class NetworkManager {
    private let apiKey = "AIzaSyBsdOCDcMIlBCNEzdvd2-rwNhn3WNn9oMM"
    private let baseURL = "https://maps.googleapis.com/maps/api/place"
    
    func fetchRandomPlace(completion: @escaping (Place?) -> Void) {
        // Define some popular place IDs or types
        let placeIDs = [
            // Add place IDs or place types here
            "ChIJE9on3F3HwoAR9AhGJW_fL-I" // Example: San Francisco
            // Add more place IDs
        ]
        
        guard let placeID = placeIDs.randomElement() else { return }
        
        let urlString = "\(baseURL)/details/json?placeid=\(placeID)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data")
                completion(nil)
                return
            }
            
            do {
                let placeResponse = try JSONDecoder().decode(GooglePlaceResponse.self, from: data)
                completion(placeResponse.result)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct GooglePlaceResponse: Decodable {
    let result: Place
}
