//
//  SpreadSheetManager.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import SwiftUI

struct SpreadSheetResponse: Codable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}

class SpreadSheetManager: ObservableObject {
    private let apiKey = "AIzaSyDRwAUZYsTHqbqtGs3d521raNWCojMPwYs"
    private let spreadsheetId = "1tG1QgEc_RM98SjRMYmduNsdOkcQ2HNHGMRKoFKApFvg"
    private let sheetName = "ESSheet"
    private let cellRange = "A2:O30000"
    @Published private(set) var spreadSheetResponse = SpreadSheetResponse(range: "", majorDimension: "", values: [[""]])

    @MainActor
    func fetchGoogleSheetData() async throws {
        let baseURL = "https://sheets.googleapis.com/v4/spreadsheets"
        let url = "\(baseURL)/\(spreadsheetId)/values/\(sheetName)!\(cellRange)?key=\(apiKey)"
        guard let requestURL = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: requestURL)
        let decoder = JSONDecoder()
        let spreadSheetResponse = try decoder.decode(SpreadSheetResponse.self, from: data)
        self.spreadSheetResponse = spreadSheetResponse
    }
}
