//
//  CountryView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct CountryView: View {
    let code: String
    @State var country: Country? = nil
    var body: some View {
        VStack {
            
            if let country {
                VStack(spacing: 24) {
                    AsyncImage(url: URL(string: country.flags.png)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 80)
                            

                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack {
                        Text(country.name.common)
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            
                        LabelValueTextView(label: "Capital", value: "\(country.capital.joined(separator: ", "))")
                        Text("Population: \(country.population)")
                    }
                }
            }  else {
                ProgressView()
            }
        }.task {
            do {
                country = try await GetCountryByCode(code: code).first
            } catch {
                print(error)
            }
        }
    }

    
    enum HTTPError: Error {
        case invalidURL
        case clientError
        case serverError
    }
    
    func GetCountryByCode(code: String) async throws -> [Country] {
        let url = "https://restcountries.com/v3.1/alpha/\(code)"
        
        guard let url = URL(string: url) else { throw HTTPError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode
        else {
            throw HTTPError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            let countries: [Country] = try decoder.decode(
                [Country].self,
                from: data
            )
            
            return countries
            
        } catch HTTPError.clientError {
            print("Client Error")
        } catch {
            print("Other Error")
        }
        return []
    }
}


#Preview {
    CountryView(code: "TR")
}
