import SwiftUI

struct BillDetailView: View {
    let bill: Bill
    @State private var billDetails: BillDetails?
    @State private var summary: String? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var subjects: [String] = []
    @State private var isLoadingSubjects = false

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Loading bill details...")
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if let error = errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 200)
                        if let debug = BillDataManager.shared.errorMessage, !debug.isEmpty, debug != error {
                            Text("Debug: \(debug)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                } else if let details = billDetails {
                    VStack(alignment: .leading, spacing: 16) {
                        BillTitleSection(details: details, summary: summary)
                        BillMetaSection(details: details)
                        BillSponsorsSection(sponsors: details.sponsors)
                        SubjectsSection(subjects: subjects, isLoading: isLoadingSubjects, count: details.subjects?.count)
                        BillCommitteesSection(committees: nil) // Placeholder for now
                        BillActionsSection(actions: nil) // Placeholder for now
                        BillAmendmentsSection(amendments: nil) // Placeholder for now
                        BillTextVersionsSection(textVersions: nil) // Placeholder for now
                    }
                    .padding()
                }
            }
            .navigationTitle("Bill Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadDetails)
        }
    }

    private func loadDetails() {
        isLoading = true
        errorMessage = nil
        Task {
            let billType = bill.type.lowercased()
            let number = bill.number
            let congress = bill.congress
            async let details = BillDataManager.shared.getBillDetails(congress: congress, billType: billType, number: number)
            async let summaryText = BillDataManager.shared.getBillSummary(congress: congress, billType: billType, number: number)
            let (detailsResult, summaryResult) = await (details, summaryText)
            await MainActor.run {
                self.billDetails = detailsResult
                self.summary = summaryResult
                self.isLoading = false
                if detailsResult == nil {
                    self.errorMessage = "Failed to load bill details."
                } else if let subjectsUrl = detailsResult?.subjects?.url {
                    loadSubjects(from: subjectsUrl)
                }
            }
        }
    }

    private func loadSubjects(from url: String) {
        isLoadingSubjects = true
        Task {
            guard let url = URL(string: url) else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let apiKey = APIConfiguration.congressAPIKey
            if !apiKey.isEmpty {
                request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
            }
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let subjectObjs = json?["subjects"] as? [[String: Any]] {
                    let names = subjectObjs.compactMap { $0["name"] as? String }
                    await MainActor.run {
                        self.subjects = names
                        self.isLoadingSubjects = false
                    }
                }
            } catch {
                await MainActor.run { self.isLoadingSubjects = false }
            }
        }
    }
}

// MARK: - Subviews

struct BillTitleSection: View {
    let details: BillDetails
    let summary: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(details.title ?? "No title available")
                .font(.title2)
                .fontWeight(.bold)
            if let summary = summary, !summary.isEmpty {
                Text(summary)
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("No summary available.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BillMetaSection: View {
    let details: BillDetails
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Status: ")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Inferred from latest action")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            if let updateDate = details.updateDate {
                Text("Last updated: \(updateDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BillSponsorsSection: View {
    let sponsors: [Sponsor]?
    var body: some View {
        if let sponsors = sponsors, !sponsors.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sponsor(s):")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(sponsors, id: \.bioguideId) { sponsor in
                    Text(sponsor.fullName)
                        .font(.caption)
                }
            }
        }
    }
}

struct BillCommitteesSection: View {
    let committees: [Committee]?
    var body: some View {
        if let committees = committees, !committees.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Committees:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(committees, id: \.systemCode) { committee in
                    Text(committee.name)
                        .font(.caption)
                }
            }
        }
    }
}

struct BillActionsSection: View {
    let actions: [Action]?
    var body: some View {
        if let actions = actions, !actions.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Recent Actions:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(actions.prefix(5), id: \.actionDate) { action in
                    Text("\(action.actionDate): \(action.text)")
                        .font(.caption)
                }
            }
        }
    }
}

struct BillAmendmentsSection: View {
    let amendments: [Amendment]?
    var body: some View {
        if let amendments = amendments, !amendments.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Amendments:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(amendments.prefix(3), id: \.number) { amendment in
                    Text("Amendment \(amendment.number)")
                        .font(.caption)
                }
            }
        }
    }
}

struct BillTextVersionsSection: View {
    let textVersions: [TextVersion]?
    var body: some View {
        if let textVersions = textVersions, !textVersions.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Text Versions:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(textVersions.prefix(2), id: \.versionCode) { version in
                    if let url = URL(string: version.url) {
                        Link(version.versionCode, destination: url)
                            .font(.caption)
                    } else {
                        Text(version.versionCode)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct SubjectsSection: View {
    let subjects: [String]
    let isLoading: Bool
    let count: Int?
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Subjects:")
                .font(.subheadline)
                .fontWeight(.medium)
            if isLoading {
                ProgressView("Loading subjects...")
            } else if !subjects.isEmpty {
                ForEach(subjects, id: \.self) { subject in
                    Text(subject)
                        .font(.caption)
                }
            } else if let count = count, count > 0 {
                Text("(Unable to load subjects)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("No subjects available.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
} 