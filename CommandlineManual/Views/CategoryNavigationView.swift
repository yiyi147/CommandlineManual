import SwiftUI

struct CategoryNavigationView: View {
    @Binding var selectedCategory: CommandCategory?
    @Binding var selectedCommand: CommandItem?
    @Binding var expandedCategories: Set<UUID>
    @Binding var isVisible: Bool
    @FocusState private var isFocused: Bool
    @State private var hoveredCommandId: UUID? = nil
    @State private var selectedIndex: Int = 0

    private let columns = 5
    private let visibleRows = 9
    private let cellWidth: CGFloat = 88
    private let cellHeight: CGFloat = 36
    private let cellSpacing: CGFloat = 5

    private let allCommands: [(command: CommandItem, category: CommandCategory)]

    init(selectedCategory: Binding<CommandCategory?>, selectedCommand: Binding<CommandItem?>, expandedCategories: Binding<Set<UUID>>, isVisible: Binding<Bool>) {
        self._selectedCategory = selectedCategory
        self._selectedCommand = selectedCommand
        self._expandedCategories = expandedCategories
        self._isVisible = isVisible

        var items: [(CommandItem, CommandCategory)] = []
        for cat in CommandDatabase.categories {
            for cmd in cat.commands {
                items.append((cmd, cat))
            }
        }
        self.allCommands = items
    }

    private var selectedRow: Int { selectedIndex / columns }
    private var selectedCol: Int { selectedIndex % columns }
    private var totalCount: Int { allCommands.count }

    func wrappedIndex(_ raw: Int) -> Int {
        let total = totalCount
        guard total > 0 else { return 0 }
        var r = raw % total
        if r < 0 { r += total }
        return r
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            gridArea
        }
        .frame(width: 520, height: 420)
        .background(FocusDisabledContainer())
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.35), radius: 30, y: 10)
        .shadow(color: .black.opacity(0.15), radius: 60, y: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .focusable()
        .focusEffectDisabled(true)
        .focused($isFocused)
        .onKeyPress(.upArrow) {
            navigateUp()
            return .handled
        }
        .onKeyPress(.downArrow) {
            navigateDown()
            return .handled
        }
        .onKeyPress(.leftArrow) {
            navigateLeft()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigateRight()
            return .handled
        }
        .onKeyPress(.return) {
            jumpToSelected()
            return .handled
        }
        .onKeyPress(.escape) {
            isVisible = false
            return .handled
        }
        .task {
            if let cur = selectedCommand, let idx = allCommands.firstIndex(where: { $0.command.id == cur.id }) {
                selectedIndex = idx
            } else {
                selectedIndex = 0
            }
            isFocused = true
        }
        .onChange(of: isVisible) { _, visible in
            if visible {
                isFocused = true
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Image(systemName: "command")
                .foregroundStyle(.secondary)
            Text("所有命令")
                .font(.headline)
            Spacer()
            progressView
            Spacer()
            Text("\(allCommands.count) 个")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Button {
                isVisible = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private var progressView: some View {
        let total = allCommands.count
        let progress = total > 0 ? CGFloat(selectedIndex + 1) / CGFloat(total) : 0
        return HStack(spacing: 6) {
            Text("\(selectedIndex + 1)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .monospacedDigit()
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primary.opacity(0.08))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor)
                        .frame(width: geo.size.width * progress)
                        .animation(.easeOut(duration: 0.12), value: selectedIndex)
                }
            }
            .frame(width: 60, height: 4)
            Text("\(total)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.tertiary)
                .monospacedDigit()
        }
    }

    private var gridArea: some View {
        let halfRow = visibleRows / 2
        let halfCol = columns / 2

        return ScrollView([.horizontal, .vertical]) {
            VStack(spacing: cellSpacing) {
                ForEach(0..<visibleRows, id: \.self) { vRow in
                    HStack(spacing: cellSpacing) {
                        ForEach(0..<columns, id: \.self) { vCol in
                            let rawRow = selectedRow - halfRow + vRow
                            let rawCol = selectedCol - halfCol + vCol
                            let rawIndex = rawRow * columns + rawCol
                            let dataIndex = wrappedIndex(rawIndex)

                            commandCell(index: dataIndex)
                        }
                    }
                }
            }
            .padding(12)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(DisableVerticalScrollIndicator())
    }

    private func commandCell(index: Int) -> some View {
        let item = allCommands[index]
        let isSelected = selectedIndex == index
        let isHovered = hoveredCommandId == item.command.id
        let isCurrentCommand = selectedCommand?.id == item.command.id

        return Button {
            selectCommand(item.command, category: item.category)
        } label: {
            Text(item.command.name)
                .font(.system(size: 12, weight: isCurrentCommand ? .bold : (isSelected ? .semibold : .regular), design: .monospaced))
                .foregroundStyle(isCurrentCommand ? .white : (isSelected ? .primary : .secondary))
                .lineLimit(1)
                .frame(width: cellWidth, height: cellHeight)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isCurrentCommand ? Color.accentColor : (isSelected ? Color.accentColor.opacity(0.12) : (isHovered ? Color.primary.opacity(0.06) : Color.clear)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isCurrentCommand ? Color.accentColor : (isSelected ? Color.accentColor.opacity(0.25) : .clear), lineWidth: isSelected ? 1.5 : 1)
                )
                .shadow(color: isSelected ? Color.accentColor.opacity(0.15) : .clear, radius: 4, y: 1)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .id(index)
        .onHover { hovering in
            hoveredCommandId = hovering ? item.command.id : nil
        }
    }

    private func selectCommand(_ command: CommandItem, category: CommandCategory) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedCategory = category
            expandedCategories.insert(category.id)
            selectedCommand = command
            isVisible = false
        }
    }

    private func jumpToSelected() {
        guard selectedIndex < allCommands.count else { return }
        let item = allCommands[selectedIndex]
        selectCommand(item.command, category: item.category)
    }

    private func navigateUp() {
        let raw = selectedIndex - columns
        let newIndex = wrappedIndex(raw)
        withAnimation(.easeOut(duration: 0.12)) {
            selectedIndex = newIndex
        }
    }

    private func navigateDown() {
        let raw = selectedIndex + columns
        let newIndex = wrappedIndex(raw)
        withAnimation(.easeOut(duration: 0.12)) {
            selectedIndex = newIndex
        }
    }

    private func navigateLeft() {
        let raw = selectedIndex - 1
        let newIndex = wrappedIndex(raw)
        withAnimation(.easeOut(duration: 0.12)) {
            selectedIndex = newIndex
        }
    }

    private func navigateRight() {
        let raw = selectedIndex + 1
        let newIndex = wrappedIndex(raw)
        withAnimation(.easeOut(duration: 0.12)) {
            selectedIndex = newIndex
        }
    }
}

struct FocusDisabledContainer: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.focusRingType = .none
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct DisableVerticalScrollIndicator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let scrollView = view.superview?.enclosingScrollView {
                scrollView.verticalScroller?.isHidden = true
                scrollView.hasVerticalScroller = false
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
