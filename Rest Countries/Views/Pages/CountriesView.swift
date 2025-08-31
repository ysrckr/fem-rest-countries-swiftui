//
//  ContentView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct CountriesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var countries: [Country] = []
    @State var searchText: String = ""
    @State var selectedRegion: String = "All"
    let columns = [GridItem(.flexible())]
    var filteredCountries: [Country] {
        guard !searchText.isEmpty || selectedRegion != "All" else { return countries }
        
        let filteredByRegion: [Country] = selectedRegion == "All" ? countries : countries.filter { $0.region.lowercased() == selectedRegion.lowercased() }
        
        
        guard !searchText.isEmpty else { return filteredByRegion }
        
        return filteredByRegion.filter {
            $0.name.common.lowercased().starts(with: searchText.lowercased())
        }
        
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack(spacing: 32) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(colorScheme == .dark ? .white : Color(.systemGray4))
                        TextField("Search", text: $searchText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(width: 200, height: 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .systemGray4))
                    }

                    Picker("Countries", selection: $selectedRegion) {
                        Text("All").tag("All")
                        Text("Europe").tag("Europe")
                        Text("Asia").tag("Asia")
                        Text("Africa").tag("Africa")
                        Text("Americas").tag("Americas")

                    }
                    .frame(width: 100, height: 32)
                    .tint(colorScheme == .dark ? .white : .black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .systemGray4))
                    }

                }
                .padding()
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(
                        filteredCountries.sorted { $0.name.common < $1.name.common },
                        id: \.cca2
                    ) { country in

                        NavigationLink(value: country.cca2) {
                            VStack(alignment: .center) {
                                AsyncImage(url: URL(string: country.flags.png))
                                { image in
                                    image
                                        .frame(width: 80, height: 80)
                                        .padding(.bottom, 32)

                                } placeholder: {
                                    ProgressView()
                                }.padding(.bottom, 32)
                                
                                Text(country.name.common)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                                    .padding()
                                VStack(spacing: 12) {
                                    Group {
                                        LabelValueTextView(
                                            label: "Population",
                                            value: String(country.population)
                                        )
                                        HStack {
                                            LabelValueTextView(
                                                label: "Region",
                                                value: country.region
                                            )
                                            LabelValueTextView(
                                                label: "Capital",
                                                value: country.capital.joined(
                                                    separator: ", "
                                                )
                                            )
                                        }
                                    }

                                }
                            }
                        }.frame(width: 280, height: 320)
                            .padding()
                            .background(colorScheme == .dark ? .black : .white)
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(Color(colorScheme == .dark ? .white : .systemGray4))
                            }


                    }
                }
                .padding(24)
                .navigationDestination(for: String.self) { code in
                    CountryView(code: code)
                }
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
            "name", "flags", "population", "cca2", "region", "capital", "borders"
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
            let countries: [Country] = try decoder.decode([Country].self, from: data)
            
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
    CountriesView()
}
