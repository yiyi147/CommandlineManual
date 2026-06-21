import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedCategory: CommandCategory? = nil
    @State private var selectedCommand: CommandItem? = nil
    @State private var expandedCategories: Set<UUID> = []
    @State private var searchHistory: [String] = []
    @State private var showHistory = false
    @State private var showCategoryNav = false
    @FocusState private var mainFocus: Bool

    private let historyKey = "searchHistory"
    private let maxHistory = 15

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
        _searchHistory = State(initialValue: saved)
    }

    var searchResults: [(category: String, command: CommandItem)] {
        guard !searchText.isEmpty else { return [] }
        return CommandDatabase.searchCommands(query: searchText)
    }

    var filteredHistory: [String] {
        guard !searchText.isEmpty else { return searchHistory }
        return searchHistory.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView
        }
        .navigationTitle("macOS 命令行大全")
        .searchable(text: $searchText, prompt: "搜索命令...")
        .onSubmit(of: .search) {
            navigateToBestMatch()
        }
        .overlay(alignment: .bottomTrailing) {
            categoryNavButton
                .padding(20)
        }
        .overlay {
            if showCategoryNav {
                Color.black.opacity(0.01)
                    .onTapGesture {
                        showCategoryNav = false
                    }
                CategoryNavigationView(
                    selectedCategory: $selectedCategory,
                    selectedCommand: $selectedCommand,
                    expandedCategories: $expandedCategories,
                    isVisible: $showCategoryNav
                )
                .transition(.scale(scale: 0.85, anchor: .bottomTrailing).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.25, bounce: 0.15), value: showCategoryNav)
        .onChange(of: showCategoryNav) { _, showing in
            if !showing {
                mainFocus = true
            }
        }
        .task {
            mainFocus = true
        }
    }

    private var categoryNavButton: some View {
        Button {
            showCategoryNav.toggle()
        } label: {
            Image(systemName: "square.grid.3x3")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.ultraThickMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .keyboardShortcut("z", modifiers: .command)
        .help("分类导航 ⌘Z")
    }

    private func addToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        searchHistory.removeAll { $0.lowercased() == trimmed.lowercased() }
        searchHistory.insert(trimmed, at: 0)
        if searchHistory.count > maxHistory {
            searchHistory = Array(searchHistory.prefix(maxHistory))
        }
        UserDefaults.standard.set(searchHistory, forKey: historyKey)
    }

    private func navigateToBestMatch() {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return }
        addToHistory(query)
        if let match = CommandDatabase.bestMatch(for: query) {
            let cat = CommandDatabase.categories.first { $0.name == match.category }
            selectedCategory = cat
            selectedCommand = match.command
            if let cat = cat {
                expandedCategories.insert(cat.id)
            }
            searchText = ""
        }
    }

    private var sidebar: some View {
        List(selection: $selectedCategory) {
            if !searchText.isEmpty {
                Section("搜索结果 (\(searchResults.count))") {
                    ForEach(searchResults, id: \.command.id) { result in
                        Button {
                            let cat = CommandDatabase.categories.first { $0.name == result.category }
                            selectedCategory = cat
                            selectedCommand = result.command
                            if let cat = cat {
                                expandedCategories.insert(cat.id)
                            }
                            addToHistory(searchText)
                            searchText = ""
                        } label: {
                            HStack {
                                Image(systemName: "terminal")
                                    .foregroundStyle(.green)
                                VStack(alignment: .leading) {
                                    Text(result.command.name)
                                        .font(.system(.body, design: .monospaced))
                                        .fontWeight(.semibold)
                                    Text(result.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else if !searchHistory.isEmpty && showHistory {
                Section("搜索历史") {
                    ForEach(searchHistory, id: \.self) { item in
                        Button {
                            searchText = item
                            showHistory = false
                        } label: {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundStyle(.secondary)
                                Text(item)
                                    .font(.body)
                                Spacer()
                                Button {
                                    searchHistory.removeAll { $0 == item }
                                    UserDefaults.standard.set(searchHistory, forKey: historyKey)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.quaternary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    Button {
                        searchHistory.removeAll()
                        UserDefaults.standard.removeObject(forKey: historyKey)
                        showHistory = false
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                            Text("清除所有历史")
                                .foregroundStyle(.red)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            ForEach(CommandDatabase.categories) { category in
                Section {
                    if expandedCategories.contains(category.id) {
                        ForEach(category.commands) { command in
                            Button {
                                selectedCategory = category
                                selectedCommand = command
                            } label: {
                                CommandRow(command: command)
                            }
                            .buttonStyle(.plain)
                            .tag(command)
                        }
                    }
                } header: {
                    CategoryHeader(
                        category: category,
                        isExpanded: expandedCategories.contains(category.id),
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                let wasExpanded = expandedCategories.contains(category.id)
                                if wasExpanded {
                                    expandedCategories.remove(category.id)
                                } else {
                                    expandedCategories.insert(category.id)
                                    if selectedCategory == nil || selectedCategory?.id != category.id {
                                        selectedCategory = category
                                        selectedCommand = nil
                                    }
                                }
                            }
                        }
                    )
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 220)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            showHistory = true
        }
    }

    private var detailView: some View {
        Group {
            if let command = selectedCommand, let category = selectedCategory {
                CommandDetailView(
                    command: command,
                    commands: category.commands,
                    onNavigate: { newCommand in
                        selectedCommand = newCommand
                    }
                )
            } else if let category = selectedCategory {
                CategoryOverviewView(category: category, selectedCommand: $selectedCommand)
            } else {
                WelcomeView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .focusable()
        .focusEffectDisabled(true)
        .focused($mainFocus)
        .onKeyPress(.upArrow) {
            navigateToPreviousCategory()
            return .handled
        }
        .onKeyPress(.downArrow) {
            navigateToNextCategory()
            return .handled
        }
        .onKeyPress(.leftArrow) {
            navigateToPreviousCommand()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigateToNextCommand()
            return .handled
        }
    }

    private func navigateToPreviousCommand() {
        guard let category = selectedCategory, let current = selectedCommand else { return }
        if let idx = category.commands.firstIndex(where: { $0.id == current.id }), idx > 0 {
            selectedCommand = category.commands[idx - 1]
        }
    }

    private func navigateToNextCommand() {
        guard let category = selectedCategory, let current = selectedCommand else { return }
        if let idx = category.commands.firstIndex(where: { $0.id == current.id }), idx < category.commands.count - 1 {
            selectedCommand = category.commands[idx + 1]
        }
    }

    private func navigateToPreviousCategory() {
        let categories = CommandDatabase.categories
        guard !categories.isEmpty else { return }
        if let current = selectedCategory, let index = categories.firstIndex(where: { $0.id == current.id }), index > 0 {
            let prevCategory = categories[index - 1]
            selectedCategory = prevCategory
            expandedCategories.insert(prevCategory.id)
            selectedCommand = prevCategory.commands.first
        } else if selectedCategory == nil, let first = categories.first {
            selectedCategory = first
            expandedCategories.insert(first.id)
            selectedCommand = first.commands.first
        }
    }

    private func navigateToNextCategory() {
        let categories = CommandDatabase.categories
        guard !categories.isEmpty else { return }
        if let current = selectedCategory, let index = categories.firstIndex(where: { $0.id == current.id }), index < categories.count - 1 {
            let nextCategory = categories[index + 1]
            selectedCategory = nextCategory
            expandedCategories.insert(nextCategory.id)
            selectedCommand = nextCategory.commands.first
        } else if selectedCategory == nil, let first = categories.first {
            selectedCategory = first
            expandedCategories.insert(first.id)
            selectedCommand = first.commands.first
        }
    }
}

struct CategoryHeader: View {
    let category: CommandCategory
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                Image(systemName: category.icon)
                    .foregroundStyle(.blue)
                    .frame(width: 20)
                Text(category.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text("\(category.commands.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 4)
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 12)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct CommandRow: View {
    let command: CommandItem

    var body: some View {
        HStack {
            Text(command.name)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
            Spacer()
            Text(command.syntax.components(separatedBy: " ").first ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "terminal")
                .font(.system(size: 64))
                .foregroundStyle(.blue)
            Text("macOS 命令行大全")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("从左侧目录选择一个命令类别开始探索")
                .font(.title3)
                .foregroundStyle(.secondary)
            HStack(spacing: 20) {
                FeatureBadge(icon: "magnifyingglass", title: "快速搜索", subtitle: "支持命令名、语法、描述")
                FeatureBadge(icon: "list.bullet", title: "分类浏览", subtitle: "24 大类命令")
                FeatureBadge(icon: "doc.on.doc", title: "一键复制", subtitle: "终端风格展示")
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

struct FeatureBadge: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 150)
        .padding()
        .background(.quaternary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CategoryOverviewView: View {
    let category: CommandCategory
    @Binding var selectedCommand: CommandItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: category.icon)
                        .font(.title)
                        .foregroundStyle(.blue)
                    Text(category.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(category.commands.count) 个命令")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 200, maximum: 300))
                ], spacing: 12) {
                    ForEach(category.commands) { command in
                        Button {
                            selectedCommand = command
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(command.name)
                                    .font(.system(.title3, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text(command.syntax)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                Spacer()
                                Text(command.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.quaternary.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
