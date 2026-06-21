import SwiftUI

struct CommandDetailView: View {
    let command: CommandItem
    let commands: [CommandItem]
    let onNavigate: (CommandItem) -> Void
    @State private var copiedIndex: Int? = nil
    @State private var copiedSyntax = false
    @State private var copiedOptions = false
    @State private var scrollProxy: ScrollViewProxy?

    private var currentIndex: Int? {
        commands.firstIndex { $0.id == command.id }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    Divider()
                    syntaxSection
                    Divider()
                    descriptionSection
                    if let commonOptions = commonOptions {
                        Divider()
                        optionsSection(commonOptions)
                    }
                    Divider()
                    examplesSection
                    if let tips = command.tips {
                        Divider()
                        tipsSection(tips)
                    }
                }
                .padding(32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id(command.id)
            }
            .onChange(of: command.id) { _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("top", anchor: .top)
                }
            }
            .onAppear {
                scrollProxy = proxy
            }
        }
        .focusable()
        .focusEffectDisabled(true)
        .onKeyPress(.leftArrow) {
            navigateToPrevious()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigateToNext()
            return .handled
        }
        .overlay(alignment: .bottom) {
            if commands.count > 1 {
                keyboardHintBar
            }
        }
    }

    private var keyboardHintBar: some View {
        HStack(spacing: 16) {
            Spacer()
            if let index = currentIndex {
                Text("← 上一个")
                    .foregroundStyle(index > 0 ? .secondary : .quaternary)
                Text("\(index + 1) / \(commands.count)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text("下一个 →")
                    .foregroundStyle(index < commands.count - 1 ? .secondary : .quaternary)
            }
            Spacer()
        }
        .font(.caption)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private func navigateToPrevious() {
        guard let index = currentIndex, index > 0 else { return }
        onNavigate(commands[index - 1])
    }

    private func navigateToNext() {
        guard let index = currentIndex, index < commands.count - 1 else { return }
        onNavigate(commands[index + 1])
    }

    private var commonOptions: [(flag: String, description: String)]? {
        let opts: [(String, String)] = command.commonOptions
        return opts.isEmpty ? nil : opts
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(command.name)
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                    if let index = currentIndex, commands.count > 1 {
                        Text("\(index + 1)/\(commands.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.quaternary)
                            .clipShape(Capsule())
                    }
                }
                Text(command.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            HStack(spacing: 8) {
                if commands.count > 1 {
                    Button {
                        navigateToPrevious()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(currentIndex == nil || currentIndex == 0)
                    .help("上一个命令 (←)")

                    Button {
                        navigateToNext()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(currentIndex == nil || currentIndex == commands.count - 1)
                    .help("下一个命令 (→)")
                }
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(command.name, forType: .string)
                    withAnimation { copiedSyntax = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copiedSyntax = false }
                    }
                } label: {
                    Label(copiedSyntax ? "已复制!" : "复制命令", systemImage: copiedSyntax ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.borderedProminent)
                .tint(copiedSyntax ? .green : .blue)
            }
        }
        .id("top")
    }

    private var syntaxSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("语法")
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text("$ \(command.syntax)")
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.green)
                Spacer()
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(command.syntax, forType: .string)
                    withAnimation { copiedSyntax = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copiedSyntax = false }
                    }
                } label: {
                    Image(systemName: copiedSyntax ? "checkmark" : "doc.on.doc")
                        .foregroundStyle(copiedSyntax ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .help("复制语法")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("说明")
                .font(.headline)
            Text(command.description)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.quaternary.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func optionsSection(_ options: [(flag: String, description: String)]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("常用选项")
                    .font(.headline)
                Spacer()
                Button {
                    let text = options.map { "  \($0.flag)  \($0.description)" }.joined(separator: "\n")
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                    withAnimation { copiedOptions = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copiedOptions = false }
                    }
                } label: {
                    Label(copiedOptions ? "已复制" : "复制", systemImage: copiedOptions ? "checkmark" : "doc.on.doc")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, opt in
                    HStack(alignment: .top, spacing: 12) {
                        Text(opt.flag)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.yellow)
                            .frame(minWidth: 60, alignment: .leading)
                        Text(opt.description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    if index < options.count - 1 {
                        Divider()
                            .background(.white.opacity(0.06))
                            .padding(.horizontal, 14)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("示例")
                    .font(.headline)
                Text("\(command.examples.count) 个")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ForEach(Array(command.examples.enumerated()), id: \.element.id) { index, example in
                ExampleBlock(
                    example: example,
                    index: index,
                    isCopied: copiedIndex == index,
                    onCopy: {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(example.command, forType: .string)
                        withAnimation { copiedIndex = index }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation { copiedIndex = nil }
                        }
                    },
                    onRun: {
                        let escaped = example.command
                            .replacingOccurrences(of: "\\", with: "\\\\")
                            .replacingOccurrences(of: "\"", with: "\\\"")

                        let process = Process()
                        process.executableURL = URL(fileURLWithPath: "/Applications/Ghostty.app/Contents/MacOS/ghostty")
                        process.arguments = ["-e", "/bin/sh", "-c", example.command]
                        try? process.run()
                    }
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func tipsSection(_ tips: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("使用技巧")
                .font(.headline)
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                    .font(.title3)
                Text(tips)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(Color.yellow.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct ExampleBlock: View {
    let example: CommandExample
    let index: Int
    let isCopied: Bool
    let onCopy: () -> Void
    let onRun: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(.red.opacity(0.8)).frame(width: 10, height: 10)
                    Circle().fill(.yellow.opacity(0.8)).frame(width: 10, height: 10)
                    Circle().fill(.green.opacity(0.8)).frame(width: 10, height: 10)
                }
                Spacer()
                Text("示例 \(index + 1)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
                Spacer()
                HStack(spacing: 6) {
                    Button(action: onCopy) {
                        HStack(spacing: 4) {
                            Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                .font(.caption)
                            Text(isCopied ? "已复制" : "复制")
                                .font(.caption)
                        }
                        .foregroundStyle(isCopied ? .green : .white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(isCopied ? .green.opacity(0.2) : .white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)

                    Button(action: onRun) {
                        HStack(spacing: 4) {
                            Image(systemName: "play.fill")
                                .font(.caption)
                            Text("run")
                                .font(.caption)
                        }
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(white: 0.18))

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text("❯")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.green)
                    Text(example.command)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.green)
                        .textSelection(.enabled)
                }
                if !example.explanation.isEmpty {
                    HStack(alignment: .top, spacing: 8) {
                        Text("#")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.35))
                        Text(example.explanation)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color(white: 0.12))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}
