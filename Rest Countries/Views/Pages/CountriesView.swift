//
//  ContentView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct CountriesView: View {
    @State var countries: [Country] = []
    let columns = [GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(
                    countries.sorted { $0.name.common < $1.name.common },
                    id: \.cca2
                ) { country in

                    NavigationLink(value: country.cca2) {
                        VStack(alignment: .center) {
                            AsyncImage(url: URL(string: country.flags.png)!)
                                .frame(
                                    width: 280,
                                    height: 160,
                                    alignment: .center
                                )
                                .padding(24)
                            Text(country.name.common)
                                .font(.headline)
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                                .padding()
                            VStack(spacing: 12) {
                                Group {
                                    LabelValueTextView(label: "Population", value: String(country.population))
                                    HStack {
                                        LabelValueTextView(label: "Region", value: country.region)
                                        LabelValueTextView(label: "Capital", value: country.capital.joined(separator: ", "))
                                    }
                                }

                            }
                        }
                    }.frame(width: 280, height: 320)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)

                }
            }
            .padding(24)
            .navigationDestination(for: String.self) { code in
                CountryView(code: code)
            }
        }.navigationTitle(Text("Rest Countries"))
            .task {
                do {
                    countries = try await getCountries()
                } catch {
                    print("Error: \(error)")
                }
            }
    }

    enum HTTPError: Error {
        case invalidURL
        case clientError
        case serverError
    }

    func getCountries(
        fields: [String] = [
            "name", "flags", "population", "cca2", "region", "capital",
        ]
    ) async throws -> [Country] {
        let url =
            "https://restcountries.com/v3.1/all?fields=\(fields.joined(separator:","))"
        guard let url = URL(string: url) else { throw HTTPError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            throw HTTPError.serverError
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Country].self, from: data)

        } catch HTTPError.clientError {
            print("Client Error")
        } catch {
            print("Other Error")
        }
        return []
    }
}

#Preview {
    CountriesView()
}
