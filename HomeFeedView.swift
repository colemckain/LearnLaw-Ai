import SwiftUI

struct HomeFeedView: View {
    enum Tab { case bills, laws }
    @State private var selectedTab: Tab = .bills
    @State private var searchText: String = ""
    @State private var showFilter: Bool = false
    // Filter state
    @State private var selectedSession: String? = nil
    @State private var selectedHouse: String? = nil
    @State private var selectedStatus: String? = nil
    // Filter options
    private let sessionOptions = ["2023-2024", "2021-2022", "2019-2020"]
    private let houseOptions = ["Assembly", "Senate", "Both"]
    // Define fixed status categories and explanations for California
    private let statusCategories: [(key: String, label: String, explanation: String)] = [
        ("Introduced", "Introduced", "The bill has been introduced in the California Legislature."),
        ("In Committee", "In Committee", "The bill is being reviewed by a committee."),
        ("Passed Assembly", "Passed Assembly", "The bill has passed the California Assembly."),
        ("Passed Senate", "Passed Senate", "The bill has passed the California Senate."),
        ("Signed", "Signed", "The bill has been signed into law by the Governor."),
        ("Vetoed", "Vetoed", "The bill was vetoed by the Governor.")
    ]
    // Bills feed state
    @StateObject private var billDataManager = BillDataManager.shared
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var groupedBillsByStatus: [String: [CaliforniaBill]] {
        Dictionary(grouping: billDataManager.recentCaliforniaBills) { bill in
            bill.status
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search California bills...", text: $searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(18)
                    Button(action: { showFilter.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(ColorUtilities.patrioticBlue)
                            .padding(10)
                            .background(ColorUtilities.patrioticBlue.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 4)
                // REMOVE the Bills tab button here (delete the HStack with TabButton)
                Divider()
                // Add horizontal status filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: { selectedStatus = nil }) {
                            Text("All")
                                .fontWeight(selectedStatus == nil ? .bold : .regular)
                                .foregroundColor(selectedStatus == nil ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedStatus == nil ? Color.red : Color(.systemGray5))
                                .cornerRadius(16)
                        }
                        ForEach(statusCategories, id: \.key) { category in
                            Button(action: { selectedStatus = category.key }) {
                                Text(category.label)
                                    .fontWeight(selectedStatus == category.key ? .bold : .regular)
                                    .foregroundColor(selectedStatus == category.key ? .white : .primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedStatus == category.key ? Color.red : Color(.systemGray5))
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                // Show explanation for selected status
                if let selected = selectedStatus, let category = statusCategories.first(where: { $0.key == selected }) {
                    Text(category.explanation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                }
                // Only show bills feed for MVP, filtered by status
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if isLoading {
                            ProgressView("Loading California bills...")
                        } else if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                        } else if billDataManager.recentCaliforniaBills.isEmpty {
                            Text("No California bills found.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(filteredCaliforniaBills, id: \.id) { bill in
                                CaliforniaBillFeedCard(bill: bill)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGroupedBackground))
                .onAppear {
                    if billDataManager.recentCaliforniaBills.isEmpty {
                        isLoading = true
                        errorMessage = nil
                        Task {
                            await billDataManager.loadRecentCaliforniaBills()
                            isLoading = false
                            errorMessage = billDataManager.californiaBillErrorMessage
                        }
                    }
                }
            }
            .navigationTitle("California Bills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isLoading = true
                        errorMessage = nil
                        Task {
                            await billDataManager.loadRecentCaliforniaBills()
                            isLoading = false
                            errorMessage = billDataManager.californiaBillErrorMessage
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(ColorUtilities.patrioticBlue)
                    }
                }
            }
            .sheet(isPresented: $showFilter) {
                FilterSheet
            }
        }
    }

    // MARK: - Computed Properties
    
    var filteredCaliforniaBills: [CaliforniaBill] {
        var bills = billDataManager.recentCaliforniaBills
        
        // Filter by search text
        if !searchText.isEmpty {
            bills = bills.filter { bill in
                bill.title.localizedCaseInsensitiveContains(searchText) ||
                bill.billNumber.localizedCaseInsensitiveContains(searchText) ||
                bill.author.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by status
        if let selected = selectedStatus {
            bills = bills.filter { bill in
                bill.status.localizedCaseInsensitiveContains(selected)
            }
        }
        
        // Filter by house
        if let selected = selectedHouse {
            bills = bills.filter { bill in
                if selected == "Both" {
                    return true
                }
                return bill.house.localizedCaseInsensitiveContains(selected)
            }
        }
        
        return bills
    }
    
    // Filter Sheet
    @ViewBuilder
    private var FilterSheet: some View {
        NavigationView {
            Form {
                // California-specific filters
                Section(header: Text("Session")) {
                    Picker("Session", selection: $selectedSession) {
                        Text("All").tag(String?.none)
                        ForEach(sessionOptions, id: \.self) { session in
                            Text(session).tag(String?.some(session))
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section(header: Text("House")) {
                    Picker("House", selection: $selectedHouse) {
                        Text("All").tag(String?.none)
                        ForEach(houseOptions, id: \.self) { house in
                            Text(house).tag(String?.some(house))
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section(header: Text("Status")) {
                    Picker("Status", selection: $selectedStatus) {
                        Text("All").tag(String?.none)
                        ForEach(statusCategories, id: \.key) { category in
                            Text(category.label).tag(String?.some(category.key))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Filter California Bills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        resetFilters()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        showFilter = false
                    }
                }
            }
        }
    }

    private func resetFilters() {
        selectedSession = nil
        selectedHouse = nil
        selectedStatus = nil
    }


}

struct TabButton: View {
    let title: String
    let isActive: Bool
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(isActive ? .white : color)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isActive ? color : Color.clear)
                .cornerRadius(18)
        }
    }
}

struct BillPreview {
    let title: String
    let summary: String
    let status: String
    let date: String
    let congress: String
    let billType: String
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
} 