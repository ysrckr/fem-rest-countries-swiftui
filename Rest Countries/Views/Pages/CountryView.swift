//
//  CountryView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct CountryView: View {
    @Environment(\.colorScheme) var colorScheme
    let code: String
    @State var country: Country? = nil
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {

            if let country {
                VStack(alignment: .leading, spacing: 12) {
                    AsyncImage(url: URL(string: country.flags.png)) { image in
                        image
                            .resizable()
                            .frame(width: 320, height: 200)

                    } placeholder: {
                        ProgressView()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(country.name.common)
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)

                        LabelValueTextView(
                            label: "Population",
                            value: "\(country.population)"
                        )

                        LabelValueTextView(
                            label: "Capital",
                            value: "\(country.capital.joined(separator: ", "))"
                        )

                        LabelValueTextView(
                            label: "Region",
                            value: "\(country.region)"
                        )
                        .padding(.bottom, 16)

                        LabelValueTextView(
                            label: "Population",
                            value: "\(country.population)"
                        )

                        LabelValueTextView(
                            label: "Capital",
                            value: "\(country.capital.joined(separator: ", "))"
                        )

                        LabelValueTextView(
                            label: "Region",
                            value: "\(country.region)"
                        )
                        Text("Border Countries")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .padding(.vertical, 16)
                        LazyVGrid(columns: columns) {

                            ForEach(country.borders, id: \.self) { borderCode in
                                NavigationLink(value: borderCode) {
                                    Text("\(borderCode)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        .padding()

                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    style: StrokeStyle(
                                                        lineWidth: 1
                                                    )
                                                )
                                                .shadow(
                                                    color: .black.opacity(0.3),
                                                    radius: 5,
                                                    x: 5,
                                                    y: 5
                                                )
                                                .foregroundStyle(
                                                    Color(.systemGray4)
                                                )

                                        }

                                }
                            }

                        }.navigationDestination(for: String.self) {
                            borderCode in
                            CountryView(code: borderCode)
                        }
                    }
                    Spacer()
                }
            } else {
                ProgressView()
            }
        }
        .frame(width: .infinity)
        .padding()
        .task {
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
