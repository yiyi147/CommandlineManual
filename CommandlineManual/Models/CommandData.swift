import Foundation

struct CommandItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let syntax: String
    let description: String
    let examples: [CommandExample]
    let commonOptions: [(flag: String, description: String)]
    let tips: String?

    init(name: String, syntax: String, description: String, examples: [CommandExample], commonOptions: [(flag: String, description: String)] = [], tips: String? = nil) {
        self.name = name
        self.syntax = syntax
        self.description = description
        self.examples = examples
        self.commonOptions = commonOptions
        self.tips = tips
    }

    static func == (lhs: CommandItem, rhs: CommandItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CommandExample: Identifiable, Hashable {
    let id = UUID()
    let command: String
    let explanation: String

    static func == (lhs: CommandExample, rhs: CommandExample) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CommandCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let commands: [CommandItem]

    static func == (lhs: CommandCategory, rhs: CommandCategory) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CommandDatabase {
    static let categories: [CommandCategory] = [

// MARK: - 文件系统

        CommandCategory(
            name: "文件系统",
            icon: "folder",
            commands: [
                CommandItem(
                    name: "ls",
                    syntax: "ls [-ABCFGHILOPRRTW@abdegiklmnopqrstuvwx] [file ...]",
                    description: "列出目录内容。支持 BSD 和 POSIX 两种选项风格。",
                    examples: [
                        CommandExample(command: "ls", explanation: "列出当前目录内容"),
                        CommandExample(command: "ls -la", explanation: "列出所有文件（含隐藏），长格式"),
                        CommandExample(command: "ls -lh /var/log", explanation: "人类可读大小显示 /var/log"),
                        CommandExample(command: "ls -lt", explanation: "按修改时间排序，最新在前"),
                        CommandExample(command: "ls -R", explanation: "递归列出所有子目录"),
                        CommandExample(command: "ls -1", explanation: "每行只显示一个文件")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "长格式输出（权限/所有者/大小/日期）"),
                        (flag: "-a", description: "显示隐藏文件（以 . 开头）"),
                        (flag: "-A", description: "显示隐藏文件但不含 . 和 .."),
                        (flag: "-h", description: "人类可读的文件大小 (KB/MB/GB)"),
                        (flag: "-R", description: "递归列出子目录内容"),
                        (flag: "-t", description: "按修改时间排序（最新在前）"),
                        (flag: "-S", description: "按文件大小排序（最大在前）"),
                        (flag: "-r", description: "逆序排列"),
                        (flag: "-1", description: "每行只输出一个文件名"),
                        (flag: "-G", description: "输出着色（目录蓝/可执行绿等）"),
                        (flag: "-F", description: "在文件名后附加类型标记 (/=@|)"),
                        (flag: "-i", description: "显示 inode 编号"),
                        (flag: "-n", description: "以数字显示 UID/GID 而非名称"),
                        (flag: "-o", description: "长格式但不显示组信息"),
                        (flag: "-p", description: "目录名后附加 /"),
                        (flag: "-q", description: "将不可打印字符显示为 ?"),
                        (flag: "-s", description: "以块为单位显示文件大小"),
                        (flag: "-w", description: "指定输出宽度（列数）"),
                        (flag: "-x", description: "多列输出，按行排列"),
                        (flag: "-d", description: "将目录本身作为条目列出"),
                        (flag: "-e", description: "显示 ACL 权限信息"),
                        (flag: "-@", description: "显示扩展属性（如 quarantine）"),
                        (flag: "-T", description: "显示完整时间戳（含秒）"),
                        (flag: "-v", description: "自然版本排序 (file2 < file10)")
                    ],
                    tips: "最常用组合: -la（全部文件详情）, -lh（可读大小）, -lt（按时间排序）"
                ),
                CommandItem(
                    name: "cd",
                    syntax: "cd [-L|-P] [directory]",
                    description: "切换当前工作目录。不带参数时返回用户主目录。",
                    examples: [
                        CommandExample(command: "cd", explanation: "切换到用户主目录"),
                        CommandExample(command: "cd /tmp", explanation: "切换到 /tmp 目录"),
                        CommandExample(command: "cd ..", explanation: "返回上一级目录"),
                        CommandExample(command: "cd -", explanation: "切换到上一次所在的目录"),
                        CommandExample(command: "cd ~/Documents", explanation: "切换到主目录下的 Documents"),
                        CommandExample(command: "cd -P /tmp", explanation: "不跟随符号链接切换到 /tmp")
                    ],
                    commonOptions: [
                        (flag: "-L", description: "跟随符号链接（默认行为）"),
                        (flag: "-P", description: "不跟随符号链接，使用物理路径"),
                        (flag: "~", description: "代表用户主目录"),
                        (flag: "..", description: "代表上级目录"),
                        (flag: "-", description: "回到上一次所在的目录 ($OLDPWD)")
                    ],
                    tips: "~ 代表主目录，.. 代表上级目录，- 回到上次目录"
                ),
                CommandItem(
                    name: "cp",
                    syntax: "cp [-PRafinpv] source_file target_file\n     cp [-PRafinpv] source_file ... target_dir",
                    description: "复制文件或目录。复制目录时需要 -R 选项。",
                    examples: [
                        CommandExample(command: "cp file.txt backup.txt", explanation: "复制 file.txt 为 backup.txt"),
                        CommandExample(command: "cp -R dir1/ dir2/", explanation: "递归复制 dir1 目录到 dir2"),
                        CommandExample(command: "cp -i file.txt dest/", explanation: "复制时若目标已存在则提示确认"),
                        CommandExample(command: "cp -v *.jpg ~/Pictures/", explanation: "复制所有 jpg 并显示过程"),
                        CommandExample(command: "cp -p file.txt dest/", explanation: "复制并保留原始权限和时间戳"),
                        CommandExample(command: "cp -a dir1/ dir2/", explanation: "归档复制（保留所有属性+递归）")
                    ],
                    commonOptions: [
                        (flag: "-R", description: "递归复制整个目录"),
                        (flag: "-a", description: "归档模式（等同 -RpP）"),
                        (flag: "-i", description: "覆盖目标前确认（interactive）"),
                        (flag: "-f", description: "强制覆盖，不提示确认"),
                        (flag: "-n", description: "不覆盖已存在的目标文件"),
                        (flag: "-v", description: "显示复制过程详细信息"),
                        (flag: "-p", description: "保留权限、时间戳、扩展属性"),
                        (flag: "-P", description: "不跟随符号链接（复制链接本身）"),
                        (flag: "-H", description: "跟随命令行中的符号链接"),
                        (flag: "-L", description: "跟随所有符号链接"),
                        (flag: "-e", description: "创建文件系统备份（HFS+）")
                    ],
                    tips: "-R 递归目录，-a 归档（最安全），-i 覆盖前提示，-p 保留属性"
                ),
                CommandItem(
                    name: "mv",
                    syntax: "mv [-finv] source target\n     mv [-finv] source ... target_dir",
                    description: "移动或重命名文件/目录。",
                    examples: [
                        CommandExample(command: "mv old.txt new.txt", explanation: "重命名文件"),
                        CommandExample(command: "mv file.txt ~/Documents/", explanation: "移动文件到 Documents"),
                        CommandExample(command: "mv -i *.txt ~/backup/", explanation: "移动时冲突提示"),
                        CommandExample(command: "mv dir1/ dir2/", explanation: "移动目录（dir2 不存在则重命名）"),
                        CommandExample(command: "mv -n a.txt b.txt", explanation: "不覆盖已存在的目标文件")
                    ],
                    commonOptions: [
                        (flag: "-f", description: "强制覆盖，不提示确认"),
                        (flag: "-i", description: "覆盖前提示确认"),
                        (flag: "-n", description: "不覆盖已存在的目标文件"),
                        (flag: "-v", description: "显示移动过程详细信息")
                    ],
                    tips: "mv 既是移动也是重命名，-n 不覆盖最安全"
                ),
                CommandItem(
                    name: "rm",
                    syntax: "rm [-dFfRiPv] file ...",
                    description: "删除文件或目录。此操作不可逆，请谨慎使用。",
                    examples: [
                        CommandExample(command: "rm file.txt", explanation: "删除 file.txt"),
                        CommandExample(command: "rm -i file.txt", explanation: "删除前确认"),
                        CommandExample(command: "rm -rf directory/", explanation: "强制递归删除目录（⚠️ 极度危险）"),
                        CommandExample(command: "rm -I file1 file2 file3", explanation: "删除多个文件前只确认一次"),
                        CommandExample(command: "rm -d empty_dir", explanation: "删除空目录")
                    ],
                    commonOptions: [
                        (flag: "-r", description: "递归删除目录及其内容"),
                        (flag: "-R", description: "同 -r，递归删除"),
                        (flag: "-f", description: "强制删除，不提示确认（忽略 -i）"),
                        (flag: "-i", description: "每次删除前都确认"),
                        (flag: "-I", description: "删除超过3文件或递归删除前确认一次"),
                        (flag: "-d", description: "删除空目录（等同 rmdir）"),
                        (flag: "-v", description: "显示删除的每个文件名")
                    ],
                    tips: "⚠️ rm 不可逆！-rf 组合极度危险，建议先 ls 确认"
                ),
                CommandItem(
                    name: "mkdir",
                    syntax: "mkdir [-pv] [-m mode] directory ...",
                    description: "创建新目录。",
                    examples: [
                        CommandExample(command: "mkdir newdir", explanation: "创建 newdir 目录"),
                        CommandExample(command: "mkdir -p a/b/c", explanation: "递归创建嵌套目录"),
                        CommandExample(command: "mkdir -m 755 newdir", explanation: "创建目录并设置权限为 755"),
                        CommandExample(command: "mkdir -pv project/{src,lib,bin}", explanation: "一次创建多个目录")
                    ],
                    commonOptions: [
                        (flag: "-p", description: "递归创建不存在的父目录"),
                        (flag: "-m", description: "设置新目录的权限模式 (如 755)"),
                        (flag: "-v", description: "为每个创建的目录显示信息")
                    ],
                    tips: "-p 递归创建父目录，-m 设置权限，-v 显示过程"
                ),
                CommandItem(
                    name: "rmdir",
                    syntax: "rmdir [-pv] directory ...",
                    description: "删除空目录。",
                    examples: [
                        CommandExample(command: "rmdir emptydir", explanation: "删除空目录 emptydir"),
                        CommandExample(command: "rmdir -p a/b/c", explanation: "递归删除空的嵌套目录 a/b/c")
                    ],
                    commonOptions: [
                        (flag: "-p", description: "递归删除空的父目录"),
                        (flag: "-v", description: "显示删除过程详细信息")
                    ],
                    tips: "只能删除空目录，非空目录请用 rm -rf"
                ),
                CommandItem(
                    name: "touch",
                    syntax: "touch [-A [[CC]YY]MMDDhhmm[.ss]] [-a] [-cfh] [-m] [-r file] [-t [[CC]YY]MMDDhhmm[.ss]] file ...",
                    description: "创建空文件或更新文件时间戳。",
                    examples: [
                        CommandExample(command: "touch newfile.txt", explanation: "创建空文件"),
                        CommandExample(command: "touch -t 202401011200 file.txt", explanation: "设置文件时间为指定时间"),
                        CommandExample(command: "touch file1.txt file2.txt", explanation: "同时创建多个文件"),
                        CommandExample(command: "touch -r ref.txt target.txt", explanation: "复制 ref.txt 的时间戳到 target"),
                        CommandExample(command: "touch -a file.txt", explanation: "只更新访问时间")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "只修改访问时间 (access time)"),
                        (flag: "-m", description: "只修改修改时间 (modification time)"),
                        (flag: "-c", description: "文件不存在时不创建"),
                        (flag: "-f", description: "忽略（兼容 POSIX）"),
                        (flag: "-h", description: "修改符号链接本身的时间（非目标）"),
                        (flag: "-r", description: "使用指定文件的时间戳"),
                        (flag: "-t", description: "设置指定时间 [[CC]YY]MMDDhhmm[.ss]")
                    ],
                    tips: "文件不存在时创建，存在时更新时间戳"
                ),
                CommandItem(
                    name: "find",
                    syntax: "find [-H | -L | -P] [-EXdsx] path ... [expression]",
                    description: "在目录树中搜索文件，功能非常强大。支持 POSIX 和 BSD 两种表达式语法。",
                    examples: [
                        CommandExample(command: "find . -name '*.txt'", explanation: "查找所有 .txt 文件"),
                        CommandExample(command: "find / -type f -size +100M", explanation: "查找大于 100MB 的文件"),
                        CommandExample(command: "find . -mtime -7", explanation: "查找 7 天内修改过的文件"),
                        CommandExample(command: "find . -name '*.log' -exec rm {} \\;", explanation: "找到并删除所有 log 文件"),
                        CommandExample(command: "find . -empty -type f", explanation: "查找所有空文件"),
                        CommandExample(command: "find . -perm 755", explanation: "查找权限为 755 的文件"),
                        CommandExample(command: "find . -maxdepth 1 -type d", explanation: "只列出当前目录下的子目录")
                    ],
                    commonOptions: [
                        (flag: "-name pattern", description: "按文件名匹配（支持 * ? [] 通配符）"),
                        (flag: "-iname pattern", description: "按文件名匹配（忽略大小写）"),
                        (flag: "-type f|d|l|b|c|p|s", description: "按类型筛选（f=文件 d=目录 l=链接）"),
                        (flag: "-size ±Nc|k|M|G", description: "按大小筛选（+大于 -小于）"),
                        (flag: "-mtime ±N", description: "按修改天数（-N=N天内 +N=N天前）"),
                        (flag: "-atime ±N", description: "按访问天数筛选"),
                        (flag: "-ctime ±N", description: "按 inode 变更天数筛选"),
                        (flag: "-newer file", description: "比指定文件更新的文件"),
                        (flag: "-empty", description: "查找空文件和空目录"),
                        (flag: "-perm mode", description: "按权限精确匹配"),
                        (flag: "-maxdepth N", description: "限制搜索深度"),
                        (flag: "-mindepth N", description: "限制最小搜索深度"),
                        (flag: "-exec cmd {} \\;", description: "对每个结果执行命令（{} 代替文件名）"),
                        (flag: "-exec cmd {} +", description: "批量执行命令（类似 xargs）"),
                        (flag: "-print", description: "输出结果（默认行为）"),
                        (flag: "-print0", description: "以 null 字符分隔输出（配合 xargs -0）"),
                        (flag: "-delete", description: "删除匹配的文件"),
                        (flag: "-ls", description: "以 ls -dils 格式输出"),
                        (flag: "-user name", description: "按文件所有者筛选"),
                        (flag: "-group name", description: "按文件所属组筛选"),
                        (flag: "-inum N", description: "按 inode 编号筛选"),
                        (flag: "-links N", description: "按硬链接数筛选")
                    ],
                    tips: "最强大的文件搜索工具，-name/-type/-size/-mtime 是最常用的筛选条件"
                ),
                CommandItem(
                    name: "chmod",
                    syntax: "chmod [-fhv] [-R [-H | -L | -P]] mode file ...",
                    description: "更改文件或目录的访问权限。支持符号模式和绝对模式。",
                    examples: [
                        CommandExample(command: "chmod 755 script.sh", explanation: "设置权限为 rwxr-xr-x"),
                        CommandExample(command: "chmod +x script.sh", explanation: "添加执行权限"),
                        CommandExample(command: "chmod -R 644 dir/", explanation: "递归设置所有文件为 644"),
                        CommandExample(command: "chmod u+w file.txt", explanation: "给所有者添加写权限"),
                        CommandExample(command: "chmod go-rwx secret.key", explanation: "移除组和其他用户所有权限"),
                        CommandExample(command: "chmod a+r file.txt", explanation: "给所有用户添加读权限")
                    ],
                    commonOptions: [
                        (flag: "mode: [ugoa][+-=][rwxst]", description: "符号模式: u=所有者 g=组 o=其他 a=全部"),
                        (flag: "mode: NNN (八进制)", description: "绝对模式: 7=rwx 6=rw- 5=r-x 4=r-- 0=---"),
                        (flag: "特殊位: 4(suid) 2(sgid) 1(sticky)", description: "SUID=4000 SGID=2000 Sticky=1000"),
                        (flag: "-R", description: "递归更改目录下所有内容"),
                        (flag: "-f", description: "强制执行，不显示错误"),
                        (flag: "-h", description: "修改符号链接本身（非目标）"),
                        (flag: "-v", description: "显示每次更改的详细信息")
                    ],
                    tips: "符号模式: u/g/o/a + 增加/- 减少/= 设置 rwx, 数字模式: 4=读 2=写 1=执行"
                ),
                CommandItem(
                    name: "chown",
                    syntax: "chown [-fhv] [-R [-H | -L | -P]] owner[:group] file ...",
                    description: "更改文件所有者和所属组。",
                    examples: [
                        CommandExample(command: "sudo chown john file.txt", explanation: "将所有者改为 john"),
                        CommandExample(command: "sudo chown -R john:staff dir/", explanation: "递归更改所有者和组"),
                        CommandExample(command: "sudo chown :admin file.txt", explanation: "只更改所属组"),
                        CommandExample(command: "sudo chown -h link", explanation: "修改符号链接本身的所有权")
                    ],
                    commonOptions: [
                        (flag: "-R", description: "递归更改目录及内容的所有权"),
                        (flag: "-L", description: "跟随符号链接进行操作"),
                        (flag: "-P", description: "不跟随符号链接（默认）"),
                        (flag: "-H", description: "跟随命令行中指定的符号链接"),
                        (flag: "-f", description: "强制执行，不显示错误"),
                        (flag: "-h", description: "修改符号链接本身（非目标文件）"),
                        (flag: "-v", description: "显示每次更改的详细信息")
                    ],
                    tips: "通常需要 sudo 权限，-R 递归操作，-h 避免跟踪链接"
                ),
                CommandItem(
                    name: "ln",
                    syntax: "ln [-fhins] source_file [target_file]\n     ln [-fhins] source_file ... target_dir\n     ln -s [-fhin] source_file [target_file]",
                    description: "创建文件链接。硬链接或符号链接（软链接）。",
                    examples: [
                        CommandExample(command: "ln original.txt link.txt", explanation: "创建硬链接"),
                        CommandExample(command: "ln -s /usr/local/bin/python3 /usr/bin/python", explanation: "创建符号链接"),
                        CommandExample(command: "ln -sf new_target existing_link", explanation: "强制更新符号链接指向"),
                        CommandExample(command: "ln -s $(which python3) ~/bin/python", explanation: "为命令创建便捷链接")
                    ],
                    commonOptions: [
                        (flag: "-s", description: "创建符号链接（类似快捷方式）"),
                        (flag: "-f", description: "强制创建，覆盖已存在的目标"),
                        (flag: "-i", description: "目标已存在时提示确认"),
                        (flag: "-n", description: "将符号链接视为普通文件（不跟随）"),
                        (flag: "-h", description: "如果目标是符号链接则不跟随"),
                        (flag: "-v", description: "显示创建的链接信息")
                    ],
                    tips: "-s 符号链接（跨文件系统），无-s 硬链接（同一文件系统）"
                ),
                CommandItem(
                    name: "stat",
                    syntax: "stat [-fLnrtx] [-s format] [-t timefmt] [file ...]\n     stat [-fLnrtx] -c format file ...",
                    description: "显示文件的详细状态信息（大小、权限、时间、inode 等）。",
                    examples: [
                        CommandExample(command: "stat file.txt", explanation: "显示文件详细信息"),
                        CommandExample(command: "stat -f %z file.txt", explanation: "只显示文件大小（字节）"),
                        CommandExample(command: "stat -t file.txt", explanation: "以简洁格式显示"),
                        CommandExample(command: "stat -x file.txt", explanation: "以 macOS 原生格式显示"),
                        CommandExample(command: "stat -f '%Sp %Su %N' file.txt", explanation: "自定义格式：权限 所有者 文件名")
                    ],
                    commonOptions: [
                        (flag: "-f", description: "显示文件系统状态（而非文件状态）"),
                        (flag: "-L", description: "跟随符号链接显示目标信息"),
                        (flag: "-t", description: "以简洁单行格式输出"),
                        (flag: "-x", description: "以 macOS/statted 风格详细输出"),
                        (flag: "-r", description: "以 raw 格式输出（适合脚本）"),
                        (flag: "-s format", description: "自定义输出格式"),
                        (flag: "-c format", description: "POSIX 自定义格式")
                    ],
                    tips: "%z=大小 %Sp=权限 %Su=所有者 %Sm=修改时间 %N=文件名"
                ),
                CommandItem(
                    name: "df",
                    syntax: "df [-abgHhiklmPpqTt] [-B size] [-c] [-e] [-I] [-o options] [source ...]",
                    description: "显示磁盘空间使用情况。",
                    examples: [
                        CommandExample(command: "df -h", explanation: "人类可读格式显示所有挂载点"),
                        CommandExample(command: "df -h /", explanation: "显示根分区使用情况"),
                        CommandExample(command: "df -T", explanation: "显示文件系统类型"),
                        CommandExample(command: "df -i /", explanation: "显示 inode 使用情况")
                    ],
                    commonOptions: [
                        (flag: "-h", description: "人类可读格式 (KB/MB/GB)"),
                        (flag: "-H", description: "SI 单位 (1000进制而非1024)"),
                        (flag: "-T", description: "显示文件系统类型 (APFS/HFS+)"),
                        (flag: "-k", description: "以 1KB 块显示"),
                        (flag: "-P", description: "POSIX 格式（不截断列）"),
                        (flag: "-i", description: "显示 inode 使用情况"),
                        (flag: "-g", description: "以 512 字节块显示"),
                        (flag: "-B size", description: "指定块大小"),
                        (flag: "-t type", description: "只显示指定类型的文件系统")
                    ],
                    tips: "-h 人类可读，-T 显示类型，-i 查看 inode 剩余"
                ),
                CommandItem(
                    name: "du",
                    syntax: "du [-FHLSabcghklmsx] [-d depth] [-B blocksize] [file ...]",
                    description: "估算文件和目录的磁盘使用空间。",
                    examples: [
                        CommandExample(command: "du -sh *", explanation: "显示每个文件/目录的总大小"),
                        CommandExample(command: "du -h --max-depth=1", explanation: "只显示一级子项大小"),
                        CommandExample(command: "du -sh ~/Library/Caches", explanation: "查看缓存目录总大小"),
                        CommandExample(command: "du -sh . --exclude='.git'", explanation: "排除 .git 目录统计")
                    ],
                    commonOptions: [
                        (flag: "-s", description: "只显示总计（每个参数的总和）"),
                        (flag: "-h", description: "人类可读格式"),
                        (flag: "-H", description: "SI 单位 (1000进制)"),
                        (flag: "-a", description: "显示所有文件（不仅目录）"),
                        (flag: "-c", description: "最后显示总计行"),
                        (flag: "-d depth", description: "限制递归深度"),
                        (flag: "-L", description: "跟随符号链接"),
                        (flag: "-S", description: "单独统计每个文件（不含共享块）"),
                        (flag: "-x", description: "只统计同一文件系统的文件"),
                        (flag: "-g", description: "以 1024 块显示"),
                        (flag: "-B blocksize", description: "指定块大小 (K/M/G)")
                    ],
                    tips: "-sh 最常用（总计+可读），-h --max-depth=1 查看一级分布"
                ),
                CommandItem(
                    name: "realpath",
                    syntax: "realpath [-mqx] file ...",
                    description: "解析文件的绝对路径（解析符号链接、. 和 ..）。",
                    examples: [
                        CommandExample(command: "realpath ../file.txt", explanation: "输出绝对路径"),
                        CommandExample(command: "realpath -m symlink", explanation: "不检查文件是否存在，解析路径"),
                        CommandExample(command: "realpath -q file.txt", explanation: "静默模式（文件不存在时不报错）")
                    ],
                    commonOptions: [
                        (flag: "-m", description: "不检查文件是否存在（仅路径解析）"),
                        (flag: "-q", description: "静默模式，不报告错误"),
                        (flag: "-s", description: "保持多余斜杠（兼容模式）"),
                        (flag: "-x", description: "限制在同一文件系统内")
                    ],
                    tips: "常用于脚本中获取文件的绝对路径"
                ),
                CommandItem(
                    name: "basename",
                    syntax: "basename [-a] [-s suffix] string ...\n     basename [-a] [-s suffix] string ... suffix",
                    description: "从路径中提取文件名。",
                    examples: [
                        CommandExample(command: "basename /usr/local/bin/python3", explanation: "输出: python3"),
                        CommandExample(command: "basename /etc/hosts .conf", explanation: "输出: hosts（去除 .conf 后缀）"),
                        CommandExample(command: "basename -s .txt file1.txt file2.txt", explanation: "去除 .txt 后缀后输出文件名")
                    ],
                    commonOptions: [
                        (flag: "-s suffix", description: "去除指定后缀"),
                        (flag: "-a", description: "将每个参数视为单独的字符串")
                    ],
                    tips: "常用于 shell 脚本中提取文件名部分"
                ),
                CommandItem(
                    name: "dirname",
                    syntax: "dirname [-h] string ...",
                    description: "从路径中提取目录部分。",
                    examples: [
                        CommandExample(command: "dirname /usr/local/bin/python3", explanation: "输出: /usr/local/bin"),
                        CommandExample(command: "dirname /etc/hosts", explanation: "输出: /etc"),
                        CommandExample(command: "dirname -h symlink", explanation: "跟随符号链接解析目录")
                    ],
                    commonOptions: [
                        (flag: "-h", description: "跟随符号链接（同 -L）"),
                        (flag: "-z", description: "以 null 字符分隔输出")
                    ],
                    tips: "与 basename 配对使用，提取路径的不同部分"
                ),
                CommandItem(
                    name: "diff",
                    syntax: "diff [-aBbdiNpTt] [-I pattern] [--color=when] file1 file2\n     diff [-aBbdiNpTt] [-I pattern] dir1 dir2",
                    description: "逐行比较文件或目录内容。",
                    examples: [
                        CommandExample(command: "diff file1.txt file2.txt", explanation: "比较两个文件的差异"),
                        CommandExample(command: "diff -u old.py new.py", explanation: "以 unified 格式显示差异"),
                        CommandExample(command: "diff -rq dir1/ dir2/", explanation: "递归比较两个目录，只报告不同"),
                        CommandExample(command: "diff -y file1 file2", explanation: "并排显示差异"),
                        CommandExample(command: "diff --color=always f1 f2", explanation: "彩色输出差异")
                    ],
                    commonOptions: [
                        (flag: "-u", description: "Unified 格式（最常用，适合 patch）"),
                        (flag: "-y", description: "并排（side-by-side）比较"),
                        (flag: "-q", description: "只报告文件是否不同"),
                        (flag: "-r", description: "递归比较目录"),
                        (flag: "-i", description: "忽略大小写差异"),
                        (flag: "-b", description: "忽略空白数量变化"),
                        (flag: "-w", description: "忽略所有空白差异"),
                        (flag: "-B", description: "忽略空行差异"),
                        (flag: "-N", description: "将不存在的文件视为空文件"),
                        (flag: "-a", description: "将所有文件视为文本"),
                        (flag: "-T", description: "用 Tab 分隔对齐"),
                        (flag: "--color", description: "彩色输出（when=always/auto/never）")
                    ],
                    tips: "-u 最常用（产生 unified diff，可配合 patch），脚本中用 -q 快速判断"
                ),
                CommandItem(
                    name: "file",
                    syntax: "file [-bcdEhiklLnpPrsSvz] [--separator separator] [--mime-type | --mime-encoding] [-m magicfile] [-M magicfile] file ...",
                    description: "检测文件类型（通过魔数/magic number 判断）。",
                    examples: [
                        CommandExample(command: "file photo.jpg", explanation: "检测文件类型和格式信息"),
                        CommandExample(command: "file -b document.pdf", explanation: "只输出类型，不显示文件名"),
                        CommandExample(command: "file -i *", explanation: "显示 MIME 类型"),
                        CommandExample(command: "file -I archive.zip", explanation: "显示 MIME 类型和编码")
                    ],
                    commonOptions: [
                        (flag: "-b", description: "只输出文件类型，不显示文件名"),
                        (flag: "-i", description: "输出 MIME 类型 (application/pdf 等)"),
                        (flag: "-I", description: "输出 MIME 类型和编码"),
                        (flag: "-k", description: "显示所有匹配的规则"),
                        (flag: "-z", description: "尝试解析压缩文件内部类型"),
                        (flag: "-h", description: "不跟随符号链接"),
                        (flag: "-s", description: "读取块设备/字符设备文件"),
                        (flag: "-r", description: "不输出多余信息"),
                        (flag: "-p", description: "只输出 MIME 类型（机器可读）")
                    ],
                    tips: "可判断图片格式、压缩类型、编码格式等，-i 看 MIME 类型最常用"
                ),
                CommandItem(
                    name: "md5 / shasum",
                    syntax: "md5 [-pqrtx] [-c string] [-s string] [file ...]\n     shasum [-a algorithm] [-bcrtpx] [file ...]",
                    description: "计算文件的哈希校验值，用于验证文件完整性。",
                    examples: [
                        CommandExample(command: "md5 file.zip", explanation: "计算文件 MD5 值"),
                        CommandExample(command: "shasum -a 256 file.zip", explanation: "计算 SHA-256 哈希值"),
                        CommandExample(command: "shasum -c checksums.txt", explanation: "校验文件完整性"),
                        CommandExample(command: "md5 -r *.txt", explanation: "只输出哈希值和文件名（适合脚本）")
                    ],
                    commonOptions: [
                        (flag: "-r", description: "只输出哈希值（不显示格式名）"),
                        (flag: "-c file", description: "校验文件中的哈希值"),
                        (flag: "-a algorithm", description: "shasum: 指定算法 (1/224/256/384/512)")
                    ],
                    tips: "macOS 内置 md5 和 shasum，无需安装额外工具"
                ),
                CommandItem(
                    name: "tree",
                    syntax: "tree [-acdfghilnpqrtuvACDFNS] [-L level] [-I pattern] [--dirsfirst] [--charset charset] [directory ...]",
                    description: "以树状结构显示目录内容。需通过 brew install tree 安装。",
                    examples: [
                        CommandExample(command: "tree", explanation: "以树状显示当前目录"),
                        CommandExample(command: "tree -L 2", explanation: "只显示 2 层深度"),
                        CommandExample(command: "tree -a", explanation: "显示隐藏文件"),
                        CommandExample(command: "tree -d", explanation: "只显示目录"),
                        CommandExample(command: "tree -I 'node_modules|.git'", explanation: "排除指定目录"),
                        CommandExample(command: "tree -L 1 --dirsfirst", explanation: "目录排在前面显示"),
                        CommandExample(command: "tree -h", explanation: "显示文件大小"),
                        CommandExample(command: "tree -f", explanation: "显示完整路径前缀"),
                        CommandExample(command: "tree -i", explanation: "不显示缩进线（适合管道）"),
                        CommandExample(command: "tree -s", explanation: "显示文件大小"),
                        CommandExample(command: "tree -p", explanation: "显示权限"),
                        CommandExample(command: "tree -u", explanation: "显示所有者"),
                        CommandExample(command: "tree -g", explanation: "显示组"),
                        CommandExample(command: "tree -D", explanation: "显示修改时间"),
                        CommandExample(command: "tree --charset ascii", explanation: "使用 ASCII 字符绘制"),
                        CommandExample(command: "tree -o output.txt", explanation: "输出到文件"),
                        CommandExample(command: "tree -L 2 -d", explanation: "只显示 2 层目录结构"),
                        CommandExample(command: "tree -P '*.swift'", explanation: "只显示 .swift 文件"),
                        CommandExample(command: "tree -I 'build|Pods' --dirsfirst", explanation: "排除构建目录，目录优先")
                    ],
                    commonOptions: [
                        (flag: "-L level", description: "限制显示深度"),
                        (flag: "-a", description: "显示所有文件（含隐藏）"),
                        (flag: "-d", description: "只显示目录"),
                        (flag: "-f", description: "显示完整路径前缀"),
                        (flag: "-s", description: "显示文件大小"),
                        (flag: "-h", description: "人类可读大小 (KB/MB/GB)"),
                        (flag: "-p", description: "显示权限"),
                        (flag: "-u", description: "显示所有者"),
                        (flag: "-g", description: "显示组"),
                        (flag: "-D", description: "显示修改时间"),
                        (flag: "-i", description: "不显示缩进线"),
                        (flag: "-I pattern", description: "排除匹配的文件/目录"),
                        (flag: "-P pattern", description: "只显示匹配的文件/目录"),
                        (flag: "--dirsfirst", description: "目录排在文件前面"),
                        (flag: "-A", description: "使用 ASCII 字符绘制树"),
                        (flag: "-C", description: "使用颜色输出"),
                        (flag: "-N", description: "不显示字符转义"),
                        (flag: "-S", description: "显示 CPU 字符集"),
                        (flag: "-r", description: "随机排序"),
                        (flag: "-t", description: "按修改时间排序"),
                        (flag: "-v", description: "按版本排序"),
                        (flag: "-n", description: "不排序"),
                        (flag: "-x", description: "只在当前文件系统"),
                        (flag: "-o file", description: "输出到文件"),
                        (flag: "--charset charset", description: "指定字符集"),
                        (flag: "--filelimit N", description: "忽略超过 N 个文件的目录"),
                        (flag: "-F", description: "附加类型标记 (/=@|)"),
                        (flag: "--prune", description: "空目录不显示")
                    ],
                    tips: "brew install tree，-L 深度 -I 排除 -P 包含 --dirsfirst 目录优先"
                )
            ]
        ),

// MARK: - 文本处理

        CommandCategory(
            name: "文本处理",
            icon: "doc.text",
            commands: [
                CommandItem(
                    name: "cat",
                    syntax: "cat [-belnstuv] [file ...]",
                    description: "连接并显示文件内容。",
                    examples: [
                        CommandExample(command: "cat file.txt", explanation: "显示文件全部内容"),
                        CommandExample(command: "cat -n file.txt", explanation: "显示内容并带行号"),
                        CommandExample(command: "cat file1.txt file2.txt", explanation: "连接多个文件并显示"),
                        CommandExample(command: "cat > newfile.txt", explanation: "从键盘输入创建文件（Ctrl+D 结束）"),
                        CommandExample(command: "cat -b file.txt", explanation: "只对非空行编号")
                    ],
                    commonOptions: [
                        (flag: "-n", description: "为所有输出行编号"),
                        (flag: "-b", description: "只为非空行编号（覆盖 -n）"),
                        (flag: "-s", description: "压缩连续空行为一个空行"),
                        (flag: "-e", description: "在每行末尾显示 $ 符号"),
                        (flag: "-t", description: "将 Tab 显示为 ^I"),
                        (flag: "-v", description: "显示不可打印字符（使用 ^ 和 M- 标记）"),
                        (flag: "-u", description: "禁用输出缓冲（POSIX 要求）")
                    ],
                    tips: "-n 显示行号，-s 压缩空行，-b 只对非空行编号"
                ),
                CommandItem(
                    name: "less",
                    syntax: "less [-aCdDeEFgGIiKnMOQRSUVWwX] [-m] [-N] [-P string] [-T tagfile] [-p pattern] [-o [ logfile ]] [+cm] [+dd] [+f] [+g] [+i] [+I] [+oo] [+p] [+s] [file ...]",
                    description: "分页查看文件内容，支持向前向后浏览。是 more 的增强版。",
                    examples: [
                        CommandExample(command: "less file.txt", explanation: "分页查看文件"),
                        CommandExample(command: "less -N file.txt", explanation: "显示行号"),
                        CommandExample(command: "dmesg | less", explanation: "分页查看系统日志"),
                        CommandExample(command: "less +F logfile", explanation: "实时追踪文件末尾（类似 tail -f）")
                    ],
                    commonOptions: [
                        (flag: "-N", description: "显示每行的行号"),
                        (flag: "-S", description: "禁用行折行（长行不换行，水平滚动）"),
                        (flag: "-F", description: "内容不到一屏时直接退出"),
                        (flag: "+F", description: "实时追踪文件末尾（tail -f 模式）"),
                        (flag: "-i", description: "忽略搜索时的大小写"),
                        (flag: "-I", description: "忽略搜索时的大小写（且无高亮）"),
                        (flag: "-p pattern", description: "打开后直接搜索指定模式"),
                        (flag: "-X", description: "不使用 termcap 初始化/清理"),
                        (flag: "-m", description: "显示更详细的状态行（百分比+行号）"),
                        (flag: "-e", description: "文件到达末尾时自动退出"),
                        (flag: "-c", description: "重绘屏幕时清除（非滚动）")
                    ],
                    tips: "空格下一页 b上一页 /搜索 n下一个 q退出 g首页 G末尾"
                ),
                CommandItem(
                    name: "head",
                    syntax: "head [-qv] [-c num | -n num] [file ...]",
                    description: "显示文件开头部分。",
                    examples: [
                        CommandExample(command: "head file.txt", explanation: "显示前 10 行（默认）"),
                        CommandExample(command: "head -n 20 file.txt", explanation: "显示前 20 行"),
                        CommandExample(command: "head -c 100 file.txt", explanation: "显示前 100 个字节"),
                        CommandExample(command: "head -5 file.txt", explanation: "POSIX 风格：显示前 5 行"),
                        CommandExample(command: "head -n -5 file.txt", explanation: "显示除最后 5 行外的所有内容")
                    ],
                    commonOptions: [
                        (flag: "-n num", description: "指定显示的行数（默认 10）"),
                        (flag: "-c num", description: "指定显示的字节数"),
                        (flag: "-q", description: "不显示文件名头"),
                        (flag: "-v", description: "始终显示文件名头")
                    ],
                    tips: "head -n -5 表示排除最后5行，正数=从头开始，负数=从尾排除"
                ),
                CommandItem(
                    name: "tail",
                    syntax: "tail [-cfilnqsF] [-r] [-s sec] [-c num | -n num] [file ...]",
                    description: "显示文件末尾部分。常用于查看日志。",
                    examples: [
                        CommandExample(command: "tail file.txt", explanation: "显示最后 10 行（默认）"),
                        CommandExample(command: "tail -n 50 file.txt", explanation: "显示最后 50 行"),
                        CommandExample(command: "tail -f /var/log/system.log", explanation: "实时追踪日志文件"),
                        CommandExample(command: "tail -f -n 20 logfile.log", explanation: "显示最后 20 行并持续追踪"),
                        CommandExample(command: "tail -F logfile.log", explanation: "追踪文件（文件轮转时自动重新打开）")
                    ],
                    commonOptions: [
                        (flag: "-f", description: "持续追踪文件更新（实时输出新内容）"),
                        (flag: "-F", description: "追踪文件（文件重命名/轮转时重新打开）"),
                        (flag: "-n num", description: "指定显示的行数（默认 10）"),
                        (flag: "-c num", description: "指定显示的字节数"),
                        (flag: "-q", description: "不显示文件名头"),
                        (flag: "-v", description: "始终显示文件名头"),
                        (flag: "-s sec", description: "-f 模式下的轮询间隔（秒）"),
                        (flag: "-r", description: "从文件末尾开始逐行输出（默认行为）"),
                        (flag: "-b", description: "仅按块（512字节）计数"),
                        (flag: "-i", description: "忽略文件不存在的错误"),
                        (flag: "+num", description: "从第 num 行开始显示（POSIX）")
                    ],
                    tips: "-f 追踪日志，-F 文件轮转安全，tail -n +1 显示全部"
                ),
                CommandItem(
                    name: "grep",
                    syntax: "grep [-abcdDEFGHhIiJLlmoqRrsUVvWwx] [-A num] [-B num] [-C num] [-e pattern] [-f file] [pattern] [file ...]",
                    description: "在文件中搜索匹配指定模式的行。支持 BRE、ERE、PCRE 三种正则。",
                    examples: [
                        CommandExample(command: "grep 'error' logfile.txt", explanation: "搜索包含 error 的行"),
                        CommandExample(command: "grep -i 'error' logfile.txt", explanation: "忽略大小写搜索"),
                        CommandExample(command: "grep -r 'TODO' ./src/", explanation: "递归搜索目录下所有文件"),
                        CommandExample(command: "grep -n 'function' script.js", explanation: "显示匹配行及其行号"),
                        CommandExample(command: "grep -c 'error' logfile.txt", explanation: "统计匹配的行数"),
                        CommandExample(command: "grep -v 'debug' logfile.txt", explanation: "显示不匹配的行（反向搜索）"),
                        CommandExample(command: "grep -E 'err|warn|fail' log.txt", explanation: "使用扩展正则匹配多种模式"),
                        CommandExample(command: "grep -P '\\d{3}-\\d{4}' file.txt", explanation: "使用 Perl 正则匹配电话号码")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "忽略大小写匹配"),
                        (flag: "-r", description: "递归搜索目录下所有文件"),
                        (flag: "-R", description: "递归搜索（跟随符号链接）"),
                        (flag: "-n", description: "显示匹配行的行号"),
                        (flag: "-c", description: "只统计匹配的行数"),
                        (flag: "-v", description: "反向选择：显示不匹配的行"),
                        (flag: "-l", description: "只显示包含匹配的文件名"),
                        (flag: "-L", description: "只显示不包含匹配的文件名"),
                        (flag: "-w", description: "全词匹配（word boundary）"),
                        (flag: "-x", description: "整行匹配"),
                        (flag: "-E", description: "扩展正则表达式 (ERE，等同 egrep)"),
                        (flag: "-F", description: "固定字符串匹配（非正则，等同 fgrep）"),
                        (flag: "-P", description: "Perl 正则表达式 (PCRE)"),
                        (flag: "-o", description: "只输出匹配的部分（非整行）"),
                        (flag: "-m num", description: "最多匹配 num 次后停止"),
                        (flag: "-A num", description: "显示匹配行后 N 行 (After)"),
                        (flag: "-B num", description: "显示匹配行前 N 行 (Before)"),
                        (flag: "-C num", description: "显示匹配行前后各 N 行 (Context)"),
                        (flag: "-e pattern", description: "指定匹配模式（可多次使用）"),
                        (flag: "-f file", description: "从文件读取匹配模式"),
                        (flag: "--color", description: "高亮显示匹配部分"),
                        (flag: "--include=glob", description: "只搜索匹配 glob 的文件"),
                        (flag: "--exclude=glob", description: "排除匹配 glob 的文件"),
                        (flag: "--exclude-dir=dir", description: "排除指定目录")
                    ],
                    tips: "最强大：-i忽略大小写 -r递归 -n行号 -E扩展正则 -o只输出匹配"
                ),
                CommandItem(
                    name: "sed",
                    syntax: "sed [-EalIi] [-e command] [-f command_file] [-n] [-r extension] [script] [file ...]",
                    description: "流编辑器，对输入进行基本的文本转换。支持 BRE 和 ERE。",
                    examples: [
                        CommandExample(command: "sed 's/old/new/' file.txt", explanation: "将每行第一个 old 替换为 new"),
                        CommandExample(command: "sed 's/old/new/g' file.txt", explanation: "替换所有 old 为 new"),
                        CommandExample(command: "sed -i '' 's/old/new/g' file.txt", explanation: "直接修改文件（原地替换）"),
                        CommandExample(command: "sed -n '5,10p' file.txt", explanation: "只显示第 5-10 行"),
                        CommandExample(command: "sed '/^$/d' file.txt", explanation: "删除所有空行"),
                        CommandExample(command: "sed -E 's/[0-9]+/NUM/g' file.txt", explanation: "ERE: 将所有数字替换为 NUM")
                    ],
                    commonOptions: [
                        (flag: "s/pattern/replacement/", description: "替换命令（最常用）"),
                        (flag: "/pattern/d", description: "删除匹配的行"),
                        (flag: "/pattern/p", description: "打印匹配的行"),
                        (flag: "i\\", description: "在匹配行前插入文本"),
                        (flag: "a\\", description: "在匹配行后追加文本"),
                        (flag: "c\\", description: "替换匹配的整行"),
                        (flag: "y/src/dst/", description: "逐字符替换（类似 tr）"),
                        (flag: "d", description: "删除行"),
                        (flag: "p", description: "打印行"),
                        (flag: "n", description: "读取下一行到模式空间"),
                        (flag: "w file", description: "将匹配行写入文件"),
                        (flag: "-i ''", description: "macOS 原地修改（注意需要 '' 参数）"),
                        (flag: "-E / -r", description: "使用扩展正则表达式 (ERE)"),
                        (flag: "-n", description: "静默模式（配合 p 命令使用）"),
                        (flag: "-e cmd", description: "指定多个编辑命令"),
                        (flag: "-f file", description: "从文件读取编辑命令")
                    ],
                    tips: "macOS 的 sed 需要 -i '' 才能原地修改，/g 全局替换，-E 启用 ERE"
                ),
                CommandItem(
                    name: "awk",
                    syntax: "awk [-F sep] [-v var=val] [-f progfile | 'program text'] [file ...]",
                    description: "强大的文本处理语言，按字段处理数据。支持完整的编程语法。",
                    examples: [
                        CommandExample(command: "awk '{print $1}' file.txt", explanation: "打印每行第一列"),
                        CommandExample(command: "awk -F: '{print $1, $3}' /etc/passwd", explanation: "以:分隔，打印用户名和UID"),
                        CommandExample(command: "awk '$3 > 100' data.txt", explanation: "打印第三列大于 100 的行"),
                        CommandExample(command: "awk '{sum+=$1} END {print sum}' nums.txt", explanation: "计算第一列的总和"),
                        CommandExample(command: "awk 'NR==1' file.txt", explanation: "只打印第一行")
                    ],
                    commonOptions: [
                        (flag: "-F sep", description: "指定字段分隔符（默认空格/Tab）"),
                        (flag: "-v var=val", description: "在执行前设置变量值"),
                        (flag: "-f file", description: "从文件读取 awk 程序"),
                        (flag: "$0", description: "整行内容"),
                        (flag: "$1/$2/$3...", description: "第 1/2/3... 个字段"),
                        (flag: "NR", description: "当前行号（Number of Records）"),
                        (flag: "NF", description: "当前行的字段数（Number of Fields）"),
                        (flag: "FS", description: "输入字段分隔符"),
                        (flag: "OFS", description: "输出字段分隔符"),
                        (flag: "BEGIN { }", description: "在处理所有文件前执行"),
                        (flag: "END { }", description: "在处理所有文件后执行"),
                        (flag: "{print}", description: "打印（默认换行）"),
                        (flag: "{printf}", description: "格式化输出（不自动换行）")
                    ],
                    tips: "-F 指定分隔符，$0整行 $1第一列，NR行号 NF列数，BEGIN/END 前后处理"
                ),
                CommandItem(
                    name: "sort",
                    syntax: "sort [-bcdfhiMmnRruV] [-k keydef] [-o output] [-s separator] [-t char] [-T dir] [-u] [-z term] [file ...]",
                    description: "对文本行进行排序。支持多种排序方式和键指定。",
                    examples: [
                        CommandExample(command: "sort file.txt", explanation: "按字母顺序排序"),
                        CommandExample(command: "sort -n numbers.txt", explanation: "按数值排序"),
                        CommandExample(command: "sort -r file.txt", explanation: "逆序排序"),
                        CommandExample(command: "sort -k2 -t: file.txt", explanation: "以:分隔，按第二列排序"),
                        CommandExample(command: "sort -u file.txt", explanation: "排序并去除重复行"),
                        CommandExample(command: "sort -h sizes.txt", explanation: "人类可读排序 (K < M < G)")
                    ],
                    commonOptions: [
                        (flag: "-n", description: "按数值排序（默认字符串）"),
                        (flag: "-r", description: "逆序排列"),
                        (flag: "-k keydef", description: "指定排序键（-k 2,3 = 第2到第3字段）"),
                        (flag: "-t char", description: "指定字段分隔符"),
                        (flag: "-u", description: "排序并去除重复行"),
                        (flag: "-f", description: "忽略大小写"),
                        (flag: "-h", description: "人类可读排序 (2K < 1M < 1G)"),
                        (flag: "-M", description: "月份排序 (Jan < Feb < ...)"),
                        (flag: "-V", description: "版本号排序 (1.2 < 1.10)"),
                        (flag: "-R", description: "随机排序"),
                        (flag: "-m", description: "合并已排序的文件"),
                        (flag: "-c", description: "检查文件是否已排序"),
                        (flag: "-o file", description: "将输出写入文件而非 stdout"),
                        (flag: "-T dir", description: "指定临时文件目录"),
                        (flag: "-z", description: "以 null 字符分隔行（配合 find -print0）")
                    ],
                    tips: "-k 指定排序键，-t 指定分隔符，-V 版本号排序，-h 人类可读排序"
                ),
                CommandItem(
                    name: "uniq",
                    syntax: "uniq [-cdiuz] [-f fields] [-s chars] [+skip_fields] [+skip_chars] [input [output]]",
                    description: "过滤或显示文件中的相邻重复行（通常需先排序）。",
                    examples: [
                        CommandExample(command: "sort file.txt | uniq", explanation: "去除排序后的重复行"),
                        CommandExample(command: "sort file.txt | uniq -c", explanation: "统计每行出现次数"),
                        CommandExample(command: "sort file.txt | uniq -d", explanation: "只显示重复的行"),
                        CommandExample(command: "sort file.txt | uniq -u", explanation: "只显示唯一的行"),
                        CommandExample(command: "uniq -i -f1 file.txt", explanation: "忽略大小写，跳过第一列比较")
                    ],
                    commonOptions: [
                        (flag: "-c", description: "在每行前显示出现次数"),
                        (flag: "-d", description: "只显示有重复的行"),
                        (flag: "-u", description: "只显示唯一出现的行"),
                        (flag: "-i", description: "忽略大小写比较"),
                        (flag: "-f fields", description: "比较时跳过前 N 个字段"),
                        (flag: "-s chars", description: "比较时跳过前 N 个字符"),
                        (flag: "-z", description: "以 null 字符分隔行（处理含换行的数据）")
                    ],
                    tips: "-c 计数（最常用），-d 只显示重复，-u 只显示唯一"
                ),
                CommandItem(
                    name: "wc",
                    syntax: "wc [-clmw] [file ...]",
                    description: "统计文件的行数、单词数、字节数。",
                    examples: [
                        CommandExample(command: "wc file.txt", explanation: "显示行数 单词数 字节数"),
                        CommandExample(command: "wc -l file.txt", explanation: "只统计行数"),
                        CommandExample(command: "ls | wc -l", explanation: "统计当前目录文件数量"),
                        CommandExample(command: "wc -m file.txt", explanation: "只统计字符数（多字节安全）")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "只统计行数"),
                        (flag: "-w", description: "只统计单词数（空白分隔）"),
                        (flag: "-c", description: "只统计字节数"),
                        (flag: "-m", description: "只统计字符数（多字节字符安全）"),
                        (flag: "-L", description: "显示最长行的长度")
                    ],
                    tips: "-l 行数最常用，ls | wc -l 统计文件数"
                ),
                CommandItem(
                    name: "cut",
                    syntax: "cut [-Cfzn] [-b list] [-c list] [-d delim] [-f list] [-s] [-w] [file ...]",
                    description: "从每行中提取指定部分（字节、字符或字段）。",
                    examples: [
                        CommandExample(command: "cut -d: -f1 /etc/passwd", explanation: "以:分隔，提取第一列"),
                        CommandExample(command: "cut -c1-10 file.txt", explanation: "提取每行前 10 个字符"),
                        CommandExample(command: "echo 'a,b,c' | cut -d, -f2", explanation: "提取逗号分隔的第二部分"),
                        CommandExample(command: "cut -b1-5 file.txt", explanation: "提取前 5 个字节")
                    ],
                    commonOptions: [
                        (flag: "-d delim", description: "指定字段分隔符（默认 Tab）"),
                        (flag: "-f list", description: "指定字段（1,3-5,7）"),
                        (flag: "-c list", description: "指定字符位置（1-10,15）"),
                        (flag: "-b list", description: "指定字节位置"),
                        (flag: "-s", description: "不输出不含分隔符的行"),
                        (flag: "-w", description: "忽略非空白字符的分隔符"),
                        (flag: "--complement", description: "输出指定字段以外的部分"),
                        (flag: "--output-delimiter=DELIM", description: "指定输出分隔符")
                    ],
                    tips: "-d 指定分隔符，-f 指定字段，-c 指定字符范围"
                ),
                CommandItem(
                    name: "tr",
                    syntax: "tr [-Ccsu] string1 string2\n     tr [-Ccsu] -d string1\n     tr [-Ccsu] -s string1\n     tr [-Ccsu] -ds string1 string2",
                    description: "转换或删除字符。按字符逐一映射。",
                    examples: [
                        CommandExample(command: "echo 'Hello' | tr 'A-Z' 'a-z'", explanation: "转换为小写"),
                        CommandExample(command: "echo 'Hello World' | tr ' ' '\\n'", explanation: "将空格替换为换行"),
                        CommandExample(command: "cat file.txt | tr -d '\\r'", explanation: "删除回车符（Mac转Unix换行）"),
                        CommandExample(command: "echo 'aabbcc' | tr -s 'a-z'", explanation: "压缩连续重复字符为一个")
                    ],
                    commonOptions: [
                        (flag: "string1 string2", description: "将 string1 中的字符映射到 string2"),
                        (flag: "-d", description: "删除 string1 中的所有字符"),
                        (flag: "-s", description: "将连续重复字符压缩为单个"),
                        (flag: "-c", description: "取 string1 的补集（反转选择）"),
                        (flag: "-C", description: "同 -c 但只处理补集中的字符"),
                        (flag: "-u", description: "丢弃 string2 中未对应的输出"),
                        (flag: "[:upper:]", description: "字符类: 所有大写字母"),
                        (flag: "[:lower:]", description: "字符类: 所有小写字母"),
                        (flag: "[:digit:]", description: "字符类: 所有数字"),
                        (flag: "[:alpha:]", description: "字符类: 所有字母"),
                        (flag: "[:space:]", description: "字符类: 所有空白字符")
                    ],
                    tips: "字符替换是 1:1 映射，-d 删除，-s 压缩，支持 [:upper:] 等字符类"
                ),
                CommandItem(
                    name: "tee",
                    syntax: "tee [-a] [-i] [file ...]",
                    description: "从标准输入读取并同时写入标准输出和文件。",
                    examples: [
                        CommandExample(command: "ls | tee filelist.txt", explanation: "列出文件同时保存到文件"),
                        CommandExample(command: "echo 'hello' | tee -a file.txt", explanation: "追加写入文件"),
                        CommandExample(command: "date | tee log1.txt log2.txt", explanation: "同时写入多个文件"),
                        CommandExample(command: "make 2>&1 | tee build.log", explanation: "同时显示和保存构建日志")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "追加到文件末尾（默认覆盖）"),
                        (flag: "-i", description: "忽略中断信号 (SIGINT)")
                    ],
                    tips: "常与 2>&1 配合同时捕获标准输出和错误"
                ),
                CommandItem(
                    name: "xargs",
                    syntax: "xargs [-0Eopt] [-E eofstr] [-I replstr] [-J replstr] [-L num] [-n num] [-P maxprocs] [-s size] [command [argument ...]]",
                    description: "从标准输入读取参数，传递给指定命令执行。",
                    examples: [
                        CommandExample(command: "find . -name '*.tmp' | xargs rm", explanation: "删除所有 tmp 文件"),
                        CommandExample(command: "find . -print0 | xargs -0 rm", explanation: "安全删除（处理特殊文件名）"),
                        CommandExample(command: "cat urls.txt | xargs -n 1 curl", explanation: "逐行执行 curl"),
                        CommandExample(command: "echo {1..10} | xargs -I {} echo Item-{}", explanation: "批量替换执行")
                    ],
                    commonOptions: [
                        (flag: "-n num", description: "每次传递给命令的参数个数"),
                        (flag: "-I replstr", description: "用 replstr 作为参数占位符"),
                        (flag: "-0", description: "以 null 字符分隔输入（配合 find -print0）"),
                        (flag: "-p", description: "每次执行前提示确认"),
                        (flag: "-t", description: "执行前打印完整命令"),
                        (flag: "-P maxprocs", description: "并行执行，最多 N 个进程"),
                        (flag: "-L num", description: "每次从输入读取 N 行作为参数"),
                        (flag: "-s size", description: "限制每次命令行的最大长度"),
                        (flag: "-E eofstr", description: "遇到 eofstr 时停止读取"),
                        (flag: "--no-run-if-empty", description: "输入为空时不执行命令（-r）")
                    ],
                    tips: "-0 处理特殊文件名，-I {} 占位符，-P 并行执行"
                ),
                CommandItem(
                    name: "pbcopy / pbpaste",
                    syntax: "pbcopy\n     pbpaste",
                    description: "macOS 剪贴板操作：pbcopy 将 stdin 写入剪贴板，pbpaste 从剪贴板输出。",
                    examples: [
                        CommandExample(command: "echo 'hello' | pbcopy", explanation: "将文本写入剪贴板"),
                        CommandExample(command: "pbpaste > file.txt", explanation: "将剪贴板内容保存到文件"),
                        CommandExample(command: "cat file.txt | pbcopy", explanation: "将文件内容复制到剪贴板"),
                        CommandExample(command: "pbpaste | grep 'keyword'", explanation: "从剪贴板内容中搜索")
                    ],
                    commonOptions: [
                        (flag: "pbcopy", description: "stdin → 系统剪贴板"),
                        (flag: "pbpaste", description: "系统剪贴板 → stdout"),
                        (flag: "-Prefer", description: "pbpaste: -Prefer txt|rtf|png|tiff 指定粘贴板类型")
                    ],
                    tips: "macOS 独有工具，可通过管道与其他命令组合使用"
                ),
                CommandItem(
                    name: "say",
                    syntax: "say [-v voice] [-r rate] [-o file | --output-file=file] [text to speak]",
                    description: "macOS 文本转语音工具（TTS）。",
                    examples: [
                        CommandExample(command: "say 'Hello World'", explanation: "朗读文本"),
                        CommandExample(command: "say -v Ting-Ting '你好世界'", explanation: "使用中文语音"),
                        CommandExample(command: "say -v '?'", explanation: "列出所有可用语音"),
                        CommandExample(command: "say -r 200 'Fast speech'", explanation: "以较慢语速朗读"),
                        CommandExample(command: "say -o output.aiff 'Save to file'", explanation: "保存为 AIFF 音频文件")
                    ],
                    commonOptions: [
                        (flag: "-v voice", description: "指定语音（-v ? 列出所有语音）"),
                        (flag: "-r rate", description: "语速（词/分钟，默认 ~175-250）"),
                        (flag: "-o file", description: "输出到音频文件而非播放"),
                        (flag: "-f file", description: "从文件读取要朗读的文本"),
                        (flag: "-i index", description: "从指定索引位置开始朗读")
                    ],
                    tips: "-v ? 列出所有语音，-v Ting-Ting 中文女声"
                ),
                CommandItem(
                    name: "column",
                    syntax: "column [-t] [-s sep] [-c width] [-J] [-N name] [-R col] [-L num] [file ...]",
                    description: "将输入格式化为对齐的列。非常适合格式化管道输出。",
                    examples: [
                        CommandExample(command: "mount | column -t", explanation: "格式化 mount 输出为对齐列"),
                        CommandExample(command: "cat /etc/passwd | column -t -s :", explanation: "以:分隔，格式化为列"),
                        CommandExample(command: "echo 'a,b,c' | column -t -s ,", explanation: "CSV 转对齐列"),
                        CommandExample(command: "df -h | column -t", explanation: "格式化磁盘使用信息"),
                        CommandExample(command: "ps aux | column -t", explanation: "格式化进程列表")
                    ],
                    commonOptions: [
                        (flag: "-t", description: "确定列数并创建表格"),
                        (flag: "-s sep", description: "指定字段分隔符"),
                        (flag: "-c width", description: "输出宽度（默认终端宽度）"),
                        (flag: "-J", description: "JSON 格式输出"),
                        (flag: "-N name1,name2", description: "指定列名"),
                        (flag: "-R col", description: "按指定列右对齐"),
                        (flag: "-L num", description: "限制指定列的宽度"),
                        (flag: "-x", description: "填充行而非列")
                    ],
                    tips: "-t 自动对齐列，-s 指定分隔符，常与 mount/df/ps 配合"
                ),
                CommandItem(
                    name: "paste",
                    syntax: "paste [-s] [-d delim] [-z] [file ...]",
                    description: "合并文件的对应行，或用 -s 将单个文件的多行合并为一行。",
                    examples: [
                        CommandExample(command: "paste file1.txt file2.txt", explanation: "并行合并两个文件（Tab分隔）"),
                        CommandExample(command: "paste -s file.txt", explanation: "将所有行合并为一行"),
                        CommandExample(command: "paste -s -d ',' file.txt", explanation: "用逗号连接所有行"),
                        CommandExample(command: "echo -e 'a\nb\nc' | paste -sd '+' | bc", explanation: "将数字行用+连接后计算"),
                        CommandExample(command: "paste -d '|' file1 file2", explanation: "用 | 分隔合并两列")
                    ],
                    commonOptions: [
                        (flag: "-s", description: "将单个文件的行串联合并"),
                        (flag: "-d delim", description: "指定分隔符（可多字符循环使用）"),
                        (flag: "-z", description: "用 null 字符替换换行符"),
                        (flag: "--", description: "后续参数作为文件名（即使 - 开头）")
                    ],
                    tips: "-s 串联行，-d 指定分隔符，paste -sd '' 合并为一行"
                ),
                CommandItem(
                    name: "nl",
                    syntax: "nl [-b type] [-d delim] [-f type] [-h type] [-i num] [-l num] [-n format] [-p] [-s sep] [-v start] [-w width] [-ba] [-bn] [-bp] [-bt] [-nrz] [-zh] [file ...]",
                    description: "为文件的每一行添加行号。比 cat -n 更灵活。",
                    examples: [
                        CommandExample(command: "nl file.txt", explanation: "为每行添加行号"),
                        CommandExample(command: "nl -ba file.txt", explanation: "所有行都编号（含空行）"),
                        CommandExample(command: "nl -bn file.txt", explanation: "只对非空行编号（默认）"),
                        CommandExample(command: "nl -bp 'BEGIN' file.txt", explanation: "对匹配行编号，其余跳过"),
                        CommandExample(command: "nl -v 10 -i 5 file.txt", explanation: "从10开始，步长为5")
                    ],
                    commonOptions: [
                        (flag: "-ba", description: "所有行编号"),
                        (flag: "-bn", description: "只对非空行编号（默认）"),
                        (flag: "-bp pattern", description: "对匹配 pattern 的行编号"),
                        (flag: "-bt", description: "只对被页眉分隔的 body 编号"),
                        (flag: "-v start", description: "起始行号"),
                        (flag: "-i num", description: "行号增量"),
                        (flag: "-n format", description: "行号格式: ln(左对齐) rn(右对齐) rz(补零)"),
                        (flag: "-s sep", description: "行号与内容之间的分隔符"),
                        (flag: "-w width", description: "行号宽度"),
                        (flag: "-d delim", description: "页眉/页脚分隔符（默认 \\:)"),
                        (flag: "-h type", description: "页眉计数器类型"),
                        (flag: "-f type", description: "页脚计数器类型"),
                        (flag: "-p", description: "不重置页眉后的行号")
                    ],
                    tips: "-ba 所有行 -bn 非空行 -bp 正则匹配行 -v 起始号 -i 增量"
                ),
                CommandItem(
                    name: "fmt",
                    syntax: "fmt [-cprs] [-d num] [-g num] [-h num] [-t num] [-u num] [-w num | -width num] [file ...]",
                    description: "简单的文本格式化工具，将段落重排为指定宽度的行。",
                    examples: [
                        CommandExample(command: "fmt file.txt", explanation: "以 75 列宽度重排文本"),
                        CommandExample(command: "fmt -w 60 file.txt", explanation: "以 60 列宽度重排"),
                        CommandExample(command: "fmt -s file.txt", explanation: "不合并短行（保持原格式）"),
                        CommandExample(command: "echo 'long text here' | fmt -w 40", explanation: "管道格式化文本"),
                        CommandExample(command: "fmt -u file.txt", explanation: "用空格分隔的空格（单空格）")
                    ],
                    commonOptions: [
                        (flag: "-w num / -width num", description: "指定最大行宽（默认 75）"),
                        (flag: "-s", description: "不合并短行（智能模式）"),
                        (flag: "-t", description: "不缩进第二行及后续行"),
                        (flag: "-u", description: "用空格分隔的空格"),
                        (flag: "-p", description: "只重新格式化以非空格开头的行"),
                        (flag: "-c", description: "每段居中对齐"),
                        (flag: "-d num", description: "用指定字符填充分隔线"),
                        (flag: "-g num", description: "将连续行视为一个段落的最小长度")
                    ],
                    tips: "默认 75 列宽度，-w 指定宽度，-s 不合并短行"
                )
            ]
        ),

// MARK: - 进程管理

        CommandCategory(
            name: "进程管理",
            icon: "square.stack.3d.up",
            commands: [
                CommandItem(
                    name: "ps",
                    syntax: "ps [-AaCcEefgjrSTuvwx] [-o format] [-p pid] [-t tty] [-u user] [-U user]",
                    description: "显示当前运行的进程信息。支持 BSD 和 UNIX 两种选项风格。",
                    examples: [
                        CommandExample(command: "ps aux", explanation: "显示所有用户的全部进程（BSD 风格）"),
                        CommandExample(command: "ps -ef", explanation: "显示所有进程（UNIX 风格）"),
                        CommandExample(command: "ps aux | grep python", explanation: "查找 Python 相关进程"),
                        CommandExample(command: "ps -o pid,ppid,%cpu,%mem,command -p 1234", explanation: "显示指定进程详细信息"),
                        CommandExample(command: "ps -eo pid,ppid,comm,%cpu --sort=-%cpu | head", explanation: "按 CPU 排序查看前10")
                    ],
                    commonOptions: [
                        (flag: "aux", description: "BSD: 所有用户(a) 终端(u) 全部进程(x)"),
                        (flag: "-ef", description: "UNIX: 所有(e) 完整格式(f)"),
                        (flag: "-A", description: "显示所有进程"),
                        (flag: "-a", description: "显示所有终端的进程（含其他用户）"),
                        (flag: "-u user", description: "BSD: 指定用户的进程"),
                        (flag: "-U user", description: "UNIX: 指定真实用户ID的进程"),
                        (flag: "-p pid", description: "只显示指定 PID 的进程"),
                        (flag: "-t tty", description: "只显示指定终端的进程"),
                        (flag: "-o format", description: "自定义输出格式"),
                        (flag: "-f", description: "完整格式（含 UID/PPID/CMD 等）"),
                        (flag: "-j", description: "作业格式（含 PGID/SID）"),
                        (flag: "-r", description: "只显示正在运行的进程"),
                        (flag: "--sort=-%cpu", description: "按 CPU 使用率降序排列"),
                        (flag: "--sort=-%mem", description: "按内存使用率降序排列")
                    ],
                    tips: "常用输出字段: pid ppid %cpu %mem vsz rss comm start time"
                ),
                CommandItem(
                    name: "top",
                    syntax: "top [-d delay] [-e | -g | -i | -l | -R | -s] [-n iterations] [-o key] [-O field] [-p pid] [-r] [-stats key,...] [-t] [-w width]",
                    description: "实时显示系统进程和资源使用情况。",
                    examples: [
                        CommandExample(command: "top", explanation: "启动进程监控（按 q 退出）"),
                        CommandExample(command: "top -l 1", explanation: "采集一次快照后退出"),
                        CommandExample(command: "top -l 1 -o cpu | head -20", explanation: "快照并按CPU排序，只看前20行"),
                        CommandExample(command: "top -pid 1234", explanation: "只监控指定 PID"),
                        CommandExample(command: "top -d 2", explanation: "每 2 秒刷新一次")
                    ],
                    commonOptions: [
                        (flag: "-l num", description: "指定采样次数后退出（-l 1=快照）"),
                        (flag: "-d delay", description: "刷新间隔（秒），默认 1 秒"),
                        (flag: "-o key", description: "排序键（cpu/mem/size/time/pid/state）"),
                        (flag: "-O field", description: "按指定字段排序"),
                        (flag: "-pid pid", description: "只监控指定的进程 ID"),
                        (flag: "-n num", description: "在 batch 模式下指定迭代次数"),
                        (flag: "-s", description: "安全模式（禁用一些危险操作）"),
                        (flag: "-t", description: "不显示标题栏（纯数据）"),
                        (flag: "-w", description: "指定输出宽度"),
                        (flag: "-e", description: "显示进程环境变量"),
                        (flag: "-r", description: "不排序（原始进程列表）"),
                        (flag: "-stats key", description: "只显示指定的统计列")
                    ],
                    tips: "q退出 M按内存排序 P按CPU排序 空格立即刷新 -l 1适合脚本采集"
                ),
                CommandItem(
                    name: "kill",
                    syntax: "kill [-s signal | -signum | -signal_name] pid ...",
                    description: "向进程发送信号，通常用于终止进程。",
                    examples: [
                        CommandExample(command: "kill 1234", explanation: "发送 SIGTERM (15) 优雅终止"),
                        CommandExample(command: "kill -9 1234", explanation: "发送 SIGKILL (9) 强制终止"),
                        CommandExample(command: "kill -HUP 1234", explanation: "发送 SIGHUP (1) 重载配置"),
                        CommandExample(command: "kill -STOP 1234", explanation: "发送 SIGSTOP 暂停进程"),
                        CommandExample(command: "kill -CONT 1234", explanation: "发送 SIGCONT 恢复进程")
                    ],
                    commonOptions: [
                        (flag: "默认(无信号)", description: "SIGTERM (15): 优雅终止，允许清理"),
                        (flag: "-9 / -KILL", description: "SIGKILL (9): 强制立即终止，不可捕获"),
                        (flag: "-1 / -HUP", description: "SIGHUP (1): 通常用于重启/重读配置"),
                        (flag: "-2 / -INT", description: "SIGINT (2): 中断（同 Ctrl+C）"),
                        (flag: "-3 / -QUIT", description: "SIGQUIT (3): 退出并生成 core dump"),
                        (flag: "-STOP", description: "SIGSTOP: 暂停进程（不可捕获）"),
                        (flag: "-CONT", description: "SIGCONT: 恢复被暂停的进程"),
                        (flag: "-USR1 / -USR2", description: "用户自定义信号（应用自行定义行为）"),
                        (flag: "-0 pid", description: "检查进程是否存在（不发送信号）"),
                        (flag: "-l", description: "列出所有信号名称")
                    ],
                    tips: "优雅终止用15，强制用9，重载配置用1(HUP)"
                ),
                CommandItem(
                    name: "killall",
                    syntax: "killall [-djqv] [-s signal | -signal_name] [-u user] name ...",
                    description: "按进程名终止所有匹配的进程。",
                    examples: [
                        CommandExample(command: "killall Safari", explanation: "关闭所有 Safari 进程"),
                        CommandExample(command: "killall -9 python3", explanation: "强制终止所有 python3"),
                        CommandExample(command: "killall -u john", explanation: "终止用户 john 的所有进程"),
                        CommandExample(command: "killall -s HUP nginx", explanation: "发送 HUP 信号给所有 nginx"),
                        CommandExample(command: "killall -d Safari", explanation: "显示 killall 将要终止的进程")
                    ],
                    commonOptions: [
                        (flag: "-9", description: "强制终止 (SIGKILL)"),
                        (flag: "-s signal", description: "发送指定信号"),
                        (flag: "-u user", description: "终止指定用户的所有进程"),
                        (flag: "-i", description: "逐个确认后终止"),
                        (flag: "-q", description: "静默模式（无进程匹配时不报错）"),
                        (flag: "-d", description: "调试模式：显示但不执行"),
                        (flag: "-v", description: "详细模式：显示终止的进程")
                    ],
                    tips: "比 kill + pid 更方便，-d 先预览再决定"
                ),
                CommandItem(
                    name: "pgrep / pkill",
                    syntax: "pgrep [-d delim] [-fliLnoqSvx] [-F pidfile] [-G gid] [-P ppid] [-s sid] [-t term] [-u euid] [-U uid] [pattern]\n     pkill [-d signal] [-fliLnoqvSvx] [-F pidfile] [-G gid] [-P ppid] [-s sid] [-t term] [-u euid] [-U uid] [pattern]",
                    description: "按名称/属性查找进程（pgrep）或按名称/属性终止进程（pkill）。",
                    examples: [
                        CommandExample(command: "pgrep -l python", explanation: "查找 python 进程并显示名称"),
                        CommandExample(command: "pgrep -f 'http.server'", explanation: "查找命令行含 http.server 的进程"),
                        CommandExample(command: "pkill -f 'http.server'", explanation: "终止所有 http.server 进程"),
                        CommandExample(command: "pgrep -u john", explanation: "查找用户 john 的所有进程"),
                        CommandExample(command: "pkill -SIGHUP nginx", explanation: "发送 HUP 信号给所有 nginx")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "pgrep: 显示进程名"),
                        (flag: "-a", description: "pgrep: 显示完整命令行"),
                        (flag: "-f", description: "匹配完整命令行（非仅进程名）"),
                        (flag: "-i", description: "忽略大小写匹配"),
                        (flag: "-u euid", description: "匹配指定有效用户的进程"),
                        (flag: "-U uid", description: "匹配指定真实用户ID的进程"),
                        (flag: "-P ppid", description: "匹配指定父进程ID的子进程"),
                        (flag: "-d delim", description: "pgrep: 指定 PID 分隔符"),
                        (flag: "-signal", description: "pkill: 指定信号（默认 SIGTERM）"),
                        (flag: "-q", description: "不输出 PID（用于脚本判断）"),
                        (flag: "-v", description: "反向匹配（排除匹配的进程）")
                    ],
                    tips: "pgrep 查找进程ID，pkill 终止进程，-f 匹配完整命令行"
                ),
                CommandItem(
                    name: "lsof",
                    syntax: "lsof [-aAbCdehKlnNOPRstUvVXx] [-c c] [+c c] [+|-d d] [+D D] [+|-E] [+e e] [+|-f [F]] [-g [s]] [-H h] [-i [i]] [-l l] [+|-L [l]] [+m [m]] [+M] [-o o] [-p s] [+r [t]] [-R [r]] [-s [s:S]] [+|-T t] [+|-u u] [+|-U] [user] [file ...]",
                    description: "列出打开的文件。在 macOS/Linux 中几乎一切皆文件。",
                    examples: [
                        CommandExample(command: "lsof", explanation: "列出所有打开的文件"),
                        CommandExample(command: "lsof -i :8080", explanation: "查看占用 8080 端口的进程"),
                        CommandExample(command: "lsof -u john", explanation: "列出用户 john 打开的文件"),
                        CommandExample(command: "lsof /path/to/file", explanation: "查看谁在使用指定文件"),
                        CommandExample(command: "lsof -c Safari", explanation: "列出 Safari 打开的所有文件"),
                        CommandExample(command: "lsof -p 1234", explanation: "列出 PID 1234 打开的所有文件"),
                        CommandExample(command: "lsof -i tcp", explanation: "列出所有 TCP 网络连接")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "按网络连接筛选"),
                        (flag: "-i :port", description: "按端口号筛选"),
                        (flag: "-i tcp/udp", description: "按协议筛选"),
                        (flag: "-u user", description: "按用户筛选"),
                        (flag: "-c name", description: "按进程名筛选（前缀匹配）"),
                        (flag: "+c name", description: "按进程名筛选（指定字符数）"),
                        (flag: "-p pid", description: "按 PID 筛选"),
                        (flag: "+D dir", description: "递归搜索目录下打开的文件"),
                        (flag: "+d dir", description: "搜索目录下打开的文件（非递归）"),
                        (flag: "-d fd", description: "按文件描述符筛选"),
                        (flag: "-a", description: "AND 组合多个条件"),
                        (flag: "-t", description: "只输出 PID（适合脚本）"),
                        (flag: "-n", description: "不解析主机名和端口名"),
                        (flag: "-P", description: "不解析端口号为名称"),
                        (flag: "-R", description: "显示进程的 PPID"),
                        (flag: "-s tcp/udp", description: "按协议状态筛选")
                    ],
                    tips: "端口占用排查: lsof -i :PORT，-t 输出 PID 配合 kill 使用"
                ),
                CommandItem(
                    name: "nohup",
                    syntax: "nohup command [argument ...]",
                    description: "运行命令使其在退出终端后继续运行（忽略 SIGHUP 信号）。",
                    examples: [
                        CommandExample(command: "nohup long_script.sh &", explanation: "后台运行脚本"),
                        CommandExample(command: "nohup python3 server.py > output.log 2>&1 &", explanation: "后台运行并重定向所有输出"),
                        CommandExample(command: "nohup make -j4 &> build.log &", explanation: "后台编译并记录日志")
                    ],
                    commonOptions: [
                        (flag: "&", description: "放入后台运行"),
                        (flag: "> file", description: "重定向 stdout 到文件"),
                        (flag: "2>&1", description: "将 stderr 也重定向到 stdout")
                    ],
                    tips: "输出默认写入 nohup.out，建议显式重定向到日志文件"
                ),
                CommandItem(
                    name: "bg / fg / jobs",
                    syntax: "bg [job_id ...]\n     fg [job_id]\n     jobs [-l]",
                    description: "作业控制：jobs 列出后台任务，bg 后台继续，fg 调回前台。",
                    examples: [
                        CommandExample(command: "sleep 1000 &", explanation: "将命令放入后台运行"),
                        CommandExample(command: "jobs -l", explanation: "列出所有后台任务及其 PID"),
                        CommandExample(command: "bg %1", explanation: "将暂停的任务 1 放入后台运行"),
                        CommandExample(command: "fg %1", explanation: "将任务 1 调回前台"),
                        CommandExample(command: "Ctrl+Z", explanation: "暂停当前前台进程"),
                        CommandExample(command: "kill %1", explanation: "终止后台任务 1")
                    ],
                    commonOptions: [
                        (flag: "%N", description: "引用作业编号 N"),
                        (flag: "%string", description: "引用命令以 string 开头的作业"),
                        (flag: "%?string", description: "引用命令包含 string 的作业"),
                        (flag: "%+", description: "引用当前作业"),
                        (flag: "%-", description: "引用上一个作业"),
                        (flag: "-l", description: "jobs: 显示 PID 和作业号")
                    ],
                    tips: "& 后台运行，Ctrl+Z 暂停，bg/fg 切换，jobs 查看"
                ),
                CommandItem(
                    name: "launchctl",
                    syntax: "launchctl bootstrap target-domain-target [service-targets ...]\n     launchctl bootout target-domain-target [service-targets ...]\n     launchctl enable service-target\n     launchctl disable service-target\n     launchctl list [-x] [service-target]\n     launchctl start service-target\n     launchctl stop service-target\n     launchctl kickstart [-k] [-p] service-target\n     launchctl kill signal service-target\n     launchctl blame service-target\n     launchctl print service-target\n     launchctl print-cache\n     launchctl dumpstate",
                    description: "管理 macOS 的 launchd 守护进程和服务。",
                    examples: [
                        CommandExample(command: "launchctl list", explanation: "列出所有已加载的服务"),
                        CommandExample(command: "launchctl list | grep com.user", explanation: "查找自定义服务"),
                        CommandExample(command: "launchctl stop com.user.myservice", explanation: "停止指定服务"),
                        CommandExample(command: "launchctl start com.user.myservice", explanation: "启动指定服务"),
                        CommandExample(command: "launchctl bootout gui/$(id -u)", explanation: "卸载当前用户的 LaunchAgent"),
                        CommandExample(command: "launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.plist", explanation: "加载 LaunchAgent")
                    ],
                    commonOptions: [
                        (flag: "list", description: "列出所有已加载服务"),
                        (flag: "start", description: "启动指定服务"),
                        (flag: "stop", description: "停止指定服务"),
                        (flag: "bootstrap target plist", description: "加载服务（推荐替代 load）"),
                        (flag: "bootout target/service", description: "卸载服务（推荐替代 unload）"),
                        (flag: "enable service", description: "启用服务"),
                        (flag: "disable service", description: "禁用服务"),
                        (flag: "kickstart", description: "强制重启服务"),
                        (flag: "kill signal service", description: "发送信号给服务"),
                        (flag: "blame service", description: "显示服务为何仍在运行"),
                        (flag: "print service", description: "显示服务详细信息"),
                        (flag: "-k", description: "kickstart: 先杀再启动")
                    ],
                    tips: "gui/$(id -u) 是当前用户的 domain，LaunchAgents 放 ~/Library/LaunchAgents/"
                ),
                CommandItem(
                    name: "open",
                    syntax: "open [-e] [-t] [-f] [-F] [-W] [-R] [-n] [-g] [-h] [-a application] [file] [--args arg1 arg2 ...]",
                    description: "打开文件、目录或 URL，使用默认应用程序。",
                    examples: [
                        CommandExample(command: "open .", explanation: "在 Finder 中打开当前目录"),
                        CommandExample(command: "open file.txt", explanation: "用默认应用打开文件"),
                        CommandExample(command: "open https://apple.com", explanation: "在默认浏览器中打开 URL"),
                        CommandExample(command: "open -a Safari", explanation: "打开 Safari 浏览器"),
                        CommandExample(command: "open -a 'VS Code' .", explanation: "用 VS Code 打开当前目录"),
                        CommandExample(command: "open -R file.txt", explanation: "在 Finder 中显示并选中文件"),
                        CommandExample(command: "open --args --incognito https://google.com", explanation: "传参数给应用")
                    ],
                    commonOptions: [
                        (flag: "-a app", description: "指定要使用的应用程序"),
                        (flag: "-e", description: "在 TextEdit 中打开"),
                        (flag: "-t", description: "在默认文本编辑器中打开"),
                        (flag: "-f", description: "直接打开 stdin 内容"),
                        (flag: "-F", description: "以 Quick Look 方式打开"),
                        (flag: "-R", description: "在 Finder 中显示并选中文件"),
                        (flag: "-W", description: "等待应用关闭后才返回"),
                        (flag: "-n", description: "打开应用的新实例"),
                        (flag: "-g", description: "以后台方式打开应用"),
                        (flag: "-h", description: "搜索帮助菜单内容"),
                        (flag: "--args", description: "后续参数传给打开的应用")
                    ],
                    tips: "-a 指定应用，-R 在Finder显示，--args 传递启动参数"
                ),
                CommandItem(
                    name: "sleep",
                    syntax: "sleep seconds",
                    description: "暂停指定时间。常用于脚本中的延时。",
                    examples: [
                        CommandExample(command: "sleep 5", explanation: "暂停 5 秒"),
                        CommandExample(command: "sleep 0.5", explanation: "暂停 0.5 秒"),
                        CommandExample(command: "sleep 1m", explanation: "暂停 1 分钟"),
                        CommandExample(command: "sleep 2h", explanation: "暂停 2 小时"),
                        CommandExample(command: "sleep 1d", explanation: "暂停 1 天")
                    ],
                    commonOptions: [
                        (flag: "无选项", description: "参数为秒数，支持小数"),
                        (flag: "s/m/h/d 后缀", description: "s=秒 m=分 h=时 d=天")
                    ],
                    tips: "支持小数秒和 s/m/h/d 后缀，脚本中常配合 while 循环使用"
                ),
                CommandItem(
                    name: "nice",
                    syntax: "nice [-n increment] [command [argument ...]]",
                    description: "以较低优先级运行命令。数值越大优先级越低（-20最高 19最低）。",
                    examples: [
                        CommandExample(command: "nice make -j4", explanation: "以默认低优先级运行 make"),
                        CommandExample(command: "nice -n 10 tar czf backup.tar.gz ~/", explanation: "更低优先级压缩备份"),
                        CommandExample(command: "nice -n 19 rsync -avz src/ dest/", explanation: "最低优先级同步文件"),
                        CommandExample(command: "nice -n 5 ffmpeg -i input.mp4 output.mp4", explanation: "低优先级转码视频")
                    ],
                    commonOptions: [
                        (flag: "-n increment", description: "指定优先级增加值（默认 10，-20最高 19最低）")
                    ],
                    tips: "默认降低 10 个优先级，-n 指定增加值，适合后台任务不抢占前台"
                ),
                CommandItem(
                    name: "renice",
                    syntax: "renice [-n priority] [-g | -p | -u] id ...",
                    description: "更改正在运行的进程的优先级。",
                    examples: [
                        CommandExample(command: "renice +10 -p 1234", explanation: "降低 PID 1234 的优先级"),
                        CommandExample(command: "renice -5 -p 1234", explanation: "提高 PID 1234 的优先级"),
                        CommandExample(command: "renice +15 -u john", explanation: "降低用户 john 所有进程优先级"),
                        CommandExample(command: "sudo renice -20 -p 1234", explanation: "以 root 设置最高优先级"),
                        CommandExample(command: "renice 0 -p 1234", explanation: "重置为默认优先级")
                    ],
                    commonOptions: [
                        (flag: "-n priority", description: "设置新的优先级值"),
                        (flag: "-p", description: "指定进程 ID（默认）"),
                        (flag: "-u", description: "指定用户名（该用户所有进程）"),
                        (flag: "-g", description: "指定进程组 ID")
                    ],
                    tips: "提高优先级(负值)需要 root 权限，降低优先级(正值)不需要"
                )
            ]
        ),

// MARK: - 网络工具

        CommandCategory(
            name: "网络工具",
            icon: "network",
            commands: [
                CommandItem(
                    name: "ping",
                    syntax: "ping [-aAbDdfHnoQqRrv] [-c count] [-i wait] [-l preload] [-m mark] [-M mtu | hint] [-p pattern] [-Q tos] [-s packetsize] [-S src_addr] [-t ttl] [-W waittime] [-G addr] [-I addr | interface] host",
                    description: "向网络主机发送 ICMP ECHO_REQUEST 数据包测试连通性。",
                    examples: [
                        CommandExample(command: "ping google.com", explanation: "持续 ping（Ctrl+C 停止）"),
                        CommandExample(command: "ping -c 4 8.8.8.8", explanation: "只 ping 4 次"),
                        CommandExample(command: "ping -i 2 host", explanation: "每 2 秒 ping 一次"),
                        CommandExample(command: "ping -s 1400 host", explanation: "发送 1400 字节数据包（测试 MTU）"),
                        CommandExample(command: "ping -t 5 host", explanation: "设置 TTL 为 5")
                    ],
                    commonOptions: [
                        (flag: "-c count", description: "指定发送的数据包数量"),
                        (flag: "-i wait", description: "指定发送间隔（秒）"),
                        (flag: "-s packetsize", description: "指定数据包大小（字节，默认56+8=64）"),
                        (flag: "-t ttl", description: "设置 TTL 生存时间"),
                        (flag: "-W waittime", description: "等待响应的超时时间（毫秒）"),
                        (flag: "-D", description: "显示选定接口的调试信息"),
                        (flag: "-f", description: "洪水 ping（需 root，快速发包）"),
                        (flag: "-o", description: "收到回复后退出"),
                        (flag: "-q", description: "静默模式（只显示摘要）"),
                        (flag: "-v", description: "详细输出"),
                        (flag: "-a", description: "对每个回复发出声音提示"),
                        (flag: "-n", description: "不解析主机名"),
                        (flag: "-R", description: "记录路由（traceroute 功能）"),
                        (flag: "-I addr", description: "指定源 IP 地址或接口")
                    ],
                    tips: "Ctrl+C 停止，-c 限定次数，-s 测试 MTU（1472+28=1500）"
                ),
                CommandItem(
                    name: "curl",
                    syntax: "curl [-89aAbbcCdeEgGhHijkLmMopqRsSuvwW] [--anyauth] [--basic] [--compressed] [--connect-timeout seconds] [--data-ascii data] [--data-binary data] [-d data] [--digest] [-D file] [--data-urlencode data] [-E cert:key] [-f] [-F form_data] [--unix-socket path] [-g] [-G] [--head] [-H header] [-i] [-I] [--include] [-j key] [-k] [--keepalive-time seconds] [--key key] [-K config] [-l] [-L] [--limit-rate rate] [--local-port range] [-m seconds] [--max-filesize bytes] [--max-redirs num] [-M] [-N] [-n] [--negotiate] [-o output] [--oauth method] [-O] [--pass phrase] [--post301] [--post302] [--post303] [--proto proto] [--pubkey key] [-q] [-Q cmd] [-r range] [--random-file file] [--raw] [-R] [--retry num] [--retry-delay seconds] [-s] [-S] [--ssl] [--ssl-allow-beast] [--ssl-no-revoke] [--ssl-reqd] [--ssl-revoke-best-effort] [--stderr file] [--styled-output] [--suppress-connect-headers] [-t target] [--tcp-fastopen] [--tcp-nodelay] [-T file] [--telnet-opt option] [-t] [--tftp-blksize value] [-u user:password] [-U user] [--url url] [--unix-socket path] [-v] [-V] [-w format] [-x proxy[:port]] [-X request] [--xml request] [-y time-condition] [-Y speed-limit] [-z time] URL...",
                    description: "强大的 URL 数据传输工具，支持 HTTP/HTTPS/FTP/SCP/SFTP/DICT/FILE/GOPHER/IMAP/LDAP/POP3/RTSP/SMTP/TELNET/TFTP 等协议。",
                    examples: [
                        CommandExample(command: "curl https://api.github.com", explanation: "获取 URL 内容"),
                        CommandExample(command: "curl -o file.zip https://example.com/file.zip", explanation: "下载并指定文件名"),
                        CommandExample(command: "curl -O https://example.com/file.zip", explanation: "下载（保持原文件名）"),
                        CommandExample(command: "curl -I https://example.com", explanation: "只获取 HTTP 响应头"),
                        CommandExample(command: "curl -X POST -d 'name=test' https://api.example.com", explanation: "发送 POST 请求"),
                        CommandExample(command: "curl -H 'Authorization: Bearer token' URL", explanation: "带自定义请求头"),
                        CommandExample(command: "curl -L https://example.com", explanation: "跟随重定向"),
                        CommandExample(command: "curl -u user:pass https://api.example.com", explanation: "HTTP 基本认证"),
                        CommandExample(command: "curl -F 'file=@photo.jpg' https://upload.example.com", explanation: "上传文件"),
                        CommandExample(command: "curl -s -o /dev/null -w '%{http_code}' URL", explanation: "只输出 HTTP 状态码")
                    ],
                    commonOptions: [
                        (flag: "-o file", description: "将输出保存到指定文件"),
                        (flag: "-O", description: "以远程文件名保存到本地"),
                        (flag: "-I / --head", description: "只获取 HTTP 响应头"),
                        (flag: "-X method", description: "指定 HTTP 方法 (GET/POST/PUT/DELETE/PATCH)"),
                        (flag: "-d data", description: "发送 POST 请求数据（-d 自动设为 POST）"),
                        (flag: "--data-urlencode data", description: "URL 编码后发送数据"),
                        (flag: "--data-binary data", description: "发送二进制 POST 数据"),
                        (flag: "-H header", description: "添加自定义请求头"),
                        (flag: "-L", description: "跟随 HTTP 重定向"),
                        (flag: "-u user:pass", description: "HTTP 基本认证"),
                        (flag: "-F name=@file", description: "上传文件（multipart/form-data）"),
                        (flag: "-v", description: "显示详细请求/响应过程"),
                        (flag: "-s", description: "静默模式（不显示进度条和错误）"),
                        (flag: "-S", description: "配合 -s 显示错误信息"),
                        (flag: "-k / --insecure", description: "忽略 SSL 证书验证"),
                        (flag: "--connect-timeout seconds", description: "连接超时时间"),
                        (flag: "-m seconds", description: "最大请求时间"),
                        (flag: "-A agent", description: "设置 User-Agent"),
                        (flag: "-b cookie", description: "发送 Cookie"),
                        (flag: "-c cookiefile", description: "保存 Cookie 到文件"),
                        (flag: "-e url", description: "设置 Referer"),
                        (flag: "-G", description: "将 -d 数据转为 URL 查询参数"),
                        (flag: "-w format", description: "自定义输出格式"),
                        (flag: "--compressed", description: "请求压缩响应（gzip/deflate）"),
                        (flag: "--cert key:cert", description: "客户端证书"),
                        (flag: "-r range", description: "HTTP Range 请求（断点续传）"),
                        (flag: "--retry num", description: "失败重试次数")
                    ],
                    tips: "-o 保存 -I 查头 -L 跟重定向 -u 认证 -s 静默 -w 自定义输出"
                ),
                CommandItem(
                    name: "ifconfig",
                    syntax: "ifconfig [-aL] [-b broadcast] [-C] [-d] [-m] [-M pathmtu] [-n] [-r] [-s] [[-v] [-C] [-媒体 type] [-lladdr addr] [-priority prec] [-vlandh tag] [-vlanmtu mtu] [-vlanpriority prec] [-vlanh tag] [-vlantci tci] [-tstall] [-arp] [-redirect] [-ip6addrs] [-ip6mtu] [-ip6tlladdr] [-rtradv] [-mrouting] [-discov] [-rff] [-autoconf] [-preferred_lifetime] [-default_lifetime] [-nud] [-faith] [-trusted] [-carp] [-vlans] [-bond] [-bondif] [-vlanh tag]] [-mtu value] [-txqueuelen length] [-fragmented] [-monitor] [-power] [-static_ssdp] interface [address [dest_addr]] [netmask mask] [media type]",
                    description: "查看和配置网络接口。",
                    examples: [
                        CommandExample(command: "ifconfig", explanation: "显示所有网络接口信息"),
                        CommandExample(command: "ifconfig en0", explanation: "显示指定网络接口"),
                        CommandExample(command: "ifconfig en0 | grep ether", explanation: "获取 MAC 地址"),
                        CommandExample(command: "ifconfig en0 up", explanation: "启用网络接口"),
                        CommandExample(command: "ifconfig en0 inet 192.168.1.100 netmask 255.255.255.0", explanation: "设置静态 IP"),
                        CommandExample(command: "ifconfig en0 -arp", explanation: "禁用 ARP")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有接口（包括未激活的）"),
                        (flag: "-L", description: "显示接口的丢包计数器"),
                        (flag: "up", description: "启用接口"),
                        (flag: "down", description: "禁用接口"),
                        (flag: "inet addr", description: "设置 IPv4 地址"),
                        (flag: "netmask mask", description: "设置子网掩码"),
                        (flag: "broadcast addr", description: "设置广播地址"),
                        (flag: "media type", description: "设置介质类型 (autoselect/100baseTX)"),
                        (flag: "mtu N", description: "设置 MTU 大小"),
                        (flag: "ether addr", description: "设置 MAC 地址"),
                        (flag: "-arp", description: "禁用 ARP 协议"),
                        (flag: "alias", description: "添加接口的第二个 IP 地址"),
                        (flag: "-alias", description: "移除接口的别名地址"),
                        (flag: "-v", description: "详细输出")
                    ],
                    tips: "en0 通常是 Wi-Fi，en1 通常是有线网络"
                ),
                CommandItem(
                    name: "netstat",
                    syntax: "netstat [-AaCdeFgHhimnNoprsuUvWx] [-f address_family] [-p protocol] [-s]",
                    description: "显示网络连接、路由表、接口统计等网络信息。",
                    examples: [
                        CommandExample(command: "netstat -an", explanation: "显示所有连接和监听端口"),
                        CommandExample(command: "netstat -an | grep LISTEN", explanation: "只显示监听中的端口"),
                        CommandExample(command: "netstat -r", explanation: "显示路由表"),
                        CommandExample(command: "netstat -i", explanation: "显示网络接口统计"),
                        CommandExample(command: "netstat -m", explanation: "显示内存使用统计"),
                        CommandExample(command: "netstat -s", explanation: "显示各协议统计汇总"),
                        CommandExample(command: "netstat -anp tcp", explanation: "显示所有 TCP 连接")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有连接（包括监听和非监听）"),
                        (flag: "-n", description: "以数字形式显示地址和端口（不解析）"),
                        (flag: "-r", description: "显示路由表"),
                        (flag: "-i", description: "显示网络接口统计信息"),
                        (flag: "-s", description: "显示各协议统计汇总"),
                        (flag: "-m", description: "显示内存使用统计"),
                        (flag: "-o", description: "显示定时器信息"),
                        (flag: "-p protocol", description: "按协议筛选 (tcp/udp)"),
                        (flag: "-f type", description: "按地址族筛选 (inet/inet6/unix)"),
                        (flag: "-l", description: "只显示监听状态的 socket"),
                        (flag: "-P", description: "显示进程 PID/名称（需 root）"),
                        (flag: "-u", description: "只显示 UDP"),
                        (flag: "-w", description: "显示原始 socket 信息"),
                        (flag: "-A", description: "显示所有 socket 地址")
                    ],
                    tips: "-an 最常用，-an | grep LISTEN 查看开放端口"
                ),
                CommandItem(
                    name: "ssh",
                    syntax: "ssh [-1246AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address] [-c cipher_spec] [-D [bind_address:]port] [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file] [-J [user@]host[:port]] [-L address] [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port] [-Q query_option] [-R address] [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]] [user@]hostname [command]",
                    description: "安全远程登录到另一台计算机（SSH 客户端）。",
                    examples: [
                        CommandExample(command: "ssh user@192.168.1.100", explanation: "SSH 登录远程主机"),
                        CommandExample(command: "ssh -p 2222 user@host", explanation: "指定端口连接"),
                        CommandExample(command: "ssh -i ~/.ssh/key.pem user@host", explanation: "使用指定密钥登录"),
                        CommandExample(command: "ssh -L 8080:localhost:80 user@host", explanation: "本地端口转发"),
                        CommandExample(command: "ssh -R 8080:localhost:80 user@host", explanation: "远程端口转发"),
                        CommandExample(command: "ssh -D 1080 user@host", explanation: "SOCKS 代理"),
                        CommandExample(command: "ssh -t user@host 'top'", explanation: "分配伪终端执行命令"),
                        CommandExample(command: "ssh -fNL 8080:localhost:80 user@host", explanation: "后台执行端口转发")
                    ],
                    commonOptions: [
                        (flag: "-p port", description: "指定连接端口（默认 22）"),
                        (flag: "-i file", description: "指定身份验证的密钥文件"),
                        (flag: "-l user", description: "指定登录用户名"),
                        (flag: "-L [bind:]port:host:hostport", description: "本地端口转发"),
                        (flag: "-R [bind:]port:host:hostport", description: "远程端口转发"),
                        (flag: "-D [bind:]port", description: "SOCKS4/5 本地代理"),
                        (flag: "-J user@host[:port]", description: "跳板机代理 (ProxyJump)"),
                        (flag: "-t", description: "分配伪终端（交互命令必须）"),
                        (flag: "-T", description: "不分配伪终端"),
                        (flag: "-f", description: "认证后转入后台（配合转发使用）"),
                        (flag: "-N", description: "不执行远程命令（仅转发）"),
                        (flag: "-C", description: "启用压缩传输"),
                        (flag: "-v", description: "显示详细调试信息"),
                        (flag: "-V", description: "显示版本信息"),
                        (flag: "-o option", description: "指定配置选项"),
                        (flag: "-e char", description: "指定转义字符"),
                        (flag: "-X", description: "启用 X11 转发"),
                        (flag: "-Y", description: "启用可信 X11 转发"),
                        (flag: "-A", description: "启用 Agent 转发"),
                        (flag: "-1", description: "强制使用 SSHv1"),
                        (flag: "-2", description: "强制使用 SSHv2"),
                        (flag: "-c cipher", description: "指定加密算法")
                    ],
                    tips: "-p 端口 -i 密钥 -L本地转发 -R远程转发 -J跳板机 -fN后台转发"
                ),
                CommandItem(
                    name: "scp",
                    syntax: "scp [-346BCpqrTv] [-c cipher] [-F ssh_config] [-i identity_file] [-J destination] [-l limit] [-o ssh_option] [-P port] [-S program] source target",
                    description: "通过 SSH 安全地复制文件到远程主机。",
                    examples: [
                        CommandExample(command: "scp file.txt user@host:/path/", explanation: "上传文件到远程"),
                        CommandExample(command: "scp user@host:/remote/file.txt .", explanation: "从远程下载文件"),
                        CommandExample(command: "scp -r dir/ user@host:/path/", explanation: "递归复制整个目录"),
                        CommandExample(command: "scp -P 2222 file.txt user@host:/path/", explanation: "指定端口传输"),
                        CommandExample(command: "scp -C -l 1000 large_file user@host:/path/", explanation: "压缩传输，限速 1000KB/s"),
                        CommandExample(command: "scp -3 host1:/file host2:/path/", explanation: "两台远程主机间复制（经本机中转）")
                    ],
                    commonOptions: [
                        (flag: "-r", description: "递归复制整个目录"),
                        (flag: "-P port", description: "指定 SSH 端口（注意大写）"),
                        (flag: "-C", description: "启用压缩传输"),
                        (flag: "-i file", description: "指定密钥文件"),
                        (flag: "-l limit", description: "限速（Kbit/s）"),
                        (flag: "-p", description: "保留文件权限和时间戳"),
                        (flag: "-q", description: "静默模式（不显示进度）"),
                        (flag: "-v", description: "显示调试信息"),
                        (flag: "-3", description: "经本机中转在两个远程间复制"),
                        (flag: "-B", description: "批处理模式（非交互式）"),
                        (flag: "-o opt", description: "传递 SSH 选项")
                    ],
                    tips: "-P 端口（大写），-r 递归，-C 压缩，-l 限速"
                ),
                CommandItem(
                    name: "rsync",
                    syntax: "rsync [-خيارات] source destination\n     rsync [-خيارات] source ... destination_dir",
                    description: "高效的文件同步工具，使用 delta-transfer 算法只传输差异部分。",
                    examples: [
                        CommandExample(command: "rsync -avz src/ user@host:/dest/", explanation: "同步到远程（压缩+归档）"),
                        CommandExample(command: "rsync -avz --delete src/ dest/", explanation: "同步并删除目标多余文件"),
                        CommandExample(command: "rsync -avzP large_file user@host:/path/", explanation: "显示进度+断点续传"),
                        CommandExample(command: "rsync -avz --exclude='.git' src/ dest/", explanation: "排除 .git 目录同步"),
                        CommandExample(command: "rsync -avz --progress src/ dest/", explanation: "显示详细传输进度")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "归档模式（-rlptgoD，保留所有属性）"),
                        (flag: "-v", description: "显示详细传输信息"),
                        (flag: "-z", description: "传输时压缩数据"),
                        (flag: "-P", description: "显示进度 + 支持断点续传"),
                        (flag: "--progress", description: "显示传输进度"),
                        (flag: "--delete", description: "删除目标中源没有的文件"),
                        (flag: "--exclude pattern", description: "排除匹配的文件/目录"),
                        (flag: "--include pattern", description: "包含匹配的文件/目录"),
                        (flag: "--exclude-from=file", description: "从文件读取排除规则"),
                        (flag: "-n / --dry-run", description: "模拟运行，不实际传输"),
                        (flag: "--stats", description: "显示传输统计信息"),
                        (flag: "-e ssh", description: "指定远程 shell（默认 ssh）"),
                        (flag: "--bwlimit=KB/s", description: "限速传输"),
                        (flag: "-r", description: "递归目录（-a 包含此选项）"),
                        (flag: "-l", description: "复制符号链接（-a 包含此选项）"),
                        (flag: "-p", description: "保留权限（-a 包含此选项）"),
                        (flag: "-t", description: "保留修改时间（-a 包含此选项）"),
                        (flag: "-o", description: "保留所有者（-a 包含此选项）"),
                        (flag: "-g", description: "保留组（-a 包含此选项）"),
                        (flag: "-D", description: "保留设备文件和特殊文件（-a 包含此选项）")
                    ],
                    tips: "-avzP 最常用组合，--exclude 排除文件，--dry-run 先模拟"
                ),
                CommandItem(
                    name: "dig",
                    syntax: "dig [@server] [-b address] [-c class] [-f filename] [-k filename] [-m] [-p port#] [-q name] [-t type] [-v] [-x addr] [-y [hmac:]name:key] [-4] [-6] [name] [type] [class] [queryopt...]",
                    description: "DNS 查询工具。支持所有 DNS 记录类型查询。",
                    examples: [
                        CommandExample(command: "dig example.com", explanation: "查询 A 记录"),
                        CommandExample(command: "dig +short example.com", explanation: "只显示简洁结果"),
                        CommandExample(command: "dig @8.8.8.8 example.com", explanation: "使用 Google DNS 查询"),
                        CommandExample(command: "dig example.com MX", explanation: "查询邮件服务器记录"),
                        CommandExample(command: "dig example.com ANY", explanation: "查询所有记录类型"),
                        CommandExample(command: "dig -x 8.8.8.8", explanation: "反向 DNS 查询"),
                        CommandExample(command: "dig example.com +trace", explanation: "追踪完整 DNS 解析路径"),
                        CommandExample(command: "dig example.com AAAA", explanation: "查询 IPv6 地址")
                    ],
                    commonOptions: [
                        (flag: "@server", description: "指定 DNS 服务器"),
                        (flag: "+short", description: "只显示简洁结果（仅 IP）"),
                        (flag: "+noall +answer", description: "只显示答案段"),
                        (flag: "+trace", description: "追踪从根服务器开始的解析路径"),
                        (flag: "+stats", description: "显示查询统计信息"),
                        (flag: "+nocmd +nocl +noques +noans +nostat", description: "不显示各段信息"),
                        (flag: "-x addr", description: "反向查询（IP → 域名）"),
                        (flag: "-p port", description: "指定查询端口"),
                        (flag: "-t type", description: "指定查询类型"),
                        (flag: "-f file", description: "从文件批量读取查询"),
                        (flag: "-4 / -6", description: "强制使用 IPv4/IPv6"),
                        (flag: "A", description: "查询 IPv4 地址"),
                        (flag: "AAAA", description: "查询 IPv6 地址"),
                        (flag: "MX", description: "查询邮件服务器"),
                        (flag: "CNAME", description: "查询别名记录"),
                        (flag: "NS", description: "查询域名服务器"),
                        (flag: "TXT", description: "查询文本记录"),
                        (flag: "SOA", description: "查询权威记录"),
                        (flag: "PTR", description: "查询反向解析记录"),
                        (flag: "ANY", description: "查询所有类型")
                    ],
                    tips: "+short 最常用，+trace 看完整解析链，ANY 查所有记录"
                ),
                CommandItem(
                    name: "nslookup",
                    syntax: "nslookup [-option] [name | -] [server]",
                    description: "简单的 DNS 查询工具（交互式和非交互式两种模式）。",
                    examples: [
                        CommandExample(command: "nslookup example.com", explanation: "查询域名的 IP"),
                        CommandExample(command: "nslookup example.com 8.8.8.8", explanation: "使用指定 DNS 查询"),
                        CommandExample(command: "nslookup -type=MX example.com", explanation: "查询邮件服务器"),
                        CommandExample(command: "nslookup -type=TXT example.com", explanation: "查询 TXT 记录"),
                        CommandExample(command: "nslookup -type=NS example.com", explanation: "查询域名服务器")
                    ],
                    commonOptions: [
                        (flag: "-type=A", description: "查询 A 记录（IPv4 地址）"),
                        (flag: "-type=AAAA", description: "查询 AAAA 记录（IPv6 地址）"),
                        (flag: "-type=MX", description: "查询邮件服务器"),
                        (flag: "-type=CNAME", description: "查询别名记录"),
                        (flag: "-type=NS", description: "查询域名服务器"),
                        (flag: "-type=TXT", description: "查询文本记录"),
                        (flag: "-type=SOA", description: "查询 SOA 记录"),
                        (flag: "-type=PTR", description: "查询反向解析"),
                        (flag: "-type=ANY", description: "查询所有类型"),
                        (flag: "-debug", description: "显示调试信息"),
                        (flag: "-timeout=N", description: "设置超时时间（秒）")
                    ],
                    tips: "-type 指定记录类型，比 dig 更简单适合快速查询"
                ),
                CommandItem(
                    name: "nc",
                    syntax: "nc [-46EenrtUuvz] [-I length] [-i interval] [-O length] [-o source-port] [-s source-ip-address | -p source-port] [-T tos] [-w timeout] [-X proxy_protocol] [-x proxy_address[:port]] [hostname] [port[s]]",
                    description: "netcat — 网络瑞士军刀。读写网络连接（TCP/UDP）。",
                    examples: [
                        CommandExample(command: "nc -zv example.com 80", explanation: "测试端口是否开放"),
                        CommandExample(command: "nc -zv example.com 20-100", explanation: "扫描端口范围 20-100"),
                        CommandExample(command: "nc -l 1234", explanation: "监听本地 1234 端口"),
                        CommandExample(command: "echo 'hello' | nc example.com 1234", explanation: "发送数据到远程端口"),
                        CommandExample(command: "nc -u example.com 53", explanation: "UDP 模式连接"),
                        CommandExample(command: "nc -v -l 8080 < response.html", explanation: "监听并返回文件内容（简易HTTP服务器）")
                    ],
                    commonOptions: [
                        (flag: "-z", description: "扫描模式（不发送数据，只检测端口）"),
                        (flag: "-v", description: "详细输出"),
                        (flag: "-l", description: "监听模式（服务端）"),
                        (flag: "-p port", description: "指定源端口"),
                        (flag: "-s addr", description: "指定源 IP 地址"),
                        (flag: "-u", description: "使用 UDP（默认 TCP）"),
                        (flag: "-w seconds", description: "连接/空闲超时"),
                        (flag: "-n", description: "不解析主机名"),
                        (flag: "-4 / -6", description: "强制 IPv4/IPv6"),
                        (flag: "-r", description: "随机化本地和远程端口"),
                        (flag: "-i interval", description: "扫描间隔"),
                        (flag: "-T tos", description: "设置服务类型")
                    ],
                    tips: "-zv 端口扫描，-l 监听，-u UDP 模式，网络调试利器"
                ),
                CommandItem(
                    name: "traceroute",
                    syntax: "traceroute [-AdDdvIMmNnrU] [-f first_ttl] [-g gateway] [-I] [-i interface] [-l] [-m max_ttl] [-p port] [-q nqueries] [-s src_addr] [-t tos] [-w waittime] host",
                    description: "追踪数据包到达目标主机所经过的路由路径。",
                    examples: [
                        CommandExample(command: "traceroute google.com", explanation: "追踪到 Google 的路由"),
                        CommandExample(command: "traceroute -m 20 host", explanation: "最多跳 20 路由"),
                        CommandExample(command: "traceroute -I host", explanation: "使用 ICMP 探测（而非UDP）"),
                        CommandExample(command: "traceroute -p 80 -T host", explanation: "使用 TCP 80 端口探测"),
                        CommandExample(command: "traceroute -n host", explanation: "不解析主机名（加速）")
                    ],
                    commonOptions: [
                        (flag: "-m max_ttl", description: "最大跳数（默认 30）"),
                        (flag: "-n", description: "不解析主机名（加速）"),
                        (flag: "-w waittime", description: "等待响应超时（秒）"),
                        (flag: "-I", description: "使用 ICMP Echo 替代 UDP"),
                        (flag: "-T", description: "使用 TCP SYN 探测"),
                        (flag: "-p port", description: "指定目标端口"),
                        (flag: "-q nqueries", description: "每跳发送的探测数（默认 3）"),
                        (flag: "-s addr", description: "指定源 IP 地址"),
                        (flag: "-f first_ttl", description: "起始 TTL"),
                        (flag: "-d", description: "调试模式")
                    ],
                    tips: "-n 加速，-I 用 ICMP，-m 控制最大跳数"
                ),
                CommandItem(
                    name: "wget",
                    syntax: "wget [-bcdehHknNpqRSsUvV] [-a log] [-A list] [-B URL] [-C file] [-E ext] [-F] [-I dirs] [-l level] [--limit-rate=rate] [-O file] [--passive-ftp] [-P dir] [--spider] [-T sec] [-t tries] [-U agent] [-nc] [-np] URL",
                    description: "非交互式网络下载工具，支持 HTTP/HTTPS/FTP/FTPS 等协议。需 brew install wget。",
                    examples: [
                        CommandExample(command: "wget https://example.com/file.zip", explanation: "下载文件"),
                        CommandExample(command: "wget -O custom.zip https://example.com/file.zip", explanation: "指定文件名下载"),
                        CommandExample(command: "wget -c https://example.com/large.iso", explanation: "断点续传"),
                        CommandExample(command: "wget -r -np https://example.com/dir/", explanation: "递归下载整个目录"),
                        CommandExample(command: "wget -q https://example.com/file.zip", explanation: "静默下载"),
                        CommandExample(command: "wget --spider https://example.com/file.zip", explanation: "检查 URL 是否可访问"),
                        CommandExample(command: "wget -i urls.txt", explanation: "从文件读取 URL 列表下载"),
                        CommandExample(command: "wget -b https://example.com/file.zip", explanation: "后台下载（日志写入 wget-log）")
                    ],
                    commonOptions: [
                        (flag: "-O file", description: "指定输出文件名（- 为 stdout）"),
                        (flag: "-o log", description: "输出日志到文件"),
                        (flag: "-c / --continue", description: "断点续传"),
                        (flag: "-q / --quiet", description: "静默模式"),
                        (flag: "-b / --background", description: "后台运行"),
                        (flag: "-r / --recursive", description: "递归下载"),
                        (flag: "-np / --no-parent", description: "不追溯上级目录"),
                        (flag: "-nH / --no-host-directories", description: "不创建主机目录"),
                        (flag: "-nd / --no-directories", description: "不创建目录结构"),
                        (flag: "-P dir", description: "指定保存目录"),
                        (flag: "--limit-rate=rate", description: "限速（K/M/G）"),
                        (flag: "-t tries / --tries=N", description: "重试次数（0=无限）"),
                        (flag: "--spider", description: "只检查 URL 是否存在"),
                        (flag: "-T sec / --timeout=sec", description: "连接超时时间"),
                        (flag: "-U agent / --user-agent=agent", description: "设置 User-Agent"),
                        (flag: "-A list / --accept=list", description: "接受的文件类型"),
                        (flag: "-R list / --reject=list", description: "拒绝的文件类型"),
                        (flag: "-I dirs / --include-directories=dirs", description: "允许的目录"),
                        (flag: "-l depth / --level=depth", description: "递归深度"),
                        (flag: "-E ext / --adjust-extension", description: "为文件添加后缀"),
                        (flag: "-F / --force-html", description: "将非 HTML 文件作为 HTML 处理"),
                        (flag: "-i file / --input-file=file", description: "从文件读取 URL"),
                        (flag: "-nc / --no-clobber", description: "不覆盖已有文件"),
                        (flag: "-N / --timestamping", description: "只下载比本地更新的文件"),
                        (flag: "--post-data=string", description: "发送 POST 数据"),
                        (flag: "--post-file=file", description: "从文件读取 POST 数据"),
                        (flag: "--content-disposition", description: "根据 Content-Disposition 重命名"),
                        (flag: "--no-check-certificate", description: "忽略 SSL 证书验证")
                    ],
                    tips: "比 curl 更擅长递归下载和断点续传，-r -np 递归下载最常用"
                ),
                CommandItem(
                    name: "httpie",
                    syntax: "http [flags] [METHOD] URL [ITEM [ITEM ...]]",
                    description: "现代化的命令行 HTTP 客户端，语法比 curl 更友好直观。需 brew install httpie。",
                    examples: [
                        CommandExample(command: "http GET https://api.github.com", explanation: "GET 请求"),
                        CommandExample(command: "http POST api.example.com name=test email=test@example.com", explanation: "发送 JSON POST"),
                        CommandExample(command: "http --form POST upload.example.com file@photo.jpg", explanation: "上传文件"),
                        CommandExample(command: "http --auth=user:pass api.example.com", explanation: "基本认证"),
                        CommandExample(command: "http --session=mysession api.example.com", explanation: "保持会话（Cookie）"),
                        CommandExample(command: "http --download api.example.com/file.zip", explanation: "下载文件"),
                        CommandExample(command: "http --print=hHbB GET api.example.com", explanation: "显示请求和响应头+体"),
                        CommandExample(command: "http --timeout=30 GET api.example.com", explanation: "设置超时时间")
                    ],
                    commonOptions: [
                        (flag: "GET/POST/PUT/DELETE/PATCH", description: "HTTP 方法（默认 GET）"),
                        (flag: "key=value", description: "JSON 字段"),
                        (flag: "key:=value", description: "原始 JSON 值（数字/数组等）"),
                        (flag: "key@file", description: "上传文件"),
                        (flag: "key\\:string=value", description: "字符串值（非 JSON）"),
                        (flag: "--auth=user:pass", description: "基本认证"),
                        (flag: "--form", description: "multipart/form-data 表单"),
                        (flag: "--json / -j", description: "强制 JSON 模式"),
                        (flag: "--session=name", description: "命名会话（持久化 Cookie）"),
                        (flag: "--session-read-only=name", description: "只读会话"),
                        (flag: "--download", description: "下载模式"),
                        (flag: "--output=file", description: "指定输出文件"),
                        (flag: "--print=what", description: "输出内容 (h=头 b=体 H=响应头 B=响应体)"),
                        (flag: "--headers / -h", description: "显示请求头"),
                        (flag: "--body / -b", description: "显示请求体"),
                        (flag: "--verbose / -v", description: "显示完整请求和响应"),
                        (flag: "--timeout=sec", description: "超时时间"),
                        (flag: "--verify=no", description: "忽略 SSL 验证"),
                        (flag: "--proxy=protocol:url", description: "指定代理"),
                        (flag: "--max-redirects=N", description: "最大重定向次数"),
                        (flag: "--follow / -F", description: "跟随重定向"),
                        (flag: "--pretty=all|colors|format|none", description: "美化输出"),
                        (flag: "--style=monokai", description: "语法高亮风格"),
                        (flag: "-h --print=h", description: "只显示请求头"),
                        (flag: "--offline", description: "离线模式（不发送请求）"),
                        (flag: "--debug", description: "调试模式")
                    ],
                    tips: "语法直觉: http POST url key=value key:=123，--session 保持会话"
                )
            ]
        ),

// MARK: - 系统信息

        CommandCategory(
            name: "系统信息",
            icon: "info.circle",
            commands: [
                CommandItem(
                    name: "uname",
                    syntax: "uname [-amnprsw]",
                    description: "显示系统信息。",
                    examples: [
                        CommandExample(command: "uname -a", explanation: "显示所有系统信息"),
                        CommandExample(command: "uname -s", explanation: "操作系统名称 (Darwin)"),
                        CommandExample(command: "uname -m", explanation: "硬件架构 (arm64/x86_64)"),
                        CommandExample(command: "uname -r", explanation: "内核版本"),
                        CommandExample(command: "uname -n", explanation: "网络主机名")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有信息"),
                        (flag: "-s", description: "内核名称 (Darwin)"),
                        (flag: "-n", description: "网络主机名"),
                        (flag: "-r", description: "内核版本号"),
                        (flag: "-v", description: "内核版本详细信息"),
                        (flag: "-m", description: "硬件架构 (arm64/x86_64)"),
                        (flag: "-p", description: "处理器类型"),
                        (flag: "-i", description: "硬件平台"),
                        (flag: "-o", description: "操作系统名称")
                    ],
                    tips: "-a 显示所有，-m 架构，-r 内核版本"
                ),
                CommandItem(
                    name: "sw_vers",
                    syntax: "sw_vers [-productName productVersion | -buildVersion]",
                    description: "显示 macOS 版本信息。",
                    examples: [
                        CommandExample(command: "sw_vers", explanation: "显示完整版本信息"),
                        CommandExample(command: "sw_vers -productVersion", explanation: "只显示版本号 (14.0)"),
                        CommandExample(command: "sw_vers -buildVersion", explanation: "只显示构建号 (23A344)")
                    ],
                    commonOptions: [
                        (flag: "-productName", description: "只显示产品名称 (macOS)"),
                        (flag: "-productVersion", description: "只显示版本号"),
                        (flag: "-buildVersion", description: "只显示构建号")
                    ],
                    tips: "最简单的查看 macOS 版本方式"
                ),
                CommandItem(
                    name: "system_profiler",
                    syntax: "system_profiler [-listDataTypes | -listDetailDataTypes] [-timeout seconds] [-detailLevel level] [dataTypes ...]",
                    description: "显示系统硬件和软件详细信息。",
                    examples: [
                        CommandExample(command: "system_profiler SPHardwareDataType", explanation: "硬件概览"),
                        CommandExample(command: "system_profiler SPSoftwareDataType", explanation: "软件信息"),
                        CommandExample(command: "system_profiler SPUSBDataType", explanation: "USB 设备信息"),
                        CommandExample(command: "system_profiler SPNetworkDataType", explanation: "网络信息"),
                        CommandExample(command: "system_profiler SPDisplaysDataType", explanation: "显示器信息"),
                        CommandExample(command: "system_profiler -listDataTypes", explanation: "列出所有可用数据类型")
                    ],
                    commonOptions: [
                        (flag: "-listDataTypes", description: "列出所有可用数据类型"),
                        (flag: "-listDetailDataTypes", description: "列出详细数据类型"),
                        (flag: "-detailLevel level", description: "详细级别: mini/basic/full"),
                        (flag: "-timeout sec", description: "超时时间（秒）"),
                        (flag: "SPHardwareDataType", description: "硬件概览（型号/芯片/内存/序列号）"),
                        (flag: "SPSoftwareDataType", description: "软件信息（系统版本/内核）"),
                        (flag: "SPNetworkDataType", description: "网络接口和配置"),
                        (flag: "SPStorageDataType", description: "存储设备信息"),
                        (flag: "SPUSBDataType", description: "USB 设备列表"),
                        (flag: "SPDisplaysDataType", description: "显示适配器信息"),
                        (flag: "SPSerialATADataType", description: "SATA 设备信息"),
                        (flag: "SPNVMeDataType", description: "NVMe 设备信息"),
                        (flag: "SPAirPortDataType", description: "Wi-Fi 信息"),
                        (flag: "SPPowerDataType", description: "电源/电池信息")
                    ],
                    tips: "-listDataTypes 查看所有可用类型，-detailLevel full 最详细"
                ),
                CommandItem(
                    name: "sysctl",
                    syntax: "sysctl [-n] [variable[=value]] ...\n     sysctl -a [variable ...]",
                    description: "获取或设置内核状态变量。",
                    examples: [
                        CommandExample(command: "sysctl hw.ncpu", explanation: "查看 CPU 核心数"),
                        CommandExample(command: "sysctl hw.memsize", explanation: "查看总内存"),
                        CommandExample(command: "sysctl -a | grep machdep.cpu", explanation: "查看 CPU 详细信息"),
                        CommandExample(command: "sysctl -n hw.ncpu", explanation: "只输出值"),
                        CommandExample(command: "sysctl -a hw", explanation: "查看所有硬件相关变量")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有可用的内核变量"),
                        (flag: "-n", description: "只输出值（不显示变量名）"),
                        (flag: "-w", description: "修改变量值（需 root）"),
                        (flag: "hw.ncpu", description: "CPU 核心数"),
                        (flag: "hw.memsize", description: "总物理内存（字节）"),
                        (flag: "hw.model", description: "硬件型号"),
                        (flag: "machdep.cpu.brand_string", description: "CPU 型号字符串"),
                        (flag: "kern.osrelease", description: "内核版本"),
                        (flag: "kern.ostype", description: "操作系统类型"),
                        (flag: "kern.hostname", description: "主机名")
                    ],
                    tips: "-a 显示全部，-n 只输出值，hw.* 硬件，kern.* 内核"
                ),
                CommandItem(
                    name: "defaults",
                    syntax: "defaults [-currentHost | -host hostname] [command] [arguments]",
                    description: "读写 macOS 应用偏好设置（UserDefaults）。",
                    examples: [
                        CommandExample(command: "defaults read com.apple.finder", explanation: "读取 Finder 偏好设置"),
                        CommandExample(command: "defaults read com.apple.dock autohide", explanation: "查看 Dock 自动隐藏设置"),
                        CommandExample(command: "defaults write com.apple.dock autohide -bool true", explanation: "设置 Dock 自动隐藏"),
                        CommandExample(command: "defaults delete com.apple.dock autohide", explanation: "删除设置项（恢复默认）"),
                        CommandExample(command: "defaults read NSGlobalDomain", explanation: "读取全局偏好设置"),
                        CommandExample(command: "defaults domains", explanation: "列出所有偏好设置域")
                    ],
                    commonOptions: [
                        (flag: "read [domain [key]]", description: "读取域的所有或指定键的值"),
                        (flag: "write domain key value", description: "写入/修改指定键的值"),
                        (flag: "write domain dict", description: "写入整个字典"),
                        (flag: "delete domain [key]", description: "删除指定键（恢复默认）"),
                        (flag: "domains", description: "列出所有可用的域"),
                        (flag: "find domain key", description: "搜索键名"),
                        (flag: "help", description: "显示帮助"),
                        (flag: "-bool", description: "指定布尔值 (-bool YES/NO)"),
                        (flag: "-int", description: "指定整数值"),
                        (flag: "-float", description: "指定浮点值"),
                        (flag: "-string", description: "指定字符串值"),
                        (flag: "-array", description: "指定数组值"),
                        (flag: "-array-add", description: "向数组追加元素"),
                        (flag: "-dict", description: "指定字典值"),
                        (flag: "-currentHost", description: "仅限当前主机"),
                        (flag: "-host hostname", description: "指定主机")
                    ],
                    tips: "write 后需重启对应应用，delete 恢复默认，NSGlobalDomain 全局设置"
                ),
                CommandItem(
                    name: "softwareupdate",
                    syntax: "softwareupdate [-a | -i | -l | -R] [--install] [--all] [--list] [--restart] [--schedule on | off] [-d] [--product-types type] [--os-only] [--safari-only]",
                    description: "macOS 系统软件更新工具。",
                    examples: [
                        CommandExample(command: "softwareupdate -l", explanation: "列出所有可用更新"),
                        CommandExample(command: "softwareupdate -i -a", explanation: "安装所有可用更新"),
                        CommandExample(command: "softwareupdate -i 'macOS Sonoma 14.0'", explanation: "安装指定更新"),
                        CommandExample(command: "softwareupdate --list-full-installers", explanation: "列出完整安装器"),
                        CommandExample(command: "softwareupdate --schedule off", explanation: "关闭自动检查更新")
                    ],
                    commonOptions: [
                        (flag: "-l / --list", description: "列出所有可用更新"),
                        (flag: "-i / --install", description: "安装指定更新"),
                        (flag: "-a / --all", description: "安装所有更新"),
                        (flag: "-R / --restart", description: "更新后自动重启"),
                        (flag: "--list-full-installers", description: "列出可下载的完整安装器"),
                        (flag: "--install-full-installer", description: "下载并安装完整安装器"),
                        (flag: "--schedule on|off", description: "设置自动检查更新的计划"),
                        (flag: "--fetch-full-installer", description: "预下载完整安装器"),
                        (flag: "-d", description: "删除已下载的更新文件")
                    ],
                    tips: "-l 查看 -i 安装 -a 全部，--list-full-installers 查看完整安装器"
                ),
                CommandItem(
                    name: "scutil",
                    syntax: "scutil [--dns] [--proxy] [--nwi] [--wifistatus]",
                    description: "macOS 系统配置实用工具，可访问 DNS、代理、网络等系统配置。",
                    examples: [
                        CommandExample(command: "scutil --dns", explanation: "显示 DNS 配置信息"),
                        CommandExample(command: "scutil --proxy", explanation: "显示代理设置"),
                        CommandExample(command: "scutil --nwi", explanation: "显示网络接口状态"),
                        CommandExample(command: "scutil --wifistatus", explanation: "显示 Wi-Fi 连接状态")
                    ],
                    commonOptions: [
                        (flag: "--dns", description: "显示 DNS 解析器配置"),
                        (flag: "--proxy", description: "显示系统代理设置"),
                        (flag: "--nwi", description: "显示网络接口状态（IP/子网/路由）"),
                        (flag: "--wifistatus", description: "显示 Wi-Fi 连接详细信息"),
                        (flag: "-p", description: "交互式模式（输入命令）")
                    ],
                    tips: "交互模式下可输入 get /State:/Network/Global/DNS 等路径查询"
                ),
                CommandItem(
                    name: "ioreg",
                    syntax: "ioreg [-l] [-n name] [-d depth] [-c class] [-p plane] [-r] [-k key] [-w width]",
                    description: "显示 I/O Registry 树（macOS 硬件/驱动层次结构）。",
                    examples: [
                        CommandExample(command: "ioreg -l | head -50", explanation: "显示 I/O Registry（前50行）"),
                        CommandExample(command: "ioreg -c AppleSmartBattery", explanation: "查找电池信息"),
                        CommandExample(command: "ioreg -r -c IOPlatformExpertDevice", explanation: "显示平台信息（型号等）"),
                        CommandExample(command: "ioreg -l -w0 | grep USB", explanation: "查找 USB 设备信息")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "显示所有属性（包括无值的）"),
                        (flag: "-d depth", description: "限制显示深度"),
                        (flag: "-c class", description: "只显示指定类的条目"),
                        (flag: "-n name", description: "只显示指定名称的条目"),
                        (flag: "-r", description: "只显示注册表条目"),
                        (flag: "-k key", description: "只显示包含指定键的条目"),
                        (flag: "-p plane", description: "指定平面 (IOService/IORegistry)"),
                        (flag: "-w width", description: "设置缩进宽度"),
                        (flag: "-t", description: "显示时间戳")
                    ],
                    tips: "-c AppleSmartBattery 查电池，-l | grep 过滤查找"
                ),
                CommandItem(
                    name: "pmset",
                    syntax: "pmset [-a | -b | -c] [setting value]\n     pmset [-g | -m | -p]\n     pmset schedule [cancel | create | repeat] ...",
                    description: "macOS 电源管理设置工具。",
                    examples: [
                        CommandExample(command: "pmset -g", explanation: "显示当前电源设置"),
                        CommandExample(command: "pmset -g sched", explanation: "显示计划的唤醒/睡眠事件"),
                        CommandExample(command: "pmset -a displaysleep 15", explanation: "设置所有模式显示器休眠时间"),
                        CommandExample(command: "pmset -b sleep 10", explanation: "设置电池模式休眠时间"),
                        CommandExample(command: "pmset -c sleep 0", explanation: "设置接电源时不自动休眠")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "同时设置电池和接电源模式"),
                        (flag: "-b", description: "只设置电池模式"),
                        (flag: "-c", description: "只设置接电源模式"),
                        (flag: "-g", description: "显示当前设置"),
                        (flag: "-g sched", description: "显示计划事件"),
                        (flag: "displaysleep N", description: "显示器休眠时间（分钟，0=禁用）"),
                        (flag: "sleep N", description: "系统休眠时间（分钟，0=禁用）"),
                        (flag: "disksleep N", description: "磁盘休眠时间"),
                        (flag: "womp 0|1", description: "Wake on Magic Packet (网络唤醒)"),
                        (flag: "autopoweroff 0|1", description: "自动深度休眠"),
                        (flag: "hibernatemode N", description: "休眠模式 (0/3/25)"),
                        (flag: "schedule cancel|create", description: "管理计划的唤醒/关机事件")
                    ],
                    tips: "-g 查看设置 -a/-b/-c 选择模式，0=禁用自动休眠"
                ),
                CommandItem(
                    name: "uptime",
                    syntax: "uptime",
                    description: "显示系统运行时间和当前负载平均值。",
                    examples: [
                        CommandExample(command: "uptime", explanation: "显示运行时间和负载"),
                        CommandExample(command: "uptime | sed 's/.*up /up /'", explanation: "只显示运行时间")
                    ],
                    commonOptions: [],
                    tips: "load average: 1分钟/5分钟/15分钟 平均活跃进程数"
                ),
                CommandItem(
                    name: "w",
                    syntax: "w [-fhlsu] [user]",
                    description: "显示当前登录用户及其正在执行的进程。",
                    examples: [
                        CommandExample(command: "w", explanation: "显示所有登录用户"),
                        CommandExample(command: "w john", explanation: "显示用户 john 的信息"),
                        CommandExample(command: "w -s", explanation: "简洁格式（无主机名和登录时间）"),
                        CommandExample(command: "w -f", explanation: "不显示 FROM（远程主机）列")
                    ],
                    commonOptions: [
                        (flag: "-f", description: "不显示远程主机名/来源"),
                        (flag: "-h", description: "不显示标题栏"),
                        (flag: "-l", description: "详细格式（默认）"),
                        (flag: "-s", description: "简洁格式（无 JCPU/PCPU）"),
                        (flag: "-u", description: "忽略用户名进行排序")
                    ],
                    tips: "比 who 更详细，显示用户正在执行的命令"
                ),
                CommandItem(
                    name: "who",
                    syntax: "who [-abdHlmpqrstTu] [file]",
                    description: "显示当前登录的用户信息。",
                    examples: [
                        CommandExample(command: "who", explanation: "显示当前登录用户"),
                        CommandExample(command: "who -a", explanation: "显示所有信息"),
                        CommandExample(command: "who -b", explanation: "显示上次重启时间"),
                        CommandExample(command: "who -H", explanation: "显示标题栏"),
                        CommandExample(command: "who -T", explanation: "显示终端写权限（+=-）"),
                        CommandExample(command: "who am i", explanation: "显示当前终端的用户信息")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有信息"),
                        (flag: "-b", description: "显示上次系统启动时间"),
                        (flag: "-d", description: "显示死进程"),
                        (flag: "-H", description: "显示标题栏"),
                        (flag: "-l", description: "显示系统登录进程"),
                        (flag: "-m", description: "只显示当前终端"),
                        (flag: "-p", description: "显示活跃进程"),
                        (flag: "-q", description: "快速模式（只显示用户名和数量）"),
                        (flag: "-r", description: "显示当前运行级别"),
                        (flag: "-s", description: "只显示用户名、终端、时间"),
                        (flag: "-T", description: "显示终端写权限"),
                        (flag: "-u", description: "显示空闲时间"),
                        (flag: "file", description: "从文件读取（默认 /var/run/utmp）")
                    ],
                    tips: "who am i 显示当前终端，-b 显示重启时间"
                ),
                CommandItem(
                    name: "groups",
                    syntax: "groups [user ...]",
                    description: "显示用户所属的组。",
                    examples: [
                        CommandExample(command: "groups", explanation: "显示当前用户所属的组"),
                        CommandExample(command: "groups john", explanation: "显示用户 john 所属的组"),
                        CommandExample(command: "groups root", explanation: "显示 root 所属的组")
                    ],
                    commonOptions: [],
                    tips: "简单命令，显示用户的所有组成员身份"
                ),
                CommandItem(
                    name: "last",
                    syntax: "last [-adFfIoRtwx] [-n num] [-s sec] [-t tty] [-p pid] [-L limit] [user ...]",
                    description: "显示用户登录历史记录（从 /var/log/wtmp 读取）。",
                    examples: [
                        CommandExample(command: "last", explanation: "显示最近登录记录"),
                        CommandExample(command: "last -10", explanation: "显示最近 10 条记录"),
                        CommandExample(command: "last -a", explanation: "在最后一列显示主机名"),
                        CommandExample(command: "last john", explanation: "只显示用户 john 的记录"),
                        CommandExample(command: "last -t ttys000", explanation: "只显示指定终端的记录"),
                        CommandExample(command: "last -x", explanation: "显示关机和重启记录")
                    ],
                    commonOptions: [
                        (flag: "-n num / -L limit", description: "显示最近 N 条记录"),
                        (flag: "-a", description: "在最后一列显示主机名"),
                        (flag: "-d", description: "将 IP 地址转换为主机名"),
                        (flag: "-f file", description: "指定读取的文件（默认 /var/log/wtmp）"),
                        (flag: "-F", description: "显示完整登录和注销时间"),
                        (flag: "-i", description: "显示 IP 地址而非主机名"),
                        (flag: "-o", description: "读取旧格式的 wtmp 文件"),
                        (flag: "-R", description: "不显示主机名字段"),
                        (flag: "-t tty", description: "只显示指定终端"),
                        (flag: "-w", description: "宽输出（显示完整信息）"),
                        (flag: "-x", description: "显示关机和系统级别事件")
                    ],
                    tips: "last -10 最近10条，last john 用户记录，-x 含关机记录"
                ),
                CommandItem(
                    name: "spctl",
                    syntax: "spctl [--assess] [--add] [--remove] [--enable | --disable] [--label label] [--status] [file ...]",
                    description: "macOS 安全评估和 Gatekeeper 控制工具。",
                    examples: [
                        CommandExample(command: "spctl --status", explanation: "查看 Gatekeeper 状态"),
                        CommandExample(command: "sudo spctl --master-disable", explanation: "关闭 Gatekeeper"),
                        CommandExample(command: "sudo spctl --master-enable", explanation: "开启 Gatekeeper"),
                        CommandExample(command: "spctl --assess --verbose /Applications/App.app", explanation: "评估应用是否被允许"),
                        CommandExample(command: "spctl --add --label 'MyLabel' /path/to/app", explanation: "添加自定义标签"),
                        CommandExample(command: "spctl --remove --label 'MyLabel'", explanation: "移除自定义标签")
                    ],
                    commonOptions: [
                        (flag: "--status", description: "显示 Gatekeeper 状态"),
                        (flag: "--master-enable", description: "开启 Gatekeeper"),
                        (flag: "--master-disable", description: "关闭 Gatekeeper（需 sudo）"),
                        (flag: "--assess", description: "评估文件是否被允许运行"),
                        (flag: "--verbose", description: "详细输出评估结果"),
                        (flag: "--add --label label", description: "添加评估规则"),
                        (flag: "--remove --label label", description: "移除评估规则"),
                        (flag: "--label label", description: "按标签筛选规则")
                    ],
                    tips: "--status 查看状态，--master-disable 关闭 Gatekeeper"
                ),
                CommandItem(
                    name: "mdls",
                    syntax: "mdls [-name attr] file ...",
                    description: "显示文件的 Spotlight 元数据（扩展属性）。",
                    examples: [
                        CommandExample(command: "mdls photo.jpg", explanation: "显示图片所有元数据"),
                        CommandExample(command: "mdls -name kMDItemDisplayName file.txt", explanation: "只显示指定属性"),
                        CommandExample(command: "mdls -name kMDItemFSName file.txt", explanation: "显示文件名"),
                        CommandExample(command: "mdls -name kMDItemContentCreationDate photo.jpg", explanation: "显示创建日期"),
                        CommandExample(command: "mdls -name kMDItemContentType photo.jpg", explanation: "显示 MIME 类型")
                    ],
                    commonOptions: [
                        (flag: "-name attr", description: "只显示指定的属性值"),
                        (flag: "kMDItemDisplayName", description: "显示名称"),
                        (flag: "kMDItemFSName", description: "文件系统名称"),
                        (flag: "kMDItemKind", description: "文件类型描述"),
                        (flag: "kMDItemContentType", description: "UTI 类型"),
                        (flag: "kMDItemContentCreationDate", description: "创建日期"),
                        (flag: "kMDItemContentModificationDate", description: "修改日期"),
                        (flag: "kMDItemDateAdded", description: "添加日期"),
                        (flag: "kMDItemFileSize", description: "文件大小"),
                        (flag: "kMDItemGPSLatitude", description: "GPS 纬度（照片）"),
                        (flag: "kMDItemGPSLongitude", description: "GPS 经度（照片）"),
                        (flag: "kMDItemCameraModel", description: "相机型号"),
                        (flag: "kMDItemDurationSeconds", description: "时长（秒）"),
                        (flag: "kMDItemAuthors", description: "作者"),
                        (flag: "kMDItemComment", description: "注释")
                    ],
                    tips: "kMDItem 是属性前缀，mdls -name 指定属性最常用"
                ),
                CommandItem(
                    name: "mdutil",
                    syntax: "mdutil [-Ees] [-i on|off] [-a] [volume ...]",
                    description: "管理 Spotlight 索引（mdworker）。",
                    examples: [
                        CommandExample(command: "mdutil -s /", explanation: "查看 Spotlight 索引状态"),
                        CommandExample(command: "sudo mdutil -i on /", explanation: "启用 Spotlight 索引"),
                        CommandExample(command: "sudo mdutil -i off /Volumes/External", explanation: "禁用外置磁盘索引"),
                        CommandExample(command: "sudo mdutil -E /", explanation: "重建 Spotlight 索引"),
                        CommandExample(command: "mdutil -a -s", explanation: "查看所有卷的索引状态")
                    ],
                    commonOptions: [
                        (flag: "-s volume", description: "显示指定卷的索引状态"),
                        (flag: "-i on|off", description: "启用/禁用指定卷的索引"),
                        (flag: "-E", description: "擦除并重建索引"),
                        (flag: "-a", description: "对所有卷操作"),
                        (flag: "-p", description: "打印索引路径")
                    ],
                    tips: "-E 重建索引，-i off 禁用索引（节省外置磁盘空间）"
                )
            ]
        ),

// MARK: - 归档压缩

        CommandCategory(
            name: "归档压缩",
            icon: "archivebox",
            commands: [
                CommandItem(
                    name: "tar",
                    syntax: "tar [-cdtxOTVi] [-b blocks] [-f archive] [-F script] [-h] [--include glob] [--exclude glob] [-j | -z | -Z] [-C dir] [-T filenames] [file ...]",
                    description: "归档文件打包工具。支持 gzip/bzip2/xz 压缩。",
                    examples: [
                        CommandExample(command: "tar -cvf archive.tar dir/", explanation: "打包目录"),
                        CommandExample(command: "tar -xvf archive.tar", explanation: "解包 tar"),
                        CommandExample(command: "tar -czvf archive.tar.gz dir/", explanation: "gzip 压缩打包"),
                        CommandExample(command: "tar -xzvf archive.tar.gz", explanation: "gzip 解压"),
                        CommandExample(command: "tar -xjvf archive.tar.bz2", explanation: "bzip2 解压"),
                        CommandExample(command: "tar -tf archive.tar", explanation: "列出归档内容"),
                        CommandExample(command: "tar -C /tmp -xvf archive.tar", explanation: "解压到指定目录")
                    ],
                    commonOptions: [
                        (flag: "-c", description: "创建新的归档文件"),
                        (flag: "-x", description: "从归档中提取文件"),
                        (flag: "-t", description: "列出归档中的文件"),
                        (flag: "-f file", description: "指定归档文件名（必须指定）"),
                        (flag: "-v", description: "显示操作的详细信息"),
                        (flag: "-z", description: "使用 gzip 压缩/解压 (.tar.gz)"),
                        (flag: "-j", description: "使用 bzip2 压缩/解压 (.tar.bz2)"),
                        (flag: "-J", description: "使用 xz 压缩/解压 (.tar.xz)"),
                        (flag: "-C dir", description: "切换到指定目录再操作"),
                        (flag: "-T file", description: "从文件读取文件名列表"),
                        (flag: "--include=glob", description: "只包含匹配的文件"),
                        (flag: "--exclude=glob", description: "排除匹配的文件"),
                        (flag: "-h", description: "跟随符号链接"),
                        (flag: "-O", description: "提取到 stdout"),
                        (flag: "-p", description: "保留权限信息"),
                        (flag: "-P", description: "保留绝对路径"),
                        (flag: "--strip-components N", description: "解压时去掉 N 层目录前缀"),
                        (flag: "--numeric-owner", description: "只保留 UID/GID 不恢复名称"),
                        (flag: "-d", description: "比较差异（diff 模式）"),
                        (flag: "--backup", description: "创建备份"),
                        (flag: "-X file", description: "从文件读取排除列表")
                    ],
                    tips: "c创建 x解压 t查看 v详细 f文件名，z=gzip j=bzip2 J=xz"
                ),
                CommandItem(
                    name: "zip / unzip",
                    syntax: "zip [-aABcdDeEfFghjklmoqrRSTuvVwXyz!] [-b path] [-D] [-ex] [-i pattern] [-j] [-J] [-L] [-ll] [-n suffix] [-q] [-sf] [-t date] [-tt date] [-P password] [-X] [-y] zipfile [file ...]\n     unzip [-Z] [-cTuv] [-d dir] [-f] [-l] [-oPq] [-x pattern ...] zipfile",
                    description: "ZIP 格式压缩和解压。",
                    examples: [
                        CommandExample(command: "zip -r archive.zip dir/", explanation: "递归压缩目录"),
                        CommandExample(command: "unzip archive.zip", explanation: "解压 zip"),
                        CommandExample(command: "unzip -l archive.zip", explanation: "列出内容"),
                        CommandExample(command: "unzip archive.zip -d /target", explanation: "解压到指定目录"),
                        CommandExample(command: "unzip -o archive.zip", explanation: "解压并覆盖已有文件"),
                        CommandExample(command: "zip -e archive.zip secret.txt", explanation: "加密压缩")
                    ],
                    commonOptions: [
                        (flag: "zip -r", description: "递归压缩整个目录"),
                        (flag: "zip -e", description: "加密压缩（设置密码）"),
                        (flag: "zip -q", description: "静默模式"),
                        (flag: "zip -P password", description: "直接指定密码（不安全）"),
                        (flag: "zip -j", description: "不存储目录路径（只存文件名）"),
                        (flag: "zip -x pattern", description: "排除匹配的文件"),
                        (flag: "zip -9", description: "最大压缩比"),
                        (flag: "unzip -l", description: "列出压缩包中的文件"),
                        (flag: "unzip -o", description: "覆盖已存在的文件（不提示）"),
                        (flag: "unzip -q", description: "静默模式"),
                        (flag: "unzip -P password", description: "指定密码解压"),
                        (flag: "unzip -d dir", description: "指定解压目标目录"),
                        (flag: "unzip -x pattern", description: "排除匹配的文件"),
                        (flag: "unzip -t", description: "测试压缩包完整性"),
                        (flag: "unzip -c", description: "解压到 stdout")
                    ],
                    tips: "zip -r 递归压缩，unzip -d 指定目录，unzip -l 列出内容"
                ),
                CommandItem(
                    name: "gzip / gunzip",
                    syntax: "gzip [-acdfhklNrtvV19] [-S suffix] [file ...]\n     gunzip [-acfhklNrtvV] [-S suffix] [file ...]",
                    description: "gzip 格式压缩和解压（单文件，不支持目录）。",
                    examples: [
                        CommandExample(command: "gzip file.txt", explanation: "压缩（原文件变为 file.txt.gz）"),
                        CommandExample(command: "gunzip file.txt.gz", explanation: "解压 gz 文件"),
                        CommandExample(command: "gzip -k file.txt", explanation: "压缩但保留原文件"),
                        CommandExample(command: "gzip -9 file.txt", explanation: "最大压缩比"),
                        CommandExample(command: "gzip -l file.gz", explanation: "查看压缩文件信息")
                    ],
                    commonOptions: [
                        (flag: "-d", description: "解压（同 gunzip）"),
                        (flag: "-k", description: "保留原始文件（默认删除）"),
                        (flag: "-c", description: "输出到 stdout（不修改文件）"),
                        (flag: "-f", description: "强制覆盖已存在的文件"),
                        (flag: "-9", description: "最大压缩比（最慢）"),
                        (flag: "-1", description: "最快压缩速度（最低压缩比）"),
                        (flag: "-r", description: "递归处理目录下所有 .gz 文件"),
                        (flag: "-l", description: "列出压缩文件信息"),
                        (flag: "-t", description: "测试压缩文件完整性"),
                        (flag: "-v", description: "显示压缩/解压的文件名和比例"),
                        (flag: "-S suffix", description: "指定压缩文件后缀（默认 .gz）"),
                        (flag: "-N", description: "保存原始文件名和时间戳")
                    ],
                    tips: "-k 保留原文件，-9 最大压缩，-d 解压，-c 输出到 stdout"
                ),
                CommandItem(
                    name: "bzip2 / bunzip2",
                    syntax: "bzip2 [-cdfhklqstvV19] [--repetitive-best] [--repetitive-fast] [-s small_block] [file ...]\n     bunzip2 [-fkvs] [-L major.minor.patch] [file ...]",
                    description: "bzip2 格式压缩和解压（比 gzip 压缩比更高，但更慢）。",
                    examples: [
                        CommandExample(command: "bzip2 file.txt", explanation: "压缩文件（生成 file.txt.bz2）"),
                        CommandExample(command: "bunzip2 file.txt.bz2", explanation: "解压 bz2 文件"),
                        CommandExample(command: "bzip2 -k file.txt", explanation: "压缩但保留原文件"),
                        CommandExample(command: "bzip2 -9 file.txt", explanation: "最大压缩比")
                    ],
                    commonOptions: [
                        (flag: "-d", description: "解压"),
                        (flag: "-k", description: "保留原始文件"),
                        (flag: "-c", description: "输出到 stdout"),
                        (flag: "-f", description: "强制覆盖"),
                        (flag: "-9", description: "最大压缩比"),
                        (flag: "-1", description: "最快压缩速度"),
                        (flag: "-t", description: "测试文件完整性"),
                        (flag: "-v", description: "显示详细信息"),
                        (flag: "-s", description: "减少内存使用（小块模式）")
                    ],
                    tips: "比 gzip 压缩比更高但更慢，-k 保留原文件"
                ),
                CommandItem(
                    name: "xz / unxz",
                    syntax: "xz [-dtT1567efkNrsS] [-c] [-F format] [-S suffix] [-T threads] [-q] [file ...]\n     unxz [-dtT1567efkNrsS] [-c] [-F format] [-S suffix] [-T threads] [-q] [file ...]",
                    description: "xz 格式压缩和解压。比 bzip2 压缩比更高，Linux 内核等项目广泛使用。",
                    examples: [
                        CommandExample(command: "xz file.txt", explanation: "压缩（原文件变为 file.txt.xz）"),
                        CommandExample(command: "unxz file.txt.xz", explanation: "解压 xz 文件"),
                        CommandExample(command: "xz -k file.txt", explanation: "压缩但保留原文件"),
                        CommandExample(command: "xz -9 file.txt", explanation: "最大压缩比"),
                        CommandExample(command: "xz -T 4 -9 large.bin", explanation: "4线程最大压缩"),
                        CommandExample(command: "xz -l file.xz", explanation: "查看压缩文件信息"),
                        CommandExample(command: "xz -t file.xz", explanation: "测试压缩文件完整性")
                    ],
                    commonOptions: [
                        (flag: "-d", description: "解压（同 unxz）"),
                        (flag: "-k", description: "保留原始文件"),
                        (flag: "-c", description: "输出到 stdout"),
                        (flag: "-f", description: "强制覆盖"),
                        (flag: "-9", description: "最大压缩比（最慢）"),
                        (flag: "-1", description: "最快压缩速度"),
                        (flag: "-T threads", description: "指定线程数（0=自动）"),
                        (flag: "-S suffix", description: "指定后缀（默认 .xz）"),
                        (flag: "-t", description: "测试完整性"),
                        (flag: "-l", description: "列出压缩文件信息"),
                        (flag: "-s", description: "减少内存使用"),
                        (flag: "-r", description: "递归处理目录"),
                        (flag: "-q", description: "静默模式"),
                        (flag: "-F format", description: "指定格式 (xz/lzma/lz77)")
                    ],
                    tips: "-k 保留原文件，-9 最大压缩，-T 多线程，比 gzip/bzip2 压缩比更高"
                ),
                CommandItem(
                    name: "unar",
                    syntax: "unar [-d output_dir] [-f] [-o output_dir] [-p password] [-r] [-s] [-v] file",
                    description: "通用解压工具，支持几乎所有压缩格式（RAR/7z/ZIP/TAR/GZIP 等）。需 brew install unar。",
                    examples: [
                        CommandExample(command: "unar archive.zip", explanation: "解压 zip 文件"),
                        CommandExample(command: "unar -o /tmp archive.rar", explanation: "解压到指定目录"),
                        CommandExample(command: "unar archive.7z", explanation: "解压 7z 文件"),
                        CommandExample(command: "unar -p password encrypted.zip", explanation: "密码解压"),
                        CommandExample(command: "unar -l archive.zip", explanation: "列出压缩包内容"),
                        CommandExample(command: "unar -r archive.tar.gz", explanation: "解压到 archive/ 目录")
                    ],
                    commonOptions: [
                        (flag: "-o dir", description: "指定输出目录"),
                        (flag: "-d name", description: "指定输出目录名"),
                        (flag: "-f", description: "强制覆盖已存在的文件"),
                        (flag: "-p password", description: "指定密码"),
                        (flag: "-l", description: "列出压缩包内容"),
                        (flag: "-r", description: "解压到以压缩包名命名的目录"),
                        (flag: "-s", description: "跳过不可恢复的文件"),
                        (flag: "-v", description: "详细输出")
                    ],
                    tips: "万能解压工具，支持几乎所有格式，比分别用不同工具方便"
                ),
                CommandItem(
                    name: "ditto",
                    syntax: "ditto [-v] [-V] [-X] [-x] [-c] [-k] [-p] [-rsrc] [--keepParent] [--norsrc] [--sequesterRsrc] [--rsrc] [--keepext] [--hfsCompression] [--nopreserveHFSCompression] source target",
                    description: "macOS 原生复制/归档工具，支持保留资源 fork、ACL、扩展属性等。",
                    examples: [
                        CommandExample(command: "ditto src/ dest/", explanation: "复制目录（保留所有属性）"),
                        CommandExample(command: "ditto -c -k --sequesterRsrc --keepParent src/ archive.zip", explanation: "创建 zip 归档"),
                        CommandExample(command: "ditto -x archive.zip dest/", explanation: "解压 zip"),
                        CommandExample(command: "ditto -c -k --keepParent --sequesterRsrc --norsrc src/ archive.zip", explanation: "创建不含资源fork的zip"),
                        CommandExample(command: "ditto --rsrc src/ dest/", explanation: "复制并保留资源 fork"),
                        CommandExample(command: "ditto -v src/ dest/", explanation: "详细模式复制")
                    ],
                    commonOptions: [
                        (flag: "-c", description: "创建归档（存档模式）"),
                        (flag: "-x", description: "解压归档"),
                        (flag: "-k", description: "使用 PKZip/Zip 格式"),
                        (flag: "-v", description: "详细输出"),
                        (flag: "-V", description: "不验证写入"),
                        (flag: "--keepParent", description: "在归档中保留父目录名"),
                        (flag: "--sequesterRsrc", description: "将资源 fork 存入 __MACOSX"),
                        (flag: "--norsrc", description: "不复制资源 fork"),
                        (flag: "--rsrc", description: "保留资源 fork"),
                        (flag: "--hfsCompression", description: "使用 HFS+ 压缩"),
                        (flag: "--nopreserveHFSCompression", description: "不保留 HFS+ 压缩"),
                        (flag: "--keepext", description: "保留文件扩展名"),
                        (flag: "-X", description: "不复制扩展属性"),
                        (flag: "-p", description: "保留权限"),
                        (flag: "-rsrc", description: "保留资源 fork"),
                        (flag: "source", description: "源文件/目录"),
                        (flag: "target", description: "目标路径")
                    ],
                    tips: "比 cp 更安全，保留所有 macOS 属性，-c -k 创建 zip 最常用"
                )
            ]
        ),

// MARK: - 用户与权限

        CommandCategory(
            name: "用户与权限",
            icon: "person.2",
            commands: [
                CommandItem(
                    name: "whoami",
                    syntax: "whoami",
                    description: "显示当前登录用户名。",
                    examples: [
                        CommandExample(command: "whoami", explanation: "显示当前用户名")
                    ],
                    commonOptions: [],
                    tips: "最简单的命令之一"
                ),
                CommandItem(
                    name: "id",
                    syntax: "id [-p] [-gGru] [user]",
                    description: "显示用户 UID、GID 及所属组信息。",
                    examples: [
                        CommandExample(command: "id", explanation: "显示当前用户完整 ID 信息"),
                        CommandExample(command: "id -u", explanation: "只显示 UID"),
                        CommandExample(command: "id -G", explanation: "显示所有所属组 ID"),
                        CommandExample(command: "id -n -G", explanation: "显示所有所属组名称"),
                        CommandExample(command: "id username", explanation: "显示指定用户信息")
                    ],
                    commonOptions: [
                        (flag: "-u", description: "只显示有效 UID"),
                        (flag: "-g", description: "只显示有效 GID"),
                        (flag: "-G", description: "显示所有组 ID"),
                        (flag: "-n", description: "显示名称而非数字 ID"),
                        (flag: "-r", description: "显示真实（而非有效）ID"),
                        (flag: "-p", description: "可读格式输出"),
                        (flag: "-a", description: "显示所有 ID（同无选项）")
                    ],
                    tips: "-u UID, -g GID, -G 所有组, -n 名称模式"
                ),
                CommandItem(
                    name: "sudo",
                    syntax: "sudo [-BHbEknPS] [-C num] [-D level] [-E] [-e command] [-i [-s]] [-p prompt] [-R dir] [-T num] [-u user] [VAR=val] command",
                    description: "以超级用户（root）权限执行命令。",
                    examples: [
                        CommandExample(command: "sudo ls /root", explanation: "以 root 权限执行"),
                        CommandExample(command: "sudo -i", explanation: "切换到 root 交互 shell"),
                        CommandExample(command: "sudo !!", explanation: "以上一条命令的 root 权限执行"),
                        CommandExample(command: "sudo -k", explanation: "清除 sudo 密码缓存"),
                        CommandExample(command: "sudo -l", explanation: "列出当前用户可用的 sudo 命令"),
                        CommandExample(command: "sudo -u www apachectl start", explanation: "以 www 用户身份执行")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "以 root 身份启动交互式 shell"),
                        (flag: "-s", description: "以 root 身份启动 shell（保留当前环境）"),
                        (flag: "-k", description: "清除 sudo 密码缓存"),
                        (flag: "-l", description: "列出当前用户可用的 sudo 命令"),
                        (flag: "-e cmd", description: "以 root 身份编辑文件"),
                        (flag: "-u user", description: "以指定用户身份执行（非 root）"),
                        (flag: "-E", description: "保留当前环境变量"),
                        (flag: "-H", description: "设置 HOME 为目标用户的主目录"),
                        (flag: "-n", description: "非交互模式（密码已缓存时不提示）"),
                        (flag: "-b", description: "在后台运行命令"),
                        (flag: "-p prompt", description: "自定义密码提示"),
                        (flag: "-R dir", description: "指定 sudoers 文件目录"),
                        (flag: "-T num", description: "密码缓存超时时间（秒）"),
                        (flag: "-C num", description: "在指定文件描述符后关闭文件描述符")
                    ],
                    tips: "!! 执行上一条命令，-i root shell，-l 查看权限，-E 保留环境"
                ),
                CommandItem(
                    name: "su",
                    syntax: "su [-] [-fl] [-c command] [-s shell] [user [argument ...]]",
                    description: "切换用户身份。",
                    examples: [
                        CommandExample(command: "su - root", explanation: "切换到 root（完整登录环境）"),
                        CommandExample(command: "su - username", explanation: "切换到指定用户"),
                        CommandExample(command: "su", explanation: "切换到 root（不切换环境）"),
                        CommandExample(command: "su - -c 'ls /root'", explanation: "以 root 执行命令后退出")
                    ],
                    commonOptions: [
                        (flag: "-", description: "使用目标用户的完整登录环境"),
                        (flag: "-l", description: "同 -，启动登录 shell"),
                        (flag: "-c cmd", description: "以目标用户执行命令后退出"),
                        (flag: "-f", description: "快速模式（不读 .profile）"),
                        (flag: "-s shell", description: "指定使用的 shell")
                    ],
                    tips: "- 启动登录 shell（完整环境），不加 - 保留当前环境"
                ),
                CommandItem(
                    name: "passwd",
                    syntax: "passwd [-p prefix] [-s style] [-u uid] [user]",
                    description: "修改用户密码。",
                    examples: [
                        CommandExample(command: "passwd", explanation: "修改当前用户密码"),
                        CommandExample(command: "sudo passwd username", explanation: "管理员修改指定用户密码"),
                        CommandExample(command: "sudo passwd -u username", explanation: "解锁用户账户")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "锁定用户账户"),
                        (flag: "-u", description: "解锁用户账户"),
                        (flag: "-e", description: "强制用户下次登录时更改密码"),
                        (flag: "-d", description: "删除密码（无密码登录）"),
                        (flag: "-s style", description: "指定密码哈希算法"),
                        (flag: "-p prefix", description: "指定加密后的密码前缀")
                    ],
                    tips: "普通用户改自己的，改别人需 root 权限"
                ),
                CommandItem(
                    name: "dscl",
                    syntax: "dscl [-u auth_user] [-p auth_password] [domain | /path/to/dsdb] -command [arguments ...]",
                    description: "Directory Service 命令行工具，管理用户/组和目录。",
                    examples: [
                        CommandExample(command: "dscl . -list /Users", explanation: "列出所有本地用户"),
                        CommandExample(command: "dscl . -read /Users/username", explanation: "读取用户详细信息"),
                        CommandExample(command: "dscl . -create /Users/newuser", explanation: "创建新用户"),
                        CommandExample(command: "dscl . -delete /Users/olduser", explanation: "删除用户"),
                        CommandExample(command: "dscl . -append /Users/user RecordName newname", explanation: "添加属性值")
                    ],
                    commonOptions: [
                        (flag: "-list path", description: "列出指定路径下所有记录"),
                        (flag: "-read path [attr]", description: "读取记录属性"),
                        (flag: "-readall path", description: "读取所有记录"),
                        (flag: "-create path [attr val]", description: "创建新记录"),
                        (flag: "-delete path", description: "删除记录"),
                        (flag: "-append path attr val", description: "追加属性值"),
                        (flag: "-merge path attr val", description: "合并属性值"),
                        (flag: "-deleteattr path attr", description: "删除属性"),
                        (flag: "-deleteval path attr val", description: "删除属性的指定值"),
                        (flag: "-passwd path newpassword", description: "更改用户密码"),
                        (flag: "-authonly username password", description: "只验证用户名密码"),
                        (flag: "-createpl", description: "创建 plist"),
                        (flag: "-mergepl", description: "合并 plist")
                    ],
                    tips: ". 代表本地目录服务，/Users 用户，/Groups 组"
                ),
                CommandItem(
                    name: "security",
                    syntax: "security [-hilqv] [-p prompt] command [command-args] [options ...]",
                    description: "macOS 安全框架命令行工具（钥匙串、证书、ACL 等）。",
                    examples: [
                        CommandExample(command: "security find-generic-password -a john -s myservice", explanation: "查找密码"),
                        CommandExample(command: "security add-generic-password -a john -s svc -w pass", explanation: "添加密码"),
                        CommandExample(command: "security delete-generic-password -s myservice", explanation: "删除密码"),
                        CommandExample(command: "security find-certificate -a -p", explanation: "导出所有证书为 PEM"),
                        CommandExample(command: "security dump-keychain", explanation: "导出钥匙串内容"),
                        CommandExample(command: "security unlock-keychain", explanation: "解锁钥匙串"),
                        CommandExample(command: "security find-identity -v -p codesigning", explanation: "列出代码签名证书")
                    ],
                    commonOptions: [
                        (flag: "find-generic-password", description: "查找通用密码项"),
                        (flag: "add-generic-password", description: "添加通用密码项"),
                        (flag: "delete-generic-password", description: "删除通用密码项"),
                        (flag: "find-generic-password -a acct -s svc -w", description: "按账户和服务查找密码值"),
                        (flag: "find-certificate", description: "查找证书"),
                        (flag: "add-certificates", description: "添加证书"),
                        (flag: "delete-certificate", description: "删除证书"),
                        (flag: "find-identity", description: "查找签名身份"),
                        (flag: "dump-keychain", description: "导出钥匙串"),
                        (flag: "unlock-keychain", description: "解锁钥匙串"),
                        (flag: "lock-keychain", description: "锁定钥匙串"),
                        (flag: "create-keychain", description: "创建钥匙串"),
                        (flag: "default-keychain", description: "设置默认钥匙串"),
                        (flag: "-p prompt", description: "自定义密码提示"),
                        (flag: "-a account", description: "指定账户名"),
                        (flag: "-s service", description: "指定服务名"),
                        (flag: "-w", description: "只输出密码值")
                    ],
                    tips: "-w 只输出密码值配合管道使用，find-identity 查签名证书"
                ),
                CommandItem(
                    name: "finger",
                    syntax: "finger [-bfhilmpsw] [user ...] [user@host ...]",
                    description: "显示系统用户信息。macOS 上用于查看用户登录状态和信息。",
                    examples: [
                        CommandExample(command: "finger", explanation: "显示所有登录用户"),
                        CommandExample(command: "finger username", explanation: "显示指定用户信息"),
                        CommandExample(command: "finger -s", explanation: "短格式（只显示 login name/终端/时间）"),
                        CommandExample(command: "finger -l", explanation: "长格式（详细信息）"),
                        CommandExample(command: "finger -p", explanation: "不显示 .plan 和 .project"),
                        CommandExample(command: "finger user@host", explanation: "查询远程主机用户")
                    ],
                    commonOptions: [
                        (flag: "-s", description: "短格式输出（只显示核心信息）"),
                        (flag: "-l", description: "长格式输出（详细信息）"),
                        (flag: "-p", description: "不显示 .plan 和 .project 文件"),
                        (flag: "-f", description: "禁用空行压缩"),
                        (flag: "-b", description: "抑制 home 目录和 shell 信息"),
                        (flag: "-h", description: "抑制 .plan 文件显示"),
                        (flag: "-i", description: "输出空行（强制交互模式）"),
                        (flag: "-m", description: "禁用用户匹配（只精确匹配用户名）"),
                        (flag: "-w", description: "宽输出"),
                        (flag: "user@host", description: "查询远程主机上的用户")
                    ],
                    tips: "-s 简洁查看，-l 详细查看，可用 .plan 文件设置个人说明"
                )
            ]
        ),

// MARK: - Shell 环境

        CommandCategory(
            name: "Shell 环境",
            icon: "terminal",
            commands: [
                CommandItem(
                    name: "echo",
                    syntax: "echo [-eE] [-n] [string ...]",
                    description: "输出文本到标准输出。",
                    examples: [
                        CommandExample(command: "echo 'Hello World'", explanation: "输出文本"),
                        CommandExample(command: "echo $PATH", explanation: "显示环境变量"),
                        CommandExample(command: "echo -e 'line1\\nline2'", explanation: "解释转义字符"),
                        CommandExample(command: "echo -n 'no newline'", explanation: "不输出换行"),
                        CommandExample(command: "echo 'text' >> file.txt", explanation: "追加到文件")
                    ],
                    commonOptions: [
                        (flag: "-n", description: "不输出末尾换行符"),
                        (flag: "-e", description: "解释转义字符 (\\n \\t \\r \\ 等)"),
                        (flag: "-E", description: "不解释转义字符（默认行为）")
                    ],
                    tips: "-n 不换行，-e 启用转义，> 覆盖 >> 追加"
                ),
                CommandItem(
                    name: "export",
                    syntax: "export [-fp] [name[=value]] ...",
                    description: "设置或导出环境变量，使其对子进程可见。",
                    examples: [
                        CommandExample(command: "export MY_VAR='hello'", explanation: "设置环境变量"),
                        CommandExample(command: "export PATH=$PATH:/usr/local/bin", explanation: "添加路径到 PATH"),
                        CommandExample(command: "export -p", explanation: "显示所有导出的变量"),
                        CommandExample(command: "export -f myfunction", explanation: "导出函数给子 shell")
                    ],
                    commonOptions: [
                        (flag: "-p", description: "列出所有已导出的环境变量"),
                        (flag: "-f", description: "导出函数（bash 特性）"),
                        (flag: "name=value", description: "设置变量值"),
                        (flag: "-n", description: "从导出列表中移除变量")
                    ],
                    tips: "只对当前 shell 及子进程有效，写入 ~/.zshrc 持久化"
                ),
                CommandItem(
                    name: "env",
                    syntax: "env [-i] [-util] [-P altpath] [-S string] [-u name] [name=value ...] [command [argument ...]]",
                    description: "显示或设置环境变量。",
                    examples: [
                        CommandExample(command: "env", explanation: "显示所有环境变量"),
                        CommandExample(command: "env PATH=/usr/bin:/bin ls", explanation: "在指定环境下执行命令"),
                        CommandExample(command: "env -i /bin/bash", explanation: "在空环境中启动 shell"),
                        CommandExample(command: "env -u LD_PRELOAD ./program", explanation: "移除指定变量后执行")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "清除所有环境变量后执行"),
                        (flag: "-u name", description: "从环境中移除指定变量"),
                        (flag: "-P path", description: "搜索路径"),
                        (flag: "-S string", description: "解析字符串为参数和环境变量"),
                        (flag: "name=value", description: "在执行前设置环境变量")
                    ],
                    tips: "-i 空环境，-u 移除变量，常用于测试纯净环境"
                ),
                CommandItem(
                    name: "which",
                    syntax: "which [-a] command ...",
                    description: "查找命令的可执行文件路径。",
                    examples: [
                        CommandExample(command: "which python3", explanation: "查找 python3 路径"),
                        CommandExample(command: "which -a bash", explanation: "查找所有匹配路径"),
                        CommandExample(command: "which -s git", explanation: "静默模式（只返回状态码）")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有匹配的路径（包括别名）"),
                        (flag: "-s", description: "静默模式（成功返回0，失败返回1）")
                    ],
                    tips: "-a 显示所有，-s 静默模式适合脚本判断"
                ),
                CommandItem(
                    name: "history",
                    syntax: "history [-c] [-d offset] [n] [-arwf filename]",
                    description: "显示命令历史记录。",
                    examples: [
                        CommandExample(command: "history", explanation: "显示命令历史"),
                        CommandExample(command: "history | tail -20", explanation: "显示最近 20 条命令"),
                        CommandExample(command: "history | grep 'git'", explanation: "搜索历史中的 git 命令"),
                        CommandExample(command: "!!", explanation: "执行上一条命令"),
                        CommandExample(command: "!grep", explanation: "执行最近一条以 grep 开头的命令"),
                        CommandExample(command: "!123", explanation: "执行历史中编号为 123 的命令"),
                        CommandExample(command: "history -c", explanation: "清除历史记录")
                    ],
                    commonOptions: [
                        (flag: "!!", description: "执行上一条命令"),
                        (flag: "!string", description: "执行最近以 string 开头的命令"),
                        (flag: "!n", description: "执行历史中第 n 条命令"),
                        (flag: "!?string", description: "执行最近包含 string 的命令"),
                        (flag: "^old^new", description: "将上一条命令中的 old 替换为 new"),
                        (flag: "Ctrl+R", description: "反向搜索历史命令"),
                        (flag: "-c", description: "清除历史记录"),
                        (flag: "-d offset", description: "删除指定位置的历史记录")
                    ],
                    tips: "!! 上一条，!string 前缀匹配，Ctrl+R 交互搜索"
                ),
                CommandItem(
                    name: "alias",
                    syntax: "alias [-p] [name[=value] ...]",
                    description: "创建或显示命令别名。",
                    examples: [
                        CommandExample(command: "alias ll='ls -la'", explanation: "创建别名 ll"),
                        CommandExample(command: "alias", explanation: "显示所有别名"),
                        CommandExample(command: "unalias ll", explanation: "删除别名 ll"),
                        CommandExample(command: "alias update='brew update && brew upgrade'", explanation: "复杂命令别名")
                    ],
                    commonOptions: [
                        (flag: "name='cmd'", description: "创建别名（等号两边不要有空格）"),
                        (flag: "-p", description: "以可重用的格式输出所有别名"),
                        (flag: "unalias name", description: "删除别名")
                    ],
                    tips: "写入 ~/.zshrc 持久化，macOS 默认使用 zsh"
                ),
                CommandItem(
                    name: "date",
                    syntax: "date [-jnu] [-d dst] [-r seconds] [-t [[CC]YY]MMDDhhmm[.ss]] [+format]",
                    description: "显示或设置系统日期和时间。",
                    examples: [
                        CommandExample(command: "date", explanation: "显示当前日期时间"),
                        CommandExample(command: "date '+%Y-%m-%d %H:%M:%S'", explanation: "自定义格式输出"),
                        CommandExample(command: "date -u", explanation: "显示 UTC 时间"),
                        CommandExample(command: "date -v+1d '+%Y-%m-%d'", explanation: "显示明天的日期"),
                        CommandExample(command: "date -v-1w '+%Y-%m-%d'", explanation: "显示上周的日期"),
                        CommandExample(command: "date -j -f '%Y-%m-%d' '2024-01-15'", explanation: "解析日期字符串")
                    ],
                    commonOptions: [
                        (flag: "+%Y-%m-%d", description: "年-月-日"),
                        (flag: "+%H:%M:%S", description: "时:分:秒"),
                        (flag: "+%s", description: "Unix 时间戳（秒）"),
                        (flag: "+%A", description: "星期全名"),
                        (flag: "+%a", description: "星期缩写"),
                        (flag: "+%B", description: "月份全名"),
                        (flag: "+%b", description: "月份缩写"),
                        (flag: "+%D", description: "短日期 (MM/DD/YY)"),
                        (flag: "+%F", description: "ISO 日期 (YYYY-MM-DD)"),
                        (flag: "+%T", description: "时间 (HH:MM:SS)"),
                        (flag: "-u", description: "UTC 时间"),
                        (flag: "-v±N", description: "日期偏移 (+1d/-1m/+1y)"),
                        (flag: "-j", description: "不设置时间（只解析/格式化）"),
                        (flag: "-f format", description: "指定输入日期格式"),
                        (flag: "-r seconds", description: "从 Unix 时间戳转换"),
                        (flag: "-R", description: "RFC 2822 格式"),
                        (flag: "-I", description: "ISO 8601 格式")
                    ],
                    tips: "常用格式: %Y年 %m月 %d日 %H时 %M分 %S秒 %s时间戳"
                ),
                CommandItem(
                    name: "cal",
                    syntax: "cal [[month] year] [-3] [-A year] [-B year] [-j] [-m] [-y]",
                    description: "显示日历。",
                    examples: [
                        CommandExample(command: "cal", explanation: "显示当月日历"),
                        CommandExample(command: "cal 2024", explanation: "显示全年日历"),
                        CommandExample(command: "cal 3 2024", explanation: "显示 2024 年 3 月"),
                        CommandExample(command: "cal -3", explanation: "显示前月、当月、下月"),
                        CommandExample(command: "cal -j", explanation: "显示一年中的第几天")
                    ],
                    commonOptions: [
                        (flag: "-3", description: "显示前月、当月、下月三个月"),
                        (flag: "-A year", description: "显示未来 N 年的日历"),
                        (flag: "-B year", description: "显示过去 N 年的日历"),
                        (flag: "-j", description: "显示儒略日（一年中的第几天）"),
                        (flag: "-m", description: "从周一开始显示"),
                        (flag: "-y", description: "显示全年日历")
                    ],
                    tips: "-3 三个月，-j 儒略日，-m 从周一开始"
                ),
                CommandItem(
                    name: "source / .",
                    syntax: "source filename\n     . filename",
                    description: "在当前 shell 中执行文件中的命令（而非子 shell）。",
                    examples: [
                        CommandExample(command: "source ~/.zshrc", explanation: "重新加载 zsh 配置"),
                        CommandExample(command: ". ~/.bash_profile", explanation: "同上（. 是 source 的简写）"),
                        CommandExample(command: "source env.sh", explanation: "加载环境变量到当前 shell")
                    ],
                    commonOptions: [],
                    tips: "与直接执行脚本不同，source 在当前 shell 环境中运行（变量会保留）"
                ),
                CommandItem(
                    name: "man",
                    syntax: "man [-a] [-C config] [-d] [-D] [-f] [-F] [-h] [-k] [-K] [-m] [-M path] [-p pager] [-P browser] [-S section] [-t | -T encoding] [-w | -W] [[section] page ...] [-C file] [-S section] [name]",
                    description: "查看命令的手册页（manual page）。",
                    examples: [
                        CommandExample(command: "man ls", explanation: "查看 ls 的手册"),
                        CommandExample(command: "man -k search", explanation: "按关键词搜索（同 apropos）"),
                        CommandExample(command: "man -t ls | open -f -a Preview", explanation: "以 PDF 查看手册"),
                        CommandExample(command: "man 3 printf", explanation: "查看第 3 节的 printf"),
                        CommandExample(command: "man -w ls", explanation: "只显示手册文件路径")
                    ],
                    commonOptions: [
                        (flag: "-k", description: "按关键词搜索所有手册（同 apropos）"),
                        (flag: "-f", description: "快速查看命令是否有手册（同 whatis）"),
                        (flag: "-w", description: "只显示手册文件路径"),
                        (flag: "-W", description: "显示手册文件的完整路径"),
                        (flag: "-t", description: "生成 troff/PostScript 格式"),
                        (flag: "-T encoding", description: "指定输出编码"),
                        (flag: "-a", description: "显示所有匹配的手册页"),
                        (flag: "-S section", description: "限制搜索指定章节"),
                        (flag: "-p pager", description: "指定分页程序"),
                        (flag: "-P browser", description: "指定 HTML 查看器"),
                        (flag: "section", description: "手册章节: 1命令 2系统调用 3库函数 5配置 8管理")
                    ],
                    tips: "/搜索 n下一个 q退出 章节:1命令 2系统调用 3库函数 5配置 8管理"
                ),
                CommandItem(
                    name: "type",
                    syntax: "type [-aftpP] name [name ...]",
                    description: "显示命令的类型和路径（是内置命令、别名、函数还是外部程序）。",
                    examples: [
                        CommandExample(command: "type ls", explanation: "查看 ls 是什么类型的命令"),
                        CommandExample(command: "type -a ls", explanation: "显示所有 ls 的定义"),
                        CommandExample(command: "type cd", explanation: "查看 cd 是 shell 内置命令"),
                        CommandExample(command: "type -p python3", explanation: "只输出可执行文件路径"),
                        CommandExample(command: "type ll", explanation: "查看别名定义")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有定义（包括别名和函数）"),
                        (flag: "-t", description: "简洁类型名 (alias/builtin/file/keyword/function)"),
                        (flag: "-p", description: "如果是外部命令，输出路径"),
                        (flag: "-P", description: "强制搜索 PATH（忽略别名等）"),
                        (flag: "-f", description: "禁用函数查找")
                    ],
                    tips: "-t 快速判断类型，-p 输出路径，-a 显示所有定义"
                ),
                CommandItem(
                    name: "pushd / popd / dirs",
                    syntax: "pushd [dir | +N | -N]\n     popd [+N | -N]\n     dirs [-clpv] [+N | -N]",
                    description: "目录栈操作：pushd 压入并切换，popd 弹出并切换，dirs 显示栈内容。",
                    examples: [
                        CommandExample(command: "pushd /tmp", explanation: "将 /tmp 压入栈并切换"),
                        CommandExample(command: "pushd", explanation: "交换栈顶两个目录"),
                        CommandExample(command: "popd", explanation: "弹出栈顶目录并切换"),
                        CommandExample(command: "dirs", explanation: "显示目录栈"),
                        CommandExample(command: "dirs -v", explanation: "显示带编号的目录栈"),
                        CommandExample(command: "pushd +2", explanation: "旋转栈，将第 2 个目录移到栈顶"),
                        CommandExample(command: "popd +1", explanation: "删除栈中第 1 个目录")
                    ],
                    commonOptions: [
                        (flag: "pushd dir", description: "将 dir 压入栈并切换到 dir"),
                        (flag: "pushd", description: "交换栈顶两个目录"),
                        (flag: "pushd +N", description: "旋转目录栈，将第 N 个移到栈顶"),
                        (flag: "popd", description: "弹出栈顶并切换"),
                        (flag: "popd +N", description: "删除栈中第 N 个"),
                        (flag: "dirs", description: "显示目录栈"),
                        (flag: "dirs -v", description: "带编号显示目录栈"),
                        (flag: "dirs -c", description: "清空目录栈"),
                        (flag: "dirs -l", description: "显示完整路径（不缩写 ~）"),
                        (flag: "dirs -p", description: "每行一个目录"),
                        (flag: "dirs -n", description: "只显示 N 个最近的目录")
                    ],
                    tips: "pushd 保存当前位置并切换，popd 返回，dirs 查看栈"
                ),
                CommandItem(
                    name: "read",
                    syntax: "read [-rsuAFNnEeDdPpOoQqCci] [-t [num]] [-p prompt] [-a array] [-d delim] [-n num] [-N num] [-s] [name ...]",
                    description: "从标准输入读取一行并分割为变量。Shell 脚本中最常用的输入命令。",
                    examples: [
                        CommandExample(command: "read name", explanation: "读取输入到变量 name"),
                        CommandExample(command: "read -p 'Enter name: ' name", explanation: "带提示符读取"),
                        CommandExample(command: "read -s password", explanation: "静默输入（不回显，适合密码）"),
                        CommandExample(command: "read -n 1 answer", explanation: "只读取 1 个字符"),
                        CommandExample(command: "read -t 10 answer", explanation: "10 秒超时读取"),
                        CommandExample(command: "read -a arr <<< 'a b c'", explanation: "将输入分割到数组"),
                        CommandExample(command: "echo 'a:b:c' | IFS=: read -r x y z", explanation: "按分隔符分割到多个变量"),
                        CommandExample(command: "read -d '' str <<< 'hello\\0world'", explanation: "指定分隔符读取")
                    ],
                    commonOptions: [
                        (flag: "-p prompt", description: "显示提示符"),
                        (flag: "-s", description: "静默模式（不回显输入）"),
                        (flag: "-n num", description: "只读取 num 个字符"),
                        (flag: "-N num", description: "精确读取 num 个字符"),
                        (flag: "-t [num]", description: "超时时间（秒，默认 0=无超时）"),
                        (flag: "-r", description: "原始模式（不处理反斜杠）"),
                        (flag: "-a array", description: "将字段存入数组"),
                        (flag: "-d delim", description: "指定行终止符"),
                        (flag: "-e", description: "使用 readline 进行行编辑"),
                        (flag: "-A", description: "将字段存入数组（同 -a）"),
                        (flag: "-F num", description: "从第 num 个字段开始读取"),
                        (flag: "-n num -N num", description: "读取恰好 num 个字符（不等待换行）"),
                        (flag: "-u fd", description: "从文件描述符读取"),
                        (flag: "-D str", description: "读取到变量，使用默认值 str"),
                        (flag: "name", description: "变量名（默认 REPLY）")
                    ],
                    tips: "-s 静默密码，-t 超时，-p 提示符，-r 防止转义"
                ),
                CommandItem(
                    name: "test / [ / [[ ]]",
                    syntax: "test expression\n     [ expression ]\n     [[ expression ]]",
                    description: "Shell 条件测试命令。[[ ]] 是 Bash/Zsh 增强版，支持模式匹配和正则。",
                    examples: [
                        CommandExample(command: "[ -f file.txt ] && echo 'exists'", explanation: "检查文件是否存在"),
                        CommandExample(command: "[ -d /tmp ] && echo 'is dir'", explanation: "检查是否为目录"),
                        CommandExample(command: "[ -z \"$var\" ]", explanation: "检查变量是否为空"),
                        CommandExample(command: "[ \"$a\" = \"$b\" ]", explanation: "字符串相等比较"),
                        CommandExample(command: "[ 5 -gt 3 ]", explanation: "数值大于比较"),
                        CommandExample(command: "[[ $file == *.jpg ]]", explanation: "模式匹配（Zsh/Bash）"),
                        CommandExample(command: "[[ $str =~ ^[0-9]+$ ]]", explanation: "正则匹配（Zsh/Bash）"),
                        CommandExample(command: "[[ -f file && -r file ]]", explanation: "组合条件（可读的文件）")
                    ],
                    commonOptions: [
                        (flag: "-f file", description: "文件存在且是普通文件"),
                        (flag: "-d file", description: "存在且是目录"),
                        (flag: "-e file", description: "文件存在"),
                        (flag: "-r file", description: "文件存在且可读"),
                        (flag: "-w file", description: "文件存在且可写"),
                        (flag: "-x file", description: "文件存在且可执行"),
                        (flag: "-s file", description: "文件存在且大小 > 0"),
                        (flag: "-L file", description: "文件存在且是符号链接"),
                        (flag: "-S file", description: "文件存在且是 socket"),
                        (flag: "-p file", description: "文件存在且是 FIFO"),
                        (flag: "-c file", description: "文件存在且是字符设备"),
                        (flag: "-b file", description: "文件存在且是块设备"),
                        (flag: "-z str", description: "字符串为空"),
                        (flag: "-n str", description: "字符串非空"),
                        (flag: "str1 = str2", description: "字符串相等"),
                        (flag: "str1 != str2", description: "字符串不等"),
                        (flag: "str1 < str2", description: "字符串小于（按字典序）"),
                        (flag: "n1 -eq n2", description: "数值等于"),
                        (flag: "n1 -ne n2", description: "数值不等于"),
                        (flag: "n1 -gt n2", description: "数值大于"),
                        (flag: "n1 -ge n2", description: "数值大于等于"),
                        (flag: "n1 -lt n2", description: "数值小于"),
                        (flag: "n1 -le n2", description: "数值小于等于"),
                        (flag: "f1 -nt f2", description: "f1 比 f2 新（[[ ]] only）"),
                        (flag: "f1 -ot f2", description: "f1 比 f2 旧（[[ ]] only）"),
                        (flag: "== pattern", description: "[[ ]] 中的模式匹配"),
                        (flag: "=~ regex", description: "[[ ]] 中的正则匹配"),
                        (flag: "expr1 && expr2", description: "逻辑与"),
                        (flag: "expr1 || expr2", description: "逻辑或"),
                        (flag: "! expr", description: "逻辑非")
                    ],
                    tips: "[[ ]] 比 [ ] 更强大：支持 &&/|| 模式匹配 正则，推荐用 [[ ]]"
                ),
                CommandItem(
                    name: "fc",
                    syntax: "fc [-e ename] [-nlr] [first] [last]\n     fc -p [filename [line]]\n     fc -s [-pat=words] [oldest=newer] [first]",
                    description: "Fix Command — 编辑或重新执行历史命令。也可用于查看和管理历史。",
                    examples: [
                        CommandExample(command: "fc", explanation: "在编辑器中打开上一条命令并执行"),
                        CommandExample(command: "fc -l", explanation: "列出最近 16 条历史命令"),
                        CommandExample(command: "fc -l 100", explanation: "列出从第 100 条开始的历史"),
                        CommandExample(command: "fc -l 100 200", explanation: "列出第 100 到 200 条"),
                        CommandExample(command: "fc -s 'old' 'new'", explanation: "将上一条命令中的 old 替换为 new 并执行"),
                        CommandExample(command: "fc -e vim", explanation: "用 vim 编辑并执行上一条命令"),
                        CommandExample(command: "fc -r", explanation: "反向列出历史")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "列出历史命令（不执行）"),
                        (flag: "-n", description: "列出时不显示行号"),
                        (flag: "-r", description: "反向列出历史"),
                        (flag: "-e editor", description: "指定编辑器（默认 $FCEDIT）"),
                        (flag: "-s", description: "替换并执行（不进入编辑器）"),
                        (flag: "old=new", description: "替换命令中的字符串"),
                        (flag: "first", description: "起始历史编号"),
                        (flag: "last", description: "结束历史编号")
                    ],
                    tips: "fc -l 查看历史，fc -s old=new 替换执行，fc 进编辑器修改"
                ),
                CommandItem(
                    name: "getopts",
                    syntax: "getopts optstring name [arg ...]",
                    description: "Shell 内置的选项解析器，用于解析脚本参数。比 getopt 更便携。",
                    examples: [
                        CommandExample(command: "while getopts 'ab:c' opt; do case $opt in a) echo 'flag a';; b) echo 'opt b: $OPTARG';; :) echo 'missing arg';; *) echo 'unknown';; esac; done", explanation: "解析 -a -b val -c 选项"),
                        CommandExample(command: "getopts 'f:o:v' opt -- -f file -o out -v", explanation: "解析 -- 后的长选项"),
                        CommandExample(command: "getopts ':a:b:c' opt <<< '-a 1 -c'", explanation: "静默模式（不输出错误）")
                    ],
                    commonOptions: [
                        (flag: "optstring", description: "有效的选项字符（如 'ab:c' : 表示需要参数）"),
                        (flag: "name", description: "当前选项存储到的变量名"),
                        (flag: "OPTARG", description: "当前选项的参数值"),
                        (flag: "OPTIND", description: "下一个参数的索引（从1开始）"),
                        (flag: ":", description: "optstring 以 : 开头时，抑制错误消息"),
                        (flag: "::", description: "参数可选（罕见，ksh 扩展）"),
                        (flag: "-a", description: "flag 类选项（无参数）"),
                        (flag: "-b val", description: "需要参数的选项"),
                        (flag: "-c", description: "flag 类选项（无参数）"),
                        (flag: "--", description: "标记选项结束"),
                        (flag: "return 0", description: "有选项可用"),
                        (flag: "return 1", description: "没有更多选项")
                    ],
                    tips: "optstring 中字母后加 : 表示需要参数，OPTARG 获取参数值"
                ),
                CommandItem(
                    name: "hash",
                    syntax: "hash [-r] [-p file] [command ...]",
                    description: "Shell 内置命令缓存。记录已查找过的命令路径，加速后续执行。",
                    examples: [
                        CommandExample(command: "hash", explanation: "显示所有缓存的命令路径"),
                        CommandExample(command: "hash -r", explanation: "清除所有缓存"),
                        CommandExample(command: "hash python3", explanation: "缓存 python3 的路径"),
                        CommandExample(command: "hash -p /usr/local/bin/python3 python3", explanation: "手动设置 python3 的缓存路径")
                    ],
                    commonOptions: [
                        (flag: "-r", description: "清除所有路径缓存"),
                        (flag: "-p file cmd", description: "手动设置命令的缓存路径"),
                        (flag: "command", description: "查找并缓存指定命令的路径")
                    ],
                    tips: "通常不需要手动操作，安装新程序后 hash -r 清除缓存即可"
                ),
                CommandItem(
                    name: "readonly",
                    syntax: "readonly [-af] [name[=value] ...]",
                    description: "将变量或函数标记为只读，防止被修改或删除。",
                    examples: [
                        CommandExample(command: "readonly MY_VAR='constant'", explanation: "设置只读变量"),
                        CommandExample(command: "readonly -a MY_ARR=(a b c)", explanation: "设置只读数组"),
                        CommandExample(command: "readonly -p", explanation: "显示所有只读变量"),
                        CommandExample(command: "readonly -f myfunc", explanation: "将函数标记为只读"),
                        CommandExample(command: "readonly -a", explanation: "将所有函数标记为只读")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "将数组变量标记为只读"),
                        (flag: "-f", description: "将函数标记为只读"),
                        (flag: "-p", description: "以可重用格式显示所有只读变量"),
                        (flag: "name=value", description: "设置并标记为只读")
                    ],
                    tips: "只读变量一旦设置无法取消（除非退出 shell），常用于常量定义"
                ),
                CommandItem(
                    name: "set / unset",
                    syntax: "set [-abefhkmnptuvxBCEHPT] [-o option-name] [--] [arg ...]\n     unset [-fv] [name ...]",
                    description: "set 设置 shell 选项和位置参数，unset 删除变量或函数。",
                    examples: [
                        CommandExample(command: "set -x", explanation: "启用调试模式（显示执行的命令）"),
                        CommandExample(command: "set +x", explanation: "关闭调试模式"),
                        (CommandExample(command: "set -e", explanation: "命令失败时立即退出脚本")),
                        CommandExample(command: "set -u", explanation: "使用未定义变量时报错"),
                        CommandExample(command: "set -o pipefail", explanation: "管道中任一命令失败则整体失败"),
                        CommandExample(command: "set -- args", explanation: "设置位置参数"),
                        CommandExample(command: "unset MY_VAR", explanation: "删除变量"),
                        CommandExample(command: "unset -f myfunc", explanation: "删除函数")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "所有新变量自动导出"),
                        (flag: "-b", description: "后台任务完成时立即通知"),
                        (flag: "-e", description: "命令失败时立即退出"),
                        (flag: "-f", description: "禁用文件名生成（globbing）"),
                        (flag: "-h", description: "查找命令时解析别名和函数"),
                        (flag: "-k", description: "所有赋值也作为环境变量"),
                        (flag: "-m", description: "启用作业控制"),
                        (flag: "-n", description: "读取但不执行命令"),
                        (flag: "-p", description: "禁用路径搜索"),
                        (flag: "-t", description: "读取并执行一条命令后退出"),
                        (flag: "-u", description: "使用未定义变量时报错"),
                        (flag: "-v", description: "读取时显示每行输入"),
                        (flag: "-x", description: "执行前显示每条命令（调试）"),
                        (flag: "-B", description: "启用花括号展开"),
                        (flag: "-C", description: "禁止覆盖重定向（noclobber）"),
                        (flag: "-E", description: "ERR trap 被函数/命令继承"),
                        (flag: "-H", description: "启用 ! 历史展开"),
                        (flag: "-o option", description: "设置 shell 选项名"),
                        (flag: "o pipefail", description: "管道中最后一个失败命令的退出码"),
                        (flag: "o nounset", description: "同 -u，使用未定义变量报错"),
                        (flag: "o xtrace", description: "同 -x，调试模式"),
                        (flag: "--", description: "选项解析结束，后续为参数"),
                        (flag: "+X", description: "关闭 X 选项（+ 代替 -）")
                    ],
                    tips: "set -euxo pipefail 是脚本最常用的安全选项组合"
                ),
                CommandItem(
                    name: "eval",
                    syntax: "eval [arg ...]",
                    description: "将参数连接起来作为 shell 命令执行。支持动态构造命令。",
                    examples: [
                        CommandExample(command: "eval echo 'Hello World'", explanation: "执行参数组成的命令"),
                        CommandExample(command: "var='echo Hi'; eval $var", explanation: "执行变量中的命令"),
                        CommandExample(command: "eval \"echo \\$MY_VAR\"", explanation: "两次展开变量"),
                        CommandExample(command: "eval \"cmd1; cmd2; cmd3\"", explanation: "执行多个命令"),
                        CommandExample(command: "eval \"$(brew shellenv)\"", explanation: "执行 brew 环境设置")
                    ],
                    commonOptions: [],
                    tips: "两次展开：先参数展开，再命令执行。brew shellenv 常配合 eval"
                ),
                CommandItem(
                    name: "exec",
                    syntax: "exec [-cl] [-a name] [command [argument ...]]",
                    description: "用指定命令替换当前 shell 进程（不创建子进程）。也可用于重定向。",
                    examples: [
                        CommandExample(command: "exec /bin/zsh", explanation: "替换为新的 zsh 进程"),
                        CommandExample(command: "exec bash", explanation: "切换到 bash"),
                        CommandExample(command: "exec 3>file.txt", explanation: "打开文件描述符 3 用于写入"),
                        CommandExample(command: "exec 0< input.txt", explanation: "将 stdin 重定向到文件"),
                        CommandExample(command: "exec -a 'custom_name' /usr/bin/program", explanation: "以自定义名称运行程序"),
                        CommandExample(command: "exec python3 script.py", explanation: "替换当前 shell 为 python")
                    ],
                    commonOptions: [
                        (flag: "-l", description: "模拟为登录 shell（在 argv[0] 前加 -）"),
                        (flag: "-c", description: "使用空环境执行"),
                        (flag: "-a name", description: "设置 argv[0] 为 name"),
                        (flag: "command", description: "要替换的命令"),
                        (flag: "n>file", description: "将 fd n 重定向到文件")
                    ],
                    tips: "exec 替换进程（不返回），常用于脚本末尾切换程序或打开 fd"
                )
            ]
        ),

// MARK: - 磁盘与存储

        CommandCategory(
            name: "磁盘与存储",
            icon: "internaldrive",
            commands: [
                CommandItem(
                    name: "diskutil",
                    syntax: "diskutil [quiet] < verb > < arguments >",
                    description: "macOS 磁盘管理工具。",
                    examples: [
                        CommandExample(command: "diskutil list", explanation: "列出所有磁盘和分区"),
                        CommandExample(command: "diskutil info disk0", explanation: "查看磁盘详细信息"),
                        CommandExample(command: "diskutil eraseDisk APFS 'NewDisk' disk1", explanation: "格式化为 APFS"),
                        CommandExample(command: "diskutil mount disk2s1", explanation: "挂载分区"),
                        CommandExample(command: "diskutil unmount disk2s1", explanation: "卸载分区"),
                        CommandExample(command: "diskutil apfs list", explanation: "列出 APFS 容器和卷")
                    ],
                    commonOptions: [
                        (flag: "list", description: "列出所有磁盘和分区"),
                        (flag: "info disk", description: "显示磁盘详细信息"),
                        (flag: "info diskN", description: "显示磁盘详细信息"),
                        (flag: "eraseDisk FSType NAME DiskIdentifier", description: "格式化磁盘"),
                        (flag: "eraseVolume FSType NAME Device", description: "格式化卷"),
                        (flag: "mount Device", description: "挂载"),
                        (flag: "unmount Device", description: "卸载"),
                        (flag: "unmountDisk Device", description: "卸载整个磁盘"),
                        (flag: "mountDisk Device", description: "挂载磁盘所有卷"),
                        (flag: "rename Device NewName", description: "重命名卷"),
                        (flag: "repairVolume Device", description: "修复卷"),
                        (flag: "repairDisk Device", description: "修复磁盘"),
                        (flag: "verifyVolume Device", description: "验证卷"),
                        (flag: "apfs list", description: "列出 APFS 容器和卷"),
                        (flag: "apfs resizeContainer", description: "调整 APFS 容器大小"),
                        (flag: "resizeVolume Device size", description: "调整卷大小"),
                        (flag: "createVolume type name size device", description: "在 APFS 容器中创建卷")
                    ],
                    tips: "APFS 推荐格式，list 查看所有，info 查看详情"
                ),
                CommandItem(
                    name: "hdiutil",
                    syntax: "hdiutil < verb > < arguments >",
                    description: "macOS 磁盘映像工具（DMG/ISO/sparseimage）。",
                    examples: [
                        CommandExample(command: "hdiutil create -volname 'Disk' -fs HFS+ -size 100m ~/disk.dmg", explanation: "创建 100MB DMG"),
                        CommandExample(command: "hdiutil attach ~/disk.dmg", explanation: "挂载 DMG"),
                        CommandExample(command: "hdiutil detach /Volumes/Disk", explanation: "卸载"),
                        CommandExample(command: "hdiutil convert in.dmg -format UDTO -o out.cdr", explanation: "转换格式"),
                        CommandExample(command: "hdiutil info", explanation: "显示所有挂载的映像信息")
                    ],
                    commonOptions: [
                        (flag: "create", description: "创建磁盘映像"),
                        (flag: "attach", description: "挂载磁盘映像"),
                        (flag: "detach", description: "卸载磁盘映像"),
                        (flag: "convert", description: "转换磁盘映像格式"),
                        (flag: "info", description: "显示映像信息"),
                        (flag: "verify", description: "验证映像完整性"),
                        (flag: "resize", description: "调整映像大小"),
                        (flag: "erase", description: "擦除映像内容"),
                        (flag: "compact", description: "压缩 sparse 映像"),
                        (flag: "tag", description: "添加/删除标签"),
                        (flag: "-volname name", description: "指定卷名"),
                        (flag: "-fs fstype", description: "指定文件系统 (HFS+/APFS/ExFAT)"),
                        (flag: "-size NxM|G", description: "指定大小"),
                        (flag: "-format type", description: "指定格式 (UDZO/UDBZ/ULFO)"),
                        (flag: "-srcimagekey key", description: "指定源映像加密密钥"),
                        (flag: "UDZO", description: "zlib 压缩映像（最常用 DMG 格式）"),
                        (flag: "UDBZ", description: "bzip2 压缩映像"),
                        (flag: "ULFO", description: "lzfse 压缩映像（最快）")
                    ],
                    tips: "create 创建，attach 挂载，detach 卸载，UDZO 最常用格式"
                ),
                CommandItem(
                    name: "tmutil",
                    syntax: "tmutil < verb > < arguments >",
                    description: "Time Machine 备份管理工具。",
                    examples: [
                        CommandExample(command: "tmutil listbackups", explanation: "列出所有备份"),
                        CommandExample(command: "tmutil startbackup", explanation: "开始备份"),
                        CommandExample(command: "tmutil stopbackup", explanation: "停止当前备份"),
                        CommandExample(command: "tmutil status", explanation: "查看备份状态"),
                        CommandExample(command: "tmutil destinationinfo", explanation: "查看备份目的地信息"),
                        CommandExample(command: "tmutil compare /path/to/backup", explanation: "比较文件差异")
                    ],
                    commonOptions: [
                        (flag: "listbackups", description: "列出所有已完成的备份"),
                        (flag: "startbackup", description: "手动触发一次备份"),
                        (flag: "stopbackup", description: "停止正在进行的备份"),
                        (flag: "status", description: "显示当前备份状态"),
                        (flag: "destinationinfo", description: "显示备份目的地信息"),
                        (flag: "compare", description: "比较两个时间点的差异"),
                        (flag: "restore", description: "恢复备份"),
                        (flag: "removebackup", description: "删除指定的备份"),
                        (flag: "inheritbackup", description: "继承已有备份"),
                        (flag: "inheritbackup -d dest", description: "指定继承的目的地"),
                        (flag: "verifychecksums", description: "验证备份校验和"),
                        (flag: "snapshot", description: "创建快照"),
                        (flag: "deletelocalsnapshots date", description: "删除本地快照")
                    ],
                    tips: "startbackup 手动备份，listbackups 列出备份，status 查看状态"
                )
            ]
        ),

// MARK: - 开发工具

        CommandCategory(
            name: "开发工具",
            icon: "wrench.and.screwdriver",
            commands: [
                CommandItem(
                    name: "xcode-select",
                    syntax: "xcode-select [-h] [-p] [--print-path]\n     xcode-select -s < path >\n     xcode-select --switch < path >\n     xcode-select -r\n     xcode-select --reset\n     xcode-select --install",
                    description: "管理 Xcode 命令行工具路径。",
                    examples: [
                        CommandExample(command: "xcode-select -p", explanation: "显示当前 Xcode 路径"),
                        CommandExample(command: "xcode-select --install", explanation: "安装命令行工具"),
                        CommandExample(command: "sudo xcode-select -s /Applications/Xcode.app/Contents/Developer", explanation: "切换到完整 Xcode")
                    ],
                    commonOptions: [
                        (flag: "-p / --print-path", description: "显示当前开发者目录路径"),
                        (flag: "-s path / --switch path", description: "设置开发者目录路径"),
                        (flag: "-r / --reset", description: "重置为默认路径"),
                        (flag: "--install", description: "安装 Xcode 命令行工具")
                    ],
                    tips: "安装命令行工具后才能使用 git、clang 等"
                ),
                CommandItem(
                    name: "xcrun",
                    syntax: "xcrun [-sdk sdk_name | -sdk < path >] [-log] [-verbose] [-n] [-show-sdk-path] [-show-sdk-version] [-show-sdk-build-version] [-find < utility >] [-notarize < archive >] < utility > [arguments ...]",
                    description: "查找并运行 Xcode 工具。",
                    examples: [
                        CommandExample(command: "xcrun swift --version", explanation: "运行 Swift 编译器"),
                        CommandExample(command: "xcrun simctl list", explanation: "列出所有模拟器"),
                        CommandExample(command: "xcrun --show-sdk-path", explanation: "显示 SDK 路径"),
                        CommandExample(command: "xcrun -find clang", explanation: "查找 clang 位置")
                    ],
                    commonOptions: [
                        (flag: "-sdk name", description: "指定 SDK (iphoneos/macosx)"),
                        (flag: "--show-sdk-path", description: "显示 SDK 路径"),
                        (flag: "--show-sdk-version", description: "显示 SDK 版本"),
                        (flag: "--show-sdk-build-version", description: "显示 SDK 构建版本"),
                        (flag: "-find utility", description: "查找工具路径"),
                        (flag: "-log", description: "显示执行日志"),
                        (flag: "simctl", description: "iOS 模拟器控制"),
                        (flag: "altool", description: "App Store 上传工具"),
                        (flag: "notarytool", description: "公证工具")
                    ],
                    tips: "在多个 Xcode 版本间安全地使用工具"
                ),
                CommandItem(
                    name: "xattr",
                    syntax: "xattr [-l] file ...\n     xattr -d attr_name file ...\n     xattr -w attr_name attr_value file ...\n     xattr -c file ...",
                    description: "查看和操作文件的扩展属性。",
                    examples: [
                        CommandExample(command: "xattr file.txt", explanation: "显示文件的扩展属性"),
                        CommandExample(command: "xattr -d com.apple.quarantine app.app", explanation: "移除隔离属性"),
                        CommandExample(command: "xattr -lr directory/", explanation: "递归列出目录下所有扩展属性"),
                        CommandExample(command: "xattr -c file.txt", explanation: "清除所有扩展属性")
                    ],
                    commonOptions: [
                        (flag: "-d attr", description: "删除指定的扩展属性"),
                        (flag: "-w attr value", description: "写入/设置扩展属性"),
                        (flag: "-l", description: "列出文件的所有扩展属性"),
                        (flag: "-r", description: "递归处理目录下所有文件"),
                        (flag: "-c", description: "清除所有扩展属性"),
                        (flag: "-h", description: "不跟随符号链接"),
                        (flag: "-s", description: "显示属性值的大小")
                    ],
                    tips: "quarantine 隔离属性导致「来自未识别开发者」，-d 移除"
                ),
                CommandItem(
                    name: "codesign",
                    syntax: "codesign [-options] file ...\n     codesign -s identity [-c cert] [-d key=value] [--display] [-e entitlements] [-h hash-algo] [-i identifier] [-n requirements] [-o flags] [-r requirements] [--requirement language] [-S identity] [--sign] [--timestamp] [-v verbose] [--verify] file ...",
                    description: "macOS 代码签名工具。",
                    examples: [
                        CommandExample(command: "codesign -v /Applications/Safari.app", explanation: "验证签名"),
                        CommandExample(command: "codesign -s - app.app --deep --force", explanation: "重签名"),
                        CommandExample(command: "codesign -dv --verbose=4 app.app", explanation: "查看签名详情"),
                        CommandExample(command: "codesign --verify --deep --strict app.app", explanation: "严格验证")
                    ],
                    commonOptions: [
                        (flag: "-s identity", description: "指定签名身份 (- 表示 ad-hoc)"),
                        (flag: "-v", description: "验证代码签名"),
                        (flag: "--verify", description: "验证签名"),
                        (flag: "--deep", description: "递归签名嵌套 bundle"),
                        (flag: "--force", description: "强制覆盖已有签名"),
                        (flag: "-d", description: "显示签名详细信息"),
                        (flag: "--display", description: "显示签名属性"),
                        (flag: "-i id", description: "设置 bundle 标识符"),
                        (flag: "-o flags", description: "设置签名标志 (runtime)"),
                        (flag: "-r reqs", description: "设置签名要求"),
                        (flag: "--timestamp", description: "添加时间戳"),
                        (flag: "--timestamp=none", description: "不添加时间戳"),
                        (flag: "--options runtime", description: "启用运行时保护 ( hardened runtime )"),
                        (flag: "-e entitlements", description: "嵌入授权信息"),
                        (flag: "--sign", description: "指定签名身份的另一种语法"),
                        (flag: "--remove-signature", description: "移除签名")
                    ],
                    tips: "-s - ad-hoc 签名，--deep 递归签名，--options runtime 硬化运行时"
                ),
                CommandItem(
                    name: "plutil",
                    syntax: "plutil [-帮助] [-lint] [-p] [-convert format] [-r] [-e extension] [-s] [-o out_file] [-- [args]] file ...",
                    description: "Property List (plist) 文件检查和转换工具。",
                    examples: [
                        CommandExample(command: "plutil file.plist", explanation: "检查 plist 语法"),
                        CommandExample(command: "plutil -convert xml1 file.plist", explanation: "转换为 XML"),
                        CommandExample(command: "plutil -convert binary1 file.plist", explanation: "转换为二进制"),
                        CommandExample(command: "plutil -convert json file.plist", explanation: "转换为 JSON"),
                        CommandExample(command: "plutil -p file.plist", explanation: "以可读格式打印"),
                        CommandExample(command: "plutil -extract key json file.plist", explanation: "提取指定 key 的值")
                    ],
                    commonOptions: [
                        (flag: "-lint", description: "检查 plist 文件语法"),
                        (flag: "-p", description: "以可读格式打印 plist"),
                        (flag: "-convert format", description: "转换格式 (xml1/binary1/json)"),
                        (flag: "-extract key fmt", description: "提取指定 key 的值"),
                        (flag: "-replace key fmt value", description: "替换指定 key 的值"),
                        (flag: "-insert key fmt value", description: "插入新的键值"),
                        (flag: "-remove key", description: "删除指定的 key"),
                        (flag: "-r", description: "递归处理"),
                        (flag: "-o file", description: "指定输出文件"),
                        (flag: "-e ext", description: "指定输出文件扩展名"),
                        (flag: "-s", description: "静默模式（lint 不输出成功信息）"),
                        (flag: "--", description: "后续参数作为键值操作")
                    ],
                    tips: "xml1 XML，binary1 二进制，json JSON，-p 打印查看"
                ),
                CommandItem(
                    name: "otool",
                    syntax: "otool [-arch arch_type] [-fahlLDtdvotSqcrRSSmUGfV] [--mcpu=cpu] [--arch=arch] [--all-headers] [--dyld-info] [--data] [--machine] file ...",
                    description: "Mach-O 二进制文件分析工具。",
                    examples: [
                        CommandExample(command: "otool -L /usr/bin/ls", explanation: "查看动态库依赖"),
                        CommandExample(command: "otool -tv binary", explanation: "反汇编代码"),
                        CommandExample(command: "otool -h binary", explanation: "查看 Mach-O 头信息"),
                        CommandExample(command: "otool -l binary | grep -A5 LC_DYSYMTAB", explanation: "查看动态符号表"),
                        CommandExample(command: "otool -arch arm64 -l binary", explanation: "查看指定架构信息")
                    ],
                    commonOptions: [
                        (flag: "-L", description: "列出动态库依赖 (LC_LOAD_DYLIB)"),
                        (flag: "-t", description: "反汇编 __TEXT 段代码"),
                        (flag: "-tv", description: "详细反汇编（含地址）"),
                        (flag: "-h", description: "显示 Mach-O 头信息"),
                        (flag: "-l", description: "显示所有 load commands"),
                        (flag: "-o", description: "显示 Objective-C 运行时信息"),
                        (flag: "-a", description: "显示所有信息（等同 -hltov）"),
                        (flag: "-d", description: "显示 __DATA 段数据"),
                        (flag: "-s seg sect", description: "显示指定段/节的内容"),
                        (flag: "-c", description: "显示 ObjC 类名"),
                        (flag: "-r", description: "显示 Objective-C 元数据"),
                        (flag: "-S", description: "显示符号表"),
                        (flag: "-R", description: "显示间接符号表"),
                        (flag: "-f", description: "显示 Fat 头信息"),
                        (flag: "-arch name", description: "指定分析的架构")
                    ],
                    tips: "-L 查看库依赖最常用，-tv 反汇编，-l 查看 load commands"
                ),
                CommandItem(
                    name: "dtrace",
                    syntax: "dtrace [-aCefhLqsVvwxZ] [-b bufsz] [-c cmd] [-D name=val] [-o file] [-p pid] [-P provider] [-t probe] [-x opt=val] [-s file] [-I dir] [-U dir] [-C dir] [cmd | -c cmd | -p pid]",
                    description: "Dynamic Tracing — macOS 内核级动态追踪框架（需 root）。",
                    examples: [
                        CommandExample(command: "sudo dtrace -n 'syscall::open:entry { printf(\"%s\\n\", execname); }'", explanation: "追踪文件打开"),
                        CommandExample(command: "sudo dtrace -n 'profile-1001 { @[stack()] = count(); }'", explanation: "CPU 采样分析"),
                        CommandExample(command: "sudo dtrace -l | grep syscall", explanation: "列出所有 syscall 探针"),
                        CommandExample(command: "sudo dtrace -n 'io:::start { printf(\"%s\\n\", args[1]->fi_pathname); }'", explanation: "追踪 I/O 操作")
                    ],
                    commonOptions: [
                        (flag: "-n probe", description: "指定探针描述符"),
                        (flag: "-s file", description: "从文件读取 D 脚本"),
                        (flag: "-l", description: "列出所有可用探针"),
                        (flag: "-c cmd", description: "启动命令并在退出时停止"),
                        (flag: "-p pid", description: "追踪指定 PID"),
                        (flag: "-P provider", description: "指定提供者"),
                        (flag: "-t probe", description: "指定探针（同 -n）"),
                        (flag: "-o file", description: "输出到文件"),
                        (flag: "-q", description: "静默模式"),
                        (flag: "-b size", description: "设置缓冲区大小"),
                        (flag: "-e", description: "只编译不执行"),
                        (flag: "-x opt=val", description: "设置 DTrace 选项"),
                        (flag: "-D name=val", description: "定义宏常量"),
                        (flag: "-C dir", description: "C 预处理包含目录")
                    ],
                    tips: "极强大的系统调试工具，需 root，macOS 有 SIP 限制"
                ),
                CommandItem(
                    name: "sips",
                    syntax: "sips [options] src_file ... [-- output_file]\n     sips [options] -g property [src_file ...]",
                    description: "macOS 图像处理脚本工具（缩放、旋转、格式转换等）。",
                    examples: [
                        CommandExample(command: "sips -g pixelWidth -g pixelHeight image.jpg", explanation: "获取图片尺寸"),
                        CommandExample(command: "sips -z 800 600 image.jpg", explanation: "调整图片大小为 800x600"),
                        CommandExample(command: "sips -r 90 image.jpg", explanation: "顺时针旋转 90°"),
                        CommandExample(command: "sips -s format png input.jpg -- output.png", explanation: "转换格式为 PNG"),
                        CommandExample(command: "sips -s formatOptions 80 image.jpg -- output.jpg", explanation: "设置 JPEG 质量为 80%"),
                        CommandExample(command: "sips -Z 1024 image.jpg", explanation: "将最大边缩放到 1024px")
                    ],
                    commonOptions: [
                        (flag: "-g property", description: "获取图像属性 (pixelWidth/pixelHeight/format)"),
                        (flag: "-z width height", description: "调整大小（精确像素）"),
                        (flag: "-Z pixels", description: "将最大边缩放到指定像素"),
                        (flag: "-r degrees", description: "旋转（90/180/270）"),
                        (flag: "-s format fmt", description: "设置输出格式 (jpeg/png/tiff/gif)"),
                        (flag: "-s formatOptions val", description: "格式选项（如 JPEG 质量 1-100）"),
                        (flag: "-m format file", description: "将 ICC 配置文件转换"),
                        (flag: "-d outdir", description: "指定输出目录"),
                        (flag: "--resampleWidth w", description: "按宽度等比缩放"),
                        (flag: "--resampleHeight h", description: "按高度等比缩放"),
                        (flag: "--cropToHeightWidth", description: "裁剪到指定比例"),
                        (flag: "--getPropertyList", description: "以 plist 格式输出所有属性"),
                        (flag: "--setPropertyList plist", description: "从 plist 设置属性")
                    ],
                    tips: "macOS 内置图片处理，无需安装工具，-g 获取属性 -z 缩放"
                )
            ]
        ),

// MARK: - Zsh 独有语法

        CommandCategory(
            name: "Zsh 独有语法",
            icon: "terminal",
            commands: [
                CommandItem(
                    name: "参数展开修饰符",
                    syntax: "$" + "{var:offset:length}\n" + "$" + "{var#pattern}  " + "$" + "{var##pattern}\n" + "$" + "{var%pattern}  " + "$" + "{var%%pattern}\n" + "$" + "{var/pattern/replacement}  " + "$" + "{var//pattern/replacement}\n" + "$" + "{var:t}  " + "$" + "{var:r}  " + "$" + "{var:e}  " + "$" + "{var:h}\n" + "$" + "{var:u}  " + "$" + "{var:l}  " + "$" + "{var:q}  " + "$" + "{var:Q}  " + "$" + "{var:P}\n" + "$" + "{#var}  " + "$" + "{var:-default}  " + "$" + "{var:=default}  " + "$" + "{var:+value}  " + "$" + "{var:?error}",
                    description: "Zsh 参数展开（Parameter Expansion）修饰符，用于对变量值进行截取、替换、转换等操作。",
                    examples: [
                        CommandExample(command: "f=/path/to/file.tar.gz", explanation: "设一个测试路径"),
                        CommandExample(command: "echo $" + "{f:t}", explanation: "提取尾部文件名: file.tar.gz"),
                        CommandExample(command: "echo $" + "{f:r}", explanation: "去除扩展名: /path/to/file.tar"),
                        CommandExample(command: "echo $" + "{f:e}", explanation: "提取扩展名: gz"),
                        CommandExample(command: "echo $" + "{f:h}", explanation: "提取头部目录: /path/to"),
                        CommandExample(command: "echo $" + "{f:t:r}", explanation: "链式: file.tar（去掉最后扩展名）"),
                        CommandExample(command: "echo $" + "{f:t:r:r}", explanation: "链式: file（再去一层）"),
                        CommandExample(command: "echo $" + "{#f}", explanation: "字符串长度"),
                        CommandExample(command: "echo $" + "{var:-default}", explanation: "变量为空时使用默认值"),
                        CommandExample(command: "echo $" + "{var:=default}", explanation: "变量为空时赋值并使用默认值"),
                        CommandExample(command: "echo $" + "{var:+value}", explanation: "变量非空时使用替代值"),
                        CommandExample(command: "echo $" + "{var:?error msg}", explanation: "变量为空时报错退出"),
                        CommandExample(command: "echo $" + "{f:u}", explanation: "首字母大写"),
                        CommandExample(command: "echo $" + "{f:l}", explanation: "全部转小写")
                    ],
                    commonOptions: [
                        (flag: "$" + "{var:t}", description: "提取尾部（Tail）: 去掉目录前缀，只留文件名"),
                        (flag: "$" + "{var:r}", description: "提取根部（Root）: 去掉最后一个扩展名"),
                        (flag: "$" + "{var:e}", description: "提取扩展名（Extension）: 最后一个 . 之后的部分"),
                        (flag: "$" + "{var:h}", description: "提取头部（Head）: 去掉文件名，只留目录"),
                        (flag: "$" + "{var:u}", description: "首字母大写"),
                        (flag: "$" + "{var:U}", description: "全部转为大写"),
                        (flag: "$" + "{var:l}", description: "全部转为小写"),
                        (flag: "$" + "{var:a}", description: "作为数组返回"),
                        (flag: "$" + "{var:A}", description: "完整展开（恢复原始类型）"),
                        (flag: "$" + "{var:q}", description: "Shell 引用（转义特殊字符）"),
                        (flag: "$" + "{var:Q}", description: "深层引用"),
                        (flag: "$" + "{var:P}", description: "物理路径（解析符号链接）"),
                        (flag: "$" + "{var:offset:length}", description: "从 offset 截取 length 个字符"),
                        (flag: "$" + "{var#pattern}", description: "从左删除最短匹配"),
                        (flag: "$" + "{var##pattern}", description: "从左删除最长匹配（贪婪）"),
                        (flag: "$" + "{var%pattern}", description: "从右删除最短匹配"),
                        (flag: "$" + "{var%%pattern}", description: "从右删除最长匹配（贪婪）"),
                        (flag: "$" + "{var/pat/rep}", description: "替换第一个匹配"),
                        (flag: "$" + "{var//pat/rep}", description: "替换所有匹配"),
                        (flag: "$" + "{#var}", description: "获取字符串/数组长度"),
                        (flag: "$" + "{var:-default}", description: "为空时返回 default"),
                        (flag: "$" + "{var:=default}", description: "为空时赋值并返回"),
                        (flag: "$" + "{var:+value}", description: "非空时返回替代值"),
                        (flag: "$" + "{var:?error}", description: "为空时报错退出")
                    ],
                    tips: "修饰符可链式使用: $" + "{f:t:r} 去掉最后一层扩展名"
                ),
                CommandItem(
                    name: "Glob 限定符",
                    syntax: "*(qualifier)\n(list)*(qualifier)",
                    description: "Zsh 独有的 Glob 限定符，在 glob 模式后附加过滤条件，精确匹配文件类型、大小、时间等。",
                    examples: [
                        CommandExample(command: "*(.)", explanation: "只匹配普通文件（排除目录）"),
                        CommandExample(command: "*(/)", explanation: "只匹配目录"),
                        CommandExample(command: "*(*)", explanation: "只匹配可执行文件"),
                        CommandExample(command: "*(N)", explanation: "null_glob: 无匹配时不报错"),
                        CommandExample(command: "*(@)", explanation: "只匹配符号链接"),
                        CommandExample(command: "*.(jpg|png)(.)", explanation: "只匹配 jpg/png 普通文件"),
                        CommandExample(command: "*(om[1,3])", explanation: "按修改时间排序取前3个"),
                        CommandExample(command: "*(Lm+100)", explanation: "大于 100MB 的文件"),
                        CommandExample(command: "*(m0)", explanation: "今天修改过的文件"),
                        CommandExample(command: "*(U)", explanation: "当前用户拥有的文件")
                    ],
                    commonOptions: [
                        (flag: "(.)", description: "只匹配普通文件"),
                        (flag: "(/)", description: "只匹配目录"),
                        (flag: "(*)", description: "只匹配可执行文件"),
                        (flag: "(@)", description: "只匹配符号链接"),
                        (flag: "(p)", description: "只匹配 FIFO（命名管道）"),
                        (flag: "(=)", description: "只匹配 socket 文件"),
                        (flag: "(N)", description: "null_glob: 无匹配时不报错"),
                        (flag: "(D)", description: "包括隐藏文件（以 . 开头）"),
                        (flag: "(F)", description: "返回完整路径"),
                        (flag: "(M)", description: "逗号分隔输出"),
                        (flag: "(oN)", description: "不排序"),
                        (flag: "(om)", description: "按修改时间排序"),
                        (flag: "(os)", description: "按大小排序"),
                        (flag: "(O)", description: "反转排序"),
                        (flag: "([N,M])", description: "限制返回第 N 到 M 个结果"),
                        (flag: "(Lm+N)", description: "文件大小 > N MB"),
                        (flag: "(m0)", description: "今天修改的"),
                        (flag: "(mh+N)", description: "N 小时内修改的"),
                        (flag: "(e[expr])", description: "执行任意表达式"),
                        (flag: "(U)", description: "所有者是当前用户")
                    ],
                    tips: "*(.) 只文件，*(/) 只目录，(N) 抑制空报错"
                ),
                CommandItem(
                    name: "扩展 Glob 模式",
                    syntax: "^pattern    不匹配\n~pattern    排除\n*(pattern)  任意次\n?(pattern)  零或一次\n+(pattern)  一或多次\n@(pat|pat)  精确匹配\n!(pattern)  不匹配\n**          递归匹配",
                    description: "Zsh 扩展 Glob 模式，需 setopt EXTENDED_GLOB 启用。",
                    examples: [
                        CommandExample(command: "setopt EXTENDED_GLOB", explanation: "启用扩展 Glob"),
                        CommandExample(command: "^*.md", explanation: "匹配所有非 .md 文件"),
                        CommandExample(command: "+(*.md|*.txt)", explanation: "匹配 .md 或 .txt"),
                        CommandExample(command: "ls **/*.swift", explanation: "递归匹配所有 .swift"),
                        CommandExample(command: "ls *(.)", explanation: "只匹配普通文件"),
                        CommandExample(command: "rm **/*.pyc(N)", explanation: "递归删除 .pyc（无报错）")
                    ],
                    commonOptions: [
                        (flag: "^pattern", description: "取反：不匹配 pattern"),
                        (flag: "~pattern", description: "排除匹配的文件"),
                        (flag: "*(pat)", description: "零次或多次匹配"),
                        (flag: "?(pat)", description: "零次或一次匹配"),
                        (flag: "+(pat)", description: "一次或多次匹配"),
                        (flag: "@(pat1|pat2)", description: "精确匹配（任选一）"),
                        (flag: "!(pat)", description: "不匹配"),
                        (flag: "**", description: "递归通配"),
                        (flag: "(#e)", description: "扩展：文件存在性检查"),
                        (flag: "(#i)", description: "扩展：忽略大小写"),
                        (flag: "(#l)", description: "扩展：小写匹配"),
                        (flag: "(#u)", description: "扩展：大写匹配"),
                        (flag: "(#b)", description: "扩展：启用 backreferences"),
                        (flag: "(#m)", description: "扩展：保存匹配内容到 MATCH")
                    ],
                    tips: "需先 setopt EXTENDED_GLOB，^ 取反，** 递归"
                ),
                CommandItem(
                    name: "Zsh 重定向操作符",
                    syntax: "[n]>word       重定向\n[n]>>word      追加\n[n]>|word      强制重定向\n[n]<word        输入重定向\n[n1>&n2         复制 fd\n[n1>&-          关闭 fd\n&>word          stdout+stderr\n|&             管道传递 stderr\n<(cmd)         进程替换\n>(cmd)         进程替换输出",
                    description: "Zsh 相比 Bash 提供了更丰富的文件描述符重定向操作符。",
                    examples: [
                        CommandExample(command: "cmd &> output.txt", explanation: "stdout+stderr 重定向到文件"),
                        CommandExample(command: "cmd &>> output.txt", explanation: "stdout+stderr 追加到文件"),
                        CommandExample(command: "cmd >| force.txt", explanation: "强制覆盖（忽略 noclobber）"),
                        CommandExample(command: "cmd |& grep error", explanation: "管道传递 stderr（Zsh 特有）"),
                        CommandExample(command: "diff <(cat a.txt) <(cat b.txt)", explanation: "进程替换比较两个文件"),
                        CommandExample(command: "exec 3>file.txt", explanation: "打开 fd 3 用于写入"),
                        CommandExample(command: "echo data >&3", explanation: "通过 fd 3 写入"),
                        CommandExample(command: "exec 3>&-", explanation: "关闭 fd 3")
                    ],
                    commonOptions: [
                        (flag: "> file", description: "stdout 重定向（覆盖）"),
                        (flag: ">> file", description: "stdout 追加"),
                        (flag: ">| file", description: "强制覆盖（忽略 noclobber）"),
                        (flag: "< file", description: "文件作为 stdin"),
                        (flag: "&> file", description: "stdout+stderr 重定向"),
                        (flag: "&>> file", description: "stdout+stderr 追加"),
                        (flag: "|&", description: "管道传递 stderr（Zsh 特有）"),
                        (flag: "n>&m", description: "fd m 复制到 fd n"),
                        (flag: "n>&-", description: "关闭 fd n 输出"),
                        (flag: "n<&-", description: "关闭 fd n 输入"),
                        (flag: "<(cmd)", description: "进程替换：stdout 作为临时文件"),
                        (flag: ">(cmd)", description: "进程替换：写入 stdin"),
                        (flag: "2>file", description: "只重定向 stderr"),
                        (flag: "2>&1", description: "stderr 到 stdout"),
                        (flag: "noclobber", description: "防止覆盖（用 >| 强制）")
                    ],
                    tips: "&> 简写重定向，|& 管道传 stderr，<(cmd) 进程替换"
                ),
                CommandItem(
                    name: "Zsh 数组操作",
                    syntax: "arr=(elem1 elem2 ...)\n" + "$" + "{arr}          所有元素\n" + "$" + "{arr[@]}       所有元素（带引号）\n" + "$" + "{#arr[@]}      数组长度\n" + "$" + "{arr[n]}       第 n 个元素（从1开始）\n" + "$" + "{arr[n,m]}     切片\n" + "$" + "{(f)var}       按换行分割为数组\n" + "$" + "{(s:,:)var}    按指定分隔符分割\n" + "$" + "{^arr}         交叉展开（N叉积）",
                    description: "Zsh 数组是 0-indexed（不同于 Bash 的 1-indexed），支持强大的切片、搜索和展开。",
                    examples: [
                        CommandExample(command: "arr=(apple banana cherry)", explanation: "创建数组"),
                        CommandExample(command: "echo $" + "{arr}", explanation: "所有元素: apple banana cherry"),
                        CommandExample(command: "echo $" + "{#arr[@]}", explanation: "数组长度: 3"),
                        CommandExample(command: "echo $" + "{arr[1]}", explanation: "第一个元素: apple"),
                        CommandExample(command: "echo $" + "{arr[2,3]}", explanation: "第2到第3个: banana cherry"),
                        CommandExample(command: "echo $" + "{(f)path_list}", explanation: "按换行分割为数组"),
                        CommandExample(command: "arr+=(date)", explanation: "追加元素"),
                        CommandExample(command: "echo $" + "{arr[-1]}", explanation: "最后一个元素")
                    ],
                    commonOptions: [
                        (flag: "$" + "{arr}", description: "所有元素（空格分隔）"),
                        (flag: "$" + "{arr[@]}", description: "所有元素（保持独立性）"),
                        (flag: "$" + "{#arr[@]}", description: "数组长度"),
                        (flag: "$" + "{arr[n]}", description: "第 n 个元素（从 1 开始！）"),
                        (flag: "$" + "{arr[n,m]}", description: "切片：第 n 到 m 个"),
                        (flag: "$" + "{arr[-1]}", description: "最后一个元素（负索引）"),
                        (flag: "$" + "{(s:delim:)var}", description: "按分隔符分割为数组"),
                        (flag: "$" + "{(f)var}", description: "按换行分割为数组"),
                        (flag: "$" + "{(w)var}", description: "按空白分割为数组"),
                        (flag: "$" + "{^(arr)}", description: "交叉展开（N叉积）"),
                        (flag: "$" + "{(pk)assoc}", description: "关联数组的键"),
                        (flag: "$" + "{(pv)assoc}", description: "关联数组的值"),
                        (flag: "$" + "{arr[(r)pat]}", description: "正向搜索匹配的元素"),
                        (flag: "$" + "{arr[(I)pat]}", description: "反向搜索匹配的索引"),
                        (flag: "arr+=(val)", description: "追加元素"),
                        (flag: "typeset -A assoc", description: "声明关联数组")
                    ],
                    tips: "Zsh 数组从 1 开始！$" + "{arr[1]} 第一个，$" + "{arr[-1]} 最后一个"
                ),
                CommandItem(
                    name: "Zsh 代换与条件表达式",
                    syntax: "$" + "{var:=value}   赋默认值\n" + "$" + "{var:-value}   返回默认值\n" + "$" + "{var:+value}   返回替代值\n" + "$" + "{var:?error}   报错退出\n==              模式匹配测试\n=~              正则匹配测试",
                    description: "Zsh 条件表达式和变量替换语法。",
                    examples: [
                        CommandExample(command: "echo $" + "{name:-Guest}", explanation: "name 为空时输出 Guest"),
                        CommandExample(command: "echo $" + "{PATH:=/usr/bin}", explanation: "PATH 为空时设为 /usr/bin"),
                        CommandExample(command: "echo $" + "{DEBUG:+'Debug is on'}", explanation: "DEBUG 非空时输出提示"),
                        CommandExample(command: "[[ $file == *.jpg ]]", explanation: "模式匹配：是否为 .jpg"),
                        CommandExample(command: "[[ $file == (foo|bar)* ]]", explanation: "是否以 foo 或 bar 开头"),
                        CommandExample(command: "[[ $str =~ ^[0-9]+$ ]]", explanation: "正则：是否纯数字")
                    ],
                    commonOptions: [
                        (flag: "$" + "{var:-value}", description: "var 为空时返回 value"),
                        (flag: "$" + "{var:=value}", description: "var 为空时赋值并返回"),
                        (flag: "$" + "{var:+value}", description: "var 非空时返回替代值"),
                        (flag: "$" + "{var:?error}", description: "var 为空时报错退出"),
                        (flag: "== pattern", description: "[[ ]] 中的模式匹配"),
                        (flag: "=~ regex", description: "[[ ]] 中的正则匹配"),
                        (flag: "-eq / -ne / -lt / -gt", description: "数值比较"),
                        (flag: "-z / -n", description: "字符串为空/非空"),
                        (flag: "-f / -d / -e / -r / -w / -x", description: "文件测试"),
                        (flag: "-nt / -ot", description: "文件更新/更旧")
                    ],
                    tips: ":= 赋值并返回 :+ 替代值 :? 报错，=~ 正则匹配"
                ),
                CommandItem(
                    name: "Zsh 提示符转义序列",
                    syntax: "%n 用户名  %h 主机名  %d 完整路径\n%~ 智能路径  %# %或#  %t HH:MM\n%? 上次退出码  %D 日期  %* 完整时间\n%B粗体  %U下划线  %S高亮\n%F{color}前景色  %K{color}背景色\n%(?.success.fail) 条件表达式",
                    description: "Zsh PROMPT 变量中的转义序列，用于自定义 shell 提示符。",
                    examples: [
                        CommandExample(command: "PROMPT=%n@%h %~ %# ", explanation: "user@host ~/dir %"),
                        CommandExample(command: "PROMPT=%F{green}%n%f@%F{blue}%h%f %~ %# ", explanation: "彩色用户名和主机名"),
                        CommandExample(command: "PROMPT=%(?.%F{green}✓.%F{red}✗)%f %~ %# ", explanation: "成功/失败不同符号"),
                        CommandExample(command: "RPROMPT=%~ %t", explanation: "右侧提示符显示目录和时间"),
                        CommandExample(command: "PROMPT=%B%S%f%~%s%b %# ", explanation: "目录高亮显示"),
                        CommandExample(command: "PROMPT=%(1j.%j jobs .) %# ", explanation: "有后台任务时显示任务数")
                    ],
                    commonOptions: [
                        (flag: "%n", description: "当前用户名"),
                        (flag: "%h", description: "主机名（截断到第一个 .）"),
                        (flag: "%H", description: "完整主机名"),
                        (flag: "%d", description: "当前完整路径"),
                        (flag: "%~", description: "智能路径（~ 替代主目录）"),
                        (flag: "%1~", description: "只显示最后 1 层目录"),
                        (flag: "%# ", description: "提示符（% 或 #）"),
                        (flag: "%?", description: "上次退出状态码"),
                        (flag: "%(.success.fail)", description: "条件：成功/失败分别显示"),
                        (flag: "%t / %T", description: "时间 HH:MM / HH:MM:SS"),
                        (flag: "%D / %*", description: "日期 / 完整时间"),
                        (flag: "%l", description: "终端名"),
                        (flag: "%B / %b", description: "粗体 开始/结束"),
                        (flag: "%U / %u", description: "下划线 开始/结束"),
                        (flag: "%S / %s", description: "高亮 开始/结束"),
                        (flag: "%F{color} / %f", description: "前景色 开始/结束"),
                        (flag: "%K{color} / %k", description: "背景色 开始/结束"),
                        (flag: "%{string%}", description: "不可打印字符串包装"),
                        (flag: "%%", description: "字面量 %"),
                        (flag: "RPROMPT", description: "右侧提示符变量"),
                        (flag: "SPROMPT", description: "拼写纠正提示符变量")
                    ],
                    tips: "%~ 智能路径，%(?.success.fail) 条件，RPROMPT 右侧"
                ),
                CommandItem(
                    name: "Zsh 作业控制",
                    syntax: "%job_spec  引用作业\n&          后台运行\nfg %N      调回前台\nbg %N      后台继续\ndisown %N  从作业列表移除\njobs -l    列出后台任务\nwait       等待所有后台任务",
                    description: "Zsh 独有的作业控制增强功能，包括更强大的 %job 引用语法。",
                    examples: [
                        CommandExample(command: "sleep 100 &", explanation: "后台运行"),
                        CommandExample(command: "jobs -l", explanation: "列出所有后台任务"),
                        CommandExample(command: "fg %1", explanation: "调回前台"),
                        CommandExample(command: "disown %1", explanation: "从作业列表移除"),
                        CommandExample(command: "fg %sleep", explanation: "调回以 sleep 开头的任务"),
                        CommandExample(command: "fg %?foo", explanation: "调回包含 foo 的任务")
                    ],
                    commonOptions: [
                        (flag: "%N", description: "引用作业编号 N"),
                        (flag: "%string", description: "引用命令以 string 开头的作业"),
                        (flag: "%?string", description: "引用命令中包含 string 的作业"),
                        (flag: "%+", description: "引用当前作业"),
                        (flag: "%-", description: "引用上一个作业"),
                        (flag: "disown %N", description: "从作业表移除（关闭终端不受影响）"),
                        (flag: "wait", description: "等待所有后台作业完成"),
                        (flag: "jobs -l", description: "列出所有作业及 PID"),
                        (flag: "jobs -r", description: "只显示运行中的作业"),
                        (flag: "jobs -s", description: "只显示停止的作业")
                    ],
                    tips: "%N 引用作业，disown 让进程脱离 shell 管理"
                ),
                CommandItem(
                    name: "setopt 选项",
                    syntax: "setopt option_name     启用\nunsetopt option_name  禁用\nsetopt                查看所有选项",
                    description: "Zsh 通过 setopt/unsetopt 控制 shell 行为。",
                    examples: [
                        CommandExample(command: "setopt EXTENDED_GLOB", explanation: "启用扩展 Glob"),
                        CommandExample(command: "setopt AUTO_CD", explanation: "输入目录名自动 cd"),
                        CommandExample(command: "setopt AUTO_PUSHD", explanation: "cd 时自动压栈"),
                        CommandExample(command: "setopt CORRECT", explanation: "命令拼写纠正"),
                        CommandExample(command: "setopt GLOB_DOTS", explanation: "通配符匹配隐藏文件"),
                        CommandExample(command: "setopt SHARE_HISTORY", explanation: "多终端共享历史"),
                        CommandExample(command: "setopt HIST_IGNORE_ALL_DUPS", explanation: "去除所有重复历史"),
                        CommandExample(command: "setopt NO_CLOBBER", explanation: "防止 > 覆盖已有文件")
                    ],
                    commonOptions: [
                        (flag: "EXTENDED_GLOB", description: "启用扩展 Glob 模式"),
                        (flag: "AUTO_CD", description: "输入目录名自动 cd"),
                        (flag: "AUTO_PUSHD", description: "cd 时自动压栈"),
                        (flag: "PUSHD_IGNORE_DUPS", description: "压栈时忽略重复"),
                        (flag: "CHASE_LINKS", description: "cd 时解析符号链接"),
                        (flag: "CORRECT", description: "命令拼写纠正"),
                        (flag: "CORRECT_ALL", description: "参数也纠正"),
                        (flag: "GLOB_DOTS", description: "通配符匹配隐藏文件"),
                        (flag: "NULL_GLOB", description: "无匹配时返回空（不报错）"),
                        (flag: "NO_CLOBBER", description: "防止 > 覆盖（用 >| 强制）"),
                        (flag: "INTERACTIVE_COMMENTS", description: "交互模式允许注释"),
                        (flag: "HIST_IGNORE_DUPS", description: "不记录连续重复"),
                        (flag: "HIST_IGNORE_ALL_DUPS", description: "去除所有重复历史"),
                        (flag: "HIST_IGNORE_SPACE", description: "不记录空格开头的命令"),
                        (flag: "SHARE_HISTORY", description: "多终端共享历史"),
                        (flag: "INC_APPEND_HISTORY", description: "实时追加历史"),
                        (flag: "RM_STAR_SILENT", description: "rm * 不提示确认"),
                        (flag: "XTRACE", description: "调试模式"),
                        (flag: "PROMPT_SUBST", description: "提示符中启用展开")
                    ],
                    tips: "常用: AUTO_CD CORRECT SHARE_HISTORY HIST_IGNORE_ALL_DUPS"
                ),
                CommandItem(
                    name: "Zle 快捷键",
                    syntax: "Ctrl+A 行首  Ctrl+E 行尾  Ctrl+U 删前行\nCtrl+K 删后行  Ctrl+W 删前词  Ctrl+Y 粘贴\nCtrl+R 搜索历史  Ctrl+T 交换字符\nCtrl+L 清屏  Ctrl+D EOF\nCtrl+X Ctrl+E 在 $EDITOR 中编辑\nAlt+. 插入上次参数  Alt+U/L/C 大小写转换",
                    description: "Zsh Line Editor (ZLE) 快捷键，用于高效编辑命令行输入。",
                    examples: [
                        CommandExample(command: "Ctrl+R", explanation: "反向增量搜索历史"),
                        CommandExample(command: "Ctrl+X Ctrl+E", explanation: "在 $EDITOR 中编辑当前命令"),
                        CommandExample(command: "Alt+.", explanation: "插入上一条命令的最后参数（循环）"),
                        CommandExample(command: "Ctrl+U", explanation: "删除光标前所有内容"),
                        CommandExample(command: "Ctrl+K", explanation: "删除光标后所有内容"),
                        CommandExample(command: "Ctrl+W", explanation: "删除前一个单词"),
                        CommandExample(command: "Alt+U", explanation: "单词转大写"),
                        CommandExample(command: "Alt+L", explanation: "单词转小写"),
                        CommandExample(command: "Alt+C", explanation: "单词首字母大写")
                    ],
                    commonOptions: [
                        (flag: "Ctrl+A", description: "光标移到行首"),
                        (flag: "Ctrl+E", description: "光标移到行尾"),
                        (flag: "Ctrl+U", description: "删除光标前所有内容"),
                        (flag: "Ctrl+K", description: "删除光标后所有内容"),
                        (flag: "Ctrl+W", description: "删除前一个单词"),
                        (flag: "Alt+D", description: "删除后一个单词"),
                        (flag: "Ctrl+Y", description: "粘贴（yank）"),
                        (flag: "Ctrl+T", description: "交换光标前两个字符"),
                        (flag: "Alt+T", description: "交换光标前两个单词"),
                        (flag: "Ctrl+R", description: "反向增量搜索历史"),
                        (flag: "Ctrl+P", description: "上一条历史命令"),
                        (flag: "Ctrl+N", description: "下一条历史命令"),
                        (flag: "Ctrl+L", description: "清屏"),
                        (flag: "Ctrl+D", description: "EOF / 退出"),
                        (flag: "Ctrl+Z", description: "暂停进程"),
                        (flag: "Ctrl+X Ctrl+E", description: "在编辑器中编辑命令"),
                        (flag: "Alt+.", description: "插入上次命令的最后参数"),
                        (flag: "Alt+-", description: "插入上次命令的最后参数（单次）"),
                        (flag: "Alt+U", description: "光标到单词末尾转大写"),
                        (flag: "Alt+L", description: "光标到单词末尾转小写"),
                        (flag: "Alt+C", description: "光标到单词末尾首字母大写"),
                        (flag: "Alt+R", description: "撤销上一次编辑")
                    ],
                    tips: "Alt+. 最实用——快速复用上次路径参数"
                ),
                CommandItem(
                    name: "Zle 绑定配置",
                    syntax: "bindkey -e          Emacs 模式\nbindkey -v          Vi 模式\nbindkey [key] func  绑定按键\nbindkey -l          列出所有绑定\nbindkey -M map     操作按键映射",
                    description: "Zsh ZLE 支持 Emacs 和 Vi 两种编辑模式，可通过 bindkey 进行按键绑定。",
                    examples: [
                        CommandExample(command: "bindkey -e", explanation: "设置 Emacs 编辑模式"),
                        CommandExample(command: "bindkey -v", explanation: "设置 Vi 编辑模式"),
                        CommandExample(command: "bindkey '^[[Z' reverse-menu-complete", explanation: "Shift+Tab 反向补全"),
                        CommandExample(command: "bindkey '^[[H' beginning-of-line", explanation: "Home 键到行首"),
                        CommandExample(command: "bindkey '^[[F' end-of-line", explanation: "End 键到行尾"),
                        CommandExample(command: "bindkey -l", explanation: "列出所有可用的 ZLE 函数")
                    ],
                    commonOptions: [
                        (flag: "-e", description: "Emacs 模式（默认）"),
                        (flag: "-v", description: "Vi 模式"),
                        (flag: "-l", description: "列出所有可用 ZLE 函数"),
                        (flag: "-L", description: "以 bindkey 格式列出绑定"),
                        (flag: "-r key", description: "删除绑定"),
                        (flag: "-s key seq", description: "绑定按键到字符串"),
                        (flag: "-M keymap", description: "操作指定按键映射表"),
                        (flag: "-N widget", description: "创建新 widget"),
                        (flag: "-U widget", description: "标记为用户 widget"),
                        (flag: "-f widget", description: "标记为特殊 widget"),
                        (flag: "keymap name", description: "切换按键映射表"),
                        (flag: "-d", description: "删除指定绑定"),
                        (flag: "-A", description: "从别名创建绑定")
                    ],
                    tips: "Emacs 模式更常用：Ctrl+A 行首 Ctrl+E 行尾 Ctrl+R 搜索"
                )
            ]
        ),

// MARK: - 网络工具追加

        CommandCategory(
            name: "远程传输",
            icon: "arrow.triangle.2.circlepath",
            commands: [
                CommandItem(
                    name: "sftp",
                    syntax: "sftp [-v] [-b batchfile] [-o ssh_option] [-P port] [-R num_requests] [-s subsystem | sftp_server] [-C] [-o forwardoption] [-J jump_option] [user@]hostname [file ...]\n     sftp [-v] [-b batchfile] [-o ssh_option] [-P port] [-R num_requests] [-s subsystem | sftp_server] [-C] [-o forwardoption] [-J jump_option] [file ... [[user@]host:]path ... [[user@]host:]path ...]",
                    description: "安全文件传输协议客户端，通过 SSH 加密连接传输文件。支持交互式和批处理两种模式。",
                    examples: [
                        CommandExample(command: "sftp user@host", explanation: "交互式连接远程 SFTP"),
                        CommandExample(command: "sftp -b batch.txt user@host", explanation: "批处理模式执行命令文件"),
                        CommandExample(command: "sftp user@host:/remote/file.txt ./local/", explanation: "下载单个文件"),
                        CommandExample(command: "sftp user@host", explanation: "交互模式后: get file.txt"),
                        CommandExample(command: "sftp user@host", explanation: "交互模式后: put local.txt"),
                        CommandExample(command: "sftp -P 2222 user@host", explanation: "指定端口连接"),
                        CommandExample(command: "sftp -C user@host", explanation: "启用压缩传输")
                    ],
                    commonOptions: [
                        (flag: "-b file", description: "指定批处理命令文件（每行一条 SFTP 命令）"),
                        (flag: "-P port", description: "指定 SSH 端口（默认 22）"),
                        (flag: "-C", description: "启用压缩传输"),
                        (flag: "-v", description: "详细调试输出"),
                        (flag: "-R num", description: "同时请求的请求数（提高大文件传输速度）"),
                        (flag: "-J jump", description: "通过跳板机连接 (ProxyJump)"),
                        (flag: "-o opt", description: "传递 SSH 选项"),
                        (flag: "-s subsystem", description: "指定 sftp-server 子系统"),
                        (flag: "-r", description: "递归传输目录"),
                        (flag: "-f", description: "强制已存在的文件"),
                        (flag: "-p", description: "保留权限和时间戳"),
                        (flag: "-PRESERVETIME", description: "保留修改时间"),
                        (flag: "-R", description: "指定预读请求队列长度")
                    ],
                    tips: "交互模式常用命令: ls cd pwd get put rm mkdir rmdir rename"
                ),
                CommandItem(
                    name: "lftp",
                    syntax: "lftp [-e cmd] [-u user[,pass]] [-p port] [host]\n     lftp -f script_file\n     lftp -c commands",
                    description: "功能强大的交互式文件传输工具，支持 FTP/FTPS/HTTP/HTTPS/SFTP/WebDAV/S3 等协议。",
                    examples: [
                        CommandExample(command: "lftp -u user,password sftp://host", explanation: "SFTP 连接（命令行传密码）"),
                        CommandExample(command: "lftp -e 'mirror --reverse dir/ /remote/; quit' host", explanation: "镜像上传目录"),
                        CommandExample(command: "lftp -e 'mirror /remote/ ./local/; quit' host", explanation: "镜像下载目录"),
                        CommandExample(command: "lftp -c 'set sftp:auto-confirm yes; open sftp://host; get file.txt'", explanation: "非交互式下载"),
                        CommandExample(command: "lftp host", explanation: "交互模式: mirror -R ./dir/ /remote/")
                    ],
                    commonOptions: [
                        (flag: "-e cmd", description: "连接后执行命令（非交互式）"),
                        (flag: "-c commands", description: "直接执行命令字符串"),
                        (flag: "-f file", description: "从文件读取命令"),
                        (flag: "-u user,pass", description: "指定用户名和密码"),
                        (flag: "-p port", description: "指定端口"),
                        (flag: "mirror -R", description: "反向镜像（上传整个目录）"),
                        (flag: "mirror -c", description: "只传输新/修改的文件（增量同步）"),
                        (flag: "mirror --delete", description: "删除目标中多余的文件"),
                        (flag: "mirror --exclude pattern", description: "排除匹配的文件"),
                        (flag: "mirror --parallel=N", description: "并行传输 N 个文件"),
                        (flag: "mirror --only-newer", description: "只传输更新的文件"),
                        (flag: "set ftp:ssl-allow no", description: "禁用 SSL"),
                        (flag: "set sftp:auto-confirm yes", description: "自动确认主机密钥"),
                        (flag: "put -c file", description: "上传文件（断点续传）"),
                        (flag: "pget -c file", description: "多线程下载文件"),
                        (flag: "queue put file", description: "将上传加入队列"),
                        (flag: "cat file", description: "查看远程文件内容"),
                        (flag: "zcat file", description: "查看远程 gz 文件内容"),
                        (flag: "zgrep pattern file", description: "在远程 gz 文件中搜索"),
                        (flag: "edit file", description: "远程编辑文件"),
                        (flag: "mkdir -p dir", description: "递归创建远程目录"),
                        (flag: "rm -rf dir", description: "递归删除远程目录"),
                        (flag: "chmod 755 file", description: "修改远程文件权限"),
                        (flag: "chmod -R 644 dir", description: "递归修改远程目录权限")
                    ],
                    tips: "mirror -R 递归上传最实用，-c 增量同步，pget 多线程下载"
                ),
                CommandItem(
                    name: "sshpass",
                    syntax: "sshpass [-p password] [-f file] [-e] [-P port] [-o ssh_options] command",
                    description: "非交互式 SSH 密码输入工具。⚠️ 密码会在命令行可见，仅限内网/自动化使用。",
                    examples: [
                        CommandExample(command: "sshpass -p 'pass' ssh user@host", explanation: "密码登录 SSH"),
                        CommandExample(command: "sshpass -f passfile.txt ssh user@host", explanation: "从文件读取密码"),
                        CommandExample(command: "sshpass -p 'pass' scp file.txt user@host:/path/", explanation: "密码登录 SCP"),
                        CommandExample(command: "sshpass -e -p $MYPASS ssh user@host", explanation: "从环境变量读取密码"),
                        CommandExample(command: "sshpass -p 'pass' ssh -o StrictHostKeyChecking=no user@host", explanation: "跳过主机密钥验证")
                    ],
                    commonOptions: [
                        (flag: "-p password", description: "直接指定密码（⚠️ 命令行可见）"),
                        (flag: "-f file", description: "从文件读取密码（第一行）"),
                        (flag: "-e", description: "从 SSHPASS 环境变量读取密码"),
                        (flag: "-r", description: "重用密码连接多个主机"),
                        (flag: "-v", description: "详细调试输出"),
                        (flag: "-V", description: "显示版本信息")
                    ],
                    tips: "⚠️ 密码在命令行可见不安全，推荐用 SSH 密钥认证替代"
                ),
                CommandItem(
                    name: "telnet",
                    syntax: "telnet [-8EFKLN] [-S tos] [host [port]]",
                    description: "telnet 协议客户端，用于远程登录或测试端口连通性（明文传输，不安全）。",
                    examples: [
                        CommandExample(command: "telnet example.com 80", explanation: "测试 80 端口连通性"),
                        CommandExample(command: "telnet example.com 25", explanation: "测试 SMTP 端口"),
                        CommandExample(command: "echo 'quit' | telnet host port", explanation: "非交互式测试端口")
                    ],
                    commonOptions: [
                        (flag: "-8", description: "允许 8 位字符（二进制）"),
                        (flag: "-E", description: "禁用转义字符"),
                        (flag: "-F", description: "禁用认证协商"),
                        (flag: "-K", description: "禁用登录自动协商"),
                        (flag: "-L", description: "指定本地 IP 地址"),
                        (flag: "-N", description: "不打开标准输入"),
                        (flag: "-S tos", description: "设置服务类型"),
                        (flag: "host", description: "目标主机名或 IP"),
                        (flag: "port", description: "目标端口（默认 23）")
                    ],
                    tips: "已不安全，建议用 nc/zcurl 替代测试端口"
                ),
                CommandItem(
                    name: "arp",
                    syntax: "arp [-n] [-i interface] [-a | -d host | -s host ether_addr [temp] [pub [purge]] | -f filename]",
                    description: "地址解析协议（ARP）工具，查看和操作 ARP 缓存表。",
                    examples: [
                        CommandExample(command: "arp -a", explanation: "显示所有 ARP 条目"),
                        CommandExample(command: "arp -n", explanation: "以数字格式显示（不解析主机名）"),
                        CommandExample(command: "arp -a -i en0", explanation: "显示指定接口的 ARP 条目"),
                        CommandExample(command: "sudo arp -d 192.168.1.1", explanation: "删除指定 ARP 条目"),
                        CommandExample(command: "sudo arp -s 192.168.1.100 aa:bb:cc:dd:ee:ff", explanation: "添加静态 ARP 条目")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "显示所有 ARP 条目（等同 -an）"),
                        (flag: "-n", description: "以数字格式显示地址"),
                        (flag: "-d host", description: "删除指定主机的 ARP 条目"),
                        (flag: "-s host ether", description: "添加静态 ARP 条目"),
                        (flag: "-i iface", description: "指定网络接口"),
                        (flag: "-f file", description: "从文件加载 ARP 条目"),
                        (flag: "-v", description: "详细输出"),
                        (flag: "-l", description: "显示完整 MAC 地址"),
                        (flag: "-m", description: "以表格格式显示"),
                        (flag: "-p", description: "不解析地址"),
                        (flag: "-D", description: "删除指定接口的所有条目"),
                        (flag: "-S", description: "添加静态条目"),
                        (flag: "temp", description: "添加临时条目（自动过期）"),
                        (flag: "pub", description: "添加代理 ARP 条目"),
                        (flag: "purge", description: "从所有接口清除条目"),
                        (flag: "-i iface -a", description: "显示指定接口的 ARP 表"),
                        (flag: "-i iface -d host", description: "从指定接口删除 ARP 条目"),
                        (flag: "-i iface -s host ether", description: "在指定接口添加静态 ARP 条目"),
                        (flag: "-i iface -S host ether", description: "同上（另一种语法）"),
                        (flag: "-i iface -p", description: "不在指定接口上解析"),
                        (flag: "-i iface -v", description: "显示指定接口的详细 ARP 信息"),
                        (flag: "-i iface -l", description: "显示指定接口的完整 MAC 地址"),
                        (flag: "-i iface -m", description: "以表格格式显示指定接口的 ARP 条目"),
                        (flag: "-i iface -D", description: "从指定接口删除所有 ARP 条目"),
                        (flag: "-i iface -S host ether temp", description: "在指定接口添加临时 ARP 条目"),
                        (flag: "-i iface -S host ether pub", description: "在指定接口添加代理 ARP 条目"),
                        (flag: "-i iface -S host ether pub purge", description: "在指定接口添加可清除的代理 ARP 条目"),
                        (flag: "-i iface -S host ether temp pub", description: "在指定接口添加临时代理 ARP 条目"),
                        (flag: "-i iface -S host ether temp pub purge", description: "在指定接口添加可清除的临时代理 ARP 条目"),
                        (flag: "-i iface -S host ether pub purge", description: "在指定接口添加可清除的代理 ARP 条目（另一种语法）"),
                        (flag: "-i iface -S host ether temp purge", description: "在指定接口添加可清除的临时 ARP 条目"),
                        (flag: "-i iface -S host ether temp pub purge", description: "在指定接口添加可清除的临时代理 ARP 条目（完整选项）")
                    ],
                    tips: "-a 显示 ARP 表，-n 数字格式，-d 删除，-s 添加静态条目"
                ),
                CommandItem(
                    name: "route",
                    syntax: "route [-n] [-v] [-q] [command] [destination [/prefix]] [gateway]",
                    description: "查看和操作 IP 路由表。",
                    examples: [
                        CommandExample(command: "netstat -rn", explanation: "查看路由表（推荐方式）"),
                        CommandExample(command: "route -n get 8.8.8.8", explanation: "查看到指定 IP 的路由"),
                        CommandExample(command: "route -n get default", explanation: "查看默认网关"),
                        CommandExample(command: "sudo route add -net 192.168.2.0/24 192.168.1.1", explanation: "添加静态路由"),
                        CommandExample(command: "sudo route delete -net 192.168.2.0/24", explanation: "删除静态路由"),
                        CommandExample(command: "sudo route change default 192.168.1.254", explanation: "修改默认网关")
                    ],
                    commonOptions: [
                        (flag: "-n", description: "以数字格式显示（不解析主机名）"),
                        (flag: "-v", description: "详细输出"),
                        (flag: "-q", description: "静默模式"),
                        (flag: "get", description: "显示到目标的路由信息"),
                        (flag: "add", description: "添加路由"),
                        (flag: "delete", description: "删除路由"),
                        (flag: "change", description: "修改路由"),
                        (flag: "-net", description: "目标为网络地址"),
                        (flag: "-host", description: "目标为主机地址"),
                        (flag: "-interface iface", description: "指定出接口"),
                        (flag: "-gateway gw", description: "指定网关"),
                        (flag: "-netmask mask", description: "指定子网掩码"),
                        (flag: "-blackhole", description: "添加黑洞路由（丢弃流量）"),
                        (flag: "-cloning", description: "创建克隆路由"),
                        (flag: "-static", description: "创建静态路由"),
                        (flag: "-3way", description: "创建 TCP 三方连接路由"),
                        (flag: "-xresolve", description: "启用 DNS 解析"),
                        (flag: "-ifscope iface", description: "限定路由到指定接口"),
                        (flag: "-rtscop scopename", description: "指定路由作用域"),
                        (flag: "-priority pri", description: "设置路由优先级"),
                        (flag: "-weight w", description: "设置路由权重"),
                        (flag: "-expire e", description: "设置路由过期时间"),
                        (flag: "-mtu m", description: "设置 MTU"),
                        (flag: "-recvspace r", description: "设置接收缓冲区"),
                        (flag: "-sendwait s", description: "设置发送等待时间"),
                        (flag: "-hopcount h", description: "设置最大跳数"),
                        (flag: "-rtm table t", description: "设置路由表"),
                        (flag: "-rtm proto p", description: "设置路由协议"),
                        (flag: "-rtm type t", description: "设置路由类型"),
                        (flag: "-rtm state s", description: "设置路由状态"),
                        (flag: "-rtm mask m", description: "设置路由掩码"),
                        (flag: "-rtm src s", description: "设置路由源"),
                        (flag: "-rtm dst d", description: "设置路由目标"),
                        (flag: "-rtm gw g", description: "设置路由网关"),
                        (flag: "-rtm ifp i", description: "设置路由出接口"),
                        (flag: "-rtm ifa a", description: "设置路由接口地址"),
                        (flag: "-rtm genmask g", description: "设置路由生成掩码"),
                        (flag: "-rtm flags f", description: "设置路由标志"),
                        (flag: "-rtm refcount r", description: "设置路由引用计数"),
                        (flag: "-rtm use u", description: "设置路由使用计数"),
                        (flag: "-rtm expire e", description: "设置路由过期时间"),
                        (flag: "-rtm recvpipe r", description: "设置路由接收管道"),
                        (flag: "-rtm sendpipe s", description: "设置路由发送管道"),
                        (flag: "-rtm rtt r", description: "设置路由 RTT"),
                        (flag: "-rtm rttvar r", description: "设置路由 RTT 方差"),
                        (flag: "-rtm ssthresh s", description: "设置路由慢启动阈值"),
                        (flag: "-rtm rto r", description: "设置路由 RTO"),
                        (flag: "-rtm hopcount h", description: "设置路由跳数"),
                        (flag: "-rtm mtu m", description: "设置路由 MTU"),
                        (flag: "-rtm window w", description: "设置路由窗口"),
                        (flag: "-rtm irtt i", description: "设置路由初始 RTT"),
                        (flag: "-rtm padding p", description: "设置路由填充"),
                        (flag: "-rtm state s", description: "设置路由状态"),
                        (flag: "-rtm priority p", description: "设置路由优先级"),
                        (flag: "-rtm ref r", description: "设置路由引用"),
                        (flag: "-rtm flags f", description: "设置路由标志"),
                        (flag: "-rtm use u", description: "设置路由使用计数"),
                        (flag: "-rtm expire e", description: "设置路由过期时间"),
                        (flag: "-rtm genmask g", description: "设置路由生成掩码"),
                        (flag: "-rtm src s", description: "设置路由源"),
                        (flag: "-rtm dst d", description: "设置路由目标"),
                        (flag: "-rtm gw g", description: "设置路由网关"),
                        (flag: "-rtm ifp i", description: "设置路由出接口"),
                        (flag: "-rtm ifa a", description: "设置路由接口地址"),
                        (flag: "-rtm mask m", description: "设置路由掩码"),
                        (flag: "-rtm type t", description: "设置路由类型"),
                        (flag: "-rtm table t", description: "设置路由表"),
                        (flag: "-rtm proto p", description: "设置路由协议"),
                        (flag: "-rtm hopcount h", description: "设置路由跳数"),
                        (flag: "-rtm mtu m", description: "设置路由 MTU"),
                        (flag: "-rtm window w", description: "设置路由窗口"),
                        (flag: "-rtm irtt i", description: "设置路由初始 RTT"),
                        (flag: "-rtm rtt r", description: "设置路由 RTT"),
                        (flag: "-rtm rttvar r", description: "设置路由 RTT 方差"),
                        (flag: "-rtm ssthresh s", description: "设置路由慢启动阈值"),
                        (flag: "-rtm rto r", description: "设置路由 RTO"),
                        (flag: "-rtm hopcount h", description: "设置路由跳数"),
                        (flag: "-rtm mtu m", description: "设置路由 MTU"),
                        (flag: "-rtm window w", description: "设置路由窗口"),
                        (flag: "-rtm irtt i", description: "设置路由初始 RTT"),
                        (flag: "-rtm rtt r", description: "设置路由 RTT"),
                        (flag: "-rtm rttvar r", description: "设置路由 RTT 方差"),
                        (flag: "-rtm ssthresh s", description: "设置路由慢启动阈值"),
                        (flag: "-rtm rto r", description: "设置路由 RTO"),
                        (flag: "-rtm hopcount h", description: "设置路由跳数"),
                        (flag: "-rtm mtu m", description: "设置路由 MTU"),
                        (flag: "-rtm window w", description: "设置路由窗口"),
                        (flag: "-rtm irtt i", description: "设置路由初始 RTT"),
                        (flag: "-rtm rtt r", description: "设置路由 RTT"),
                        (flag: "-rtm rttvar r", description: "设置路由 RTT 方差"),
                        (flag: "-rtm ssthresh s", description: "设置路由慢启动阈值"),
                        (flag: "-rtm rto r", description: "设置路由 RTO")
                    ],
                    tips: "netstat -rn 查看路由，route get 追踪路由，route add 添加静态路由"
                ),
                CommandItem(
                    name: "networksetup",
                    syntax: "networksetup [-listallhardwareports] [-getmacaddress device] [-getinfo device] [-setmanual device ip subnet router] [-setdhcp device] [-setdnsserver device server1 [server2 ...]] [-setsearchdomain device domain] [-getdnsservers device] [-getsearchdomains device] [-setairportnetwork device network [password]] [-getairportnetwork device]",
                    description: "macOS 网络设置命令行工具，可配置所有网络接口的 TCP/IP、DNS、代理等设置。",
                    examples: [
                        CommandExample(command: "networksetup -listallnetworkservices", explanation: "列出所有网络服务"),
                        CommandExample(command: "networksetup -listallhardwareports", explanation: "列出所有网络硬件端口"),
                        CommandExample(command: "networksetup -getmacaddress en0", explanation: "获取 MAC 地址"),
                        CommandExample(command: "networksetup -getinfo Wi-Fi", explanation: "获取 Wi-Fi 网络信息"),
                        CommandExample(command: "networksetup -getdnsservers Wi-Fi", explanation: "获取 DNS 服务器"),
                        CommandExample(command: "networksetup -setdnsserver Wi-Fi 8.8.8.8 8.8.4.4", explanation: "设置 DNS 服务器"),
                        CommandExample(command: "networksetup -setairportnetwork en0 MyNetwork password123", explanation: "连接 Wi-Fi 网络"),
                        CommandExample(command: "networksetup -setwebproxy Wi-Fi webproxy.example.com 8080", explanation: "设置 Web 代理"),
                        CommandExample(command: "networksetup -setsocksfirewallproxy Wi-Fi socks.example.com 1080", explanation: "设置 SOCKS 代理"),
                        CommandExample(command: "networksetup -setproxystate Wi-Fi Off", explanation: "关闭代理")
                    ],
                    commonOptions: [
                        (flag: "-listallnetworkservices", description: "列出所有网络服务名称"),
                        (flag: "-listallhardwareports", description: "列出所有硬件端口"),
                        (flag: "-getmacaddress device", description: "获取指定设备的 MAC 地址"),
                        (flag: "-getinfo service", description: "获取网络服务的 TCP/IP 信息"),
                        (flag: "-setmanual service ip subnet router", description: "设置静态 IP 地址"),
                        (flag: "-setdhcp service", description: "设置为 DHCP 自动获取"),
                        (flag: "-setdnsserver service dns1 [dns2 ...]", description: "设置 DNS 服务器"),
                        (flag: "-getdnsservers service", description: "获取当前 DNS 服务器"),
                        (flag: "-setsearchdomain service domain", description: "设置搜索域"),
                        (flag: "-getsearchdomains service", description: "获取搜索域"),
                        (flag: "-setairportnetwork device ssid [pass]", description: "连接 Wi-Fi 网络"),
                        (flag: "-getairportnetwork device", description: "获取当前 Wi-Fi 网络名"),
                        (flag: "-setwebproxy service proxy port", description: "设置 Web (HTTP) 代理"),
                        (flag: "-setsecurewebproxy service proxy port", description: "设置 HTTPS 代理"),
                        (flag: "-setsocksfirewallproxy service proxy port", description: "设置 SOCKS 代理"),
                        (flag: "-setproxybypassdomains service domain1 [domain2 ...]", description: "设置代理绕过列表"),
                        (flag: "-setproxystate service On|Off", description: "启用/禁用代理"),
                        (flag: "-getwebproxy service", description: "获取 Web 代理设置"),
                        (flag: "-getsecurewebproxy service", description: "获取 HTTPS 代理设置"),
                        (flag: "-getsocksfirewallproxy service", description: "获取 SOCKS 代理设置"),
                        (flag: "-setv6off service", description: "禁用 IPv6"),
                        (flag: "-getv6info service", description: "获取 IPv6 信息"),
                        (flag: "-setv6automatic service", description: "设置 IPv6 自动配置"),
                        (flag: "-setv6manual service address prefixlen router", description: "设置 IPv6 静态地址"),
                        (flag: "-createwebshare service externalip internalip", description: "创建 Web 共享"),
                        (flag: "-destroywebshare service", description: "销毁 Web 共享"),
                        (flag: "-getinfo service", description: "获取服务详细信息"),
                        (flag: "-setadditionalroute service destination subnet gateway", description: "添加额外路由"),
                        (flag: "-getadditionalroutes service", description: "获取额外路由"),
                        (flag: "-setadditionalroutes service", description: "清除额外路由"),
                        (flag: "-listallpublicservices", description: "列出所有公共网络服务"),
                        (flag: "-listalluserDefinedNetworkServices", description: "列出用户定义的网络服务")
                    ],
                    tips: "比 ifconfig 更高层，支持 DNS/代理/Wi-Fi 等完整配置"
                )
            ]
        ),

// MARK: - 系统信息追加

        CommandCategory(
            name: "系统设置",
            icon: "gearshape.2",
            commands: [
                CommandItem(
                    name: "systemsetup",
                    syntax: "systemsetup [-getdetailedclock] [-gettime] [-settimezone timezone] [-gettimezone]\n     [-setnetworktimeserver server] [-getnetworktimeserver]\n     [-getusingnetworktime] [-setusingnetworktime on|off]\n     [-getcomputersleep] [-setcomputersleep minutes]\n     [-getdisplaysleep] [-setdisplaysleep minutes]\n     [-getharddisksleep] [-setharddisksleep minutes]\n     [-getwakeonmodem] [-setwakeonmodem on|off]\n     [-getwakeonnetwork] [-setwakeonnetwork on|off]\n     [-getremotelogin] [-setremotelogin on|off]\n     [-getremoteappleevents] [-setremoteappleevents on|off]\n     [-getbootargs] [-setbootargs args]\n     [-getkernelbootdelay] [-setkernelbootdelay microseconds]\n     [-getbootdisk] [-setbootdisk datapath]\n     [-liststartupdisk] [-setstartupdisk datapath]\n     [-listdatareaders] [-listdatareadersandwriters]\n     [-listdirectorieservices]\n     [-listdirectoryserviceslist]\n     [-listadminusers]\n     [-listallfolders]\n     [-listsearchdomains]\n     [-addsearchdomain domain]\n     [-removesearchdomain domain]\n     [-listplatformuuid]\n     [-listhardwareuuid]\n     [-listserialnumber]\n     [-sleeponpowerbutton]\n     [-restart]\n     [-shutdown]\n     [-restartnow]",
                    description: "macOS 系统设置命令行工具，可配置时区、睡眠、网络时间、启动磁盘、远程登录等系统级设置。",
                    examples: [
                        CommandExample(command: "systemsetup -gettimezone", explanation: "获取当前时区"),
                        CommandExample(command: "sudo systemsetup -settimezone Asia/Shanghai", explanation: "设置时区为上海"),
                        CommandExample(command: "systemsetup -getcomputersleep", explanation: "获取电脑自动休眠时间"),
                        CommandExample(command: "sudo systemsetup -setcomputersleep 30", explanation: "设置30分钟无操作后休眠"),
                        CommandExample(command: "systemsetup -getdisplaysleep", explanation: "获取显示器休眠时间"),
                        CommandExample(command: "sudo systemsetup -setdisplaysleep 10", explanation: "设置显示器10分钟休眠"),
                        CommandExample(command: "systemsetup -getwakeonnetwork", explanation: "获取网络唤醒设置"),
                        CommandExample(command: "sudo systemsetup -setwakeonnetwork on", explanation: "启用网络唤醒"),
                        CommandExample(command: "systemsetup -getremotelogin", explanation: "获取远程登录(SSH)状态"),
                        CommandExample(command: "systemsetup -listplatformuuid", explanation: "获取平台 UUID"),
                        CommandExample(command: "systemsetup -listserialnumber", explanation: "获取序列号"),
                        CommandExample(command: "sudo systemsetup -restart", explanation: "重启系统"),
                        CommandExample(command: "sudo systemsetup -shutdown", explanation: "关闭系统")
                    ],
                    commonOptions: [
                        (flag: "-gettimezone", description: "获取当前时区"),
                        (flag: "-settimezone tz", description: "设置时区 (如 Asia/Shanghai)"),
                        (flag: "-getnetworktimeserver", description: "获取网络时间服务器"),
                        (flag: "-setnetworktimeserver server", description: "设置网络时间服务器 (NTP)"),
                        (flag: "-getusingnetworktime", description: "获取是否使用网络时间"),
                        (flag: "-setusingnetworktime on|off", description: "启用/禁用网络时间同步"),
                        (flag: "-getcomputersleep", description: "获取电脑休眠时间（分钟，0=禁用）"),
                        (flag: "-setcomputersleep min", description: "设置电脑休眠时间"),
                        (flag: "-getdisplaysleep", description: "获取显示器休眠时间"),
                        (flag: "-setdisplaysleep min", description: "设置显示器休眠时间"),
                        (flag: "-getharddisksleep", description: "获取硬盘休眠时间"),
                        (flag: "-setharddisksleep min", description: "设置硬盘休眠时间"),
                        (flag: "-getwakeonmodem", description: "获取调制解调器唤醒设置"),
                        (flag: "-setwakeonmodem on|off", description: "设置调制解调器唤醒"),
                        (flag: "-getwakeonnetwork", description: "获取网络唤醒设置 (Wake on LAN)"),
                        (flag: "-setwakeonnetwork on|off", description: "设置网络唤醒"),
                        (flag: "-getremotelogin", description: "获取远程登录(SSH)状态"),
                        (flag: "-setremotelogin on|off", description: "启用/禁用远程登录(SSH)"),
                        (flag: "-getremoteappleevents", description: "获取远程 Apple 事件设置"),
                        (flag: "-setremoteappleevents on|off", description: "设置远程 Apple 事件"),
                        (flag: "-getbootargs", description: "获取启动参数"),
                        (flag: "-setbootargs args", description: "设置启动参数"),
                        (flag: "-getbootdisk", description: "获取启动磁盘"),
                        (flag: "-setbootdisk datapath", description: "设置启动磁盘"),
                        (flag: "-listplatformuuid", description: "获取平台 UUID"),
                        (flag: "-listhardwareuuid", description: "获取硬件 UUID"),
                        (flag: "-listserialnumber", description: "获取序列号"),
                        (flag: "-liststartupdisk", description: "列出启动磁盘"),
                        (flag: "-setstartupdisk datapath", description: "设置启动磁盘"),
                        (flag: "-restart", description: "重启系统"),
                        (flag: "-shutdown", description: "关闭系统"),
                        (flag: "-restartnow", description: "立即重启"),
                        (flag: "-sleeponpowerbutton", description: "电源按钮按下时休眠"),
                        (flag: "-getkernelbootdelay", description: "获取内核启动延迟"),
                        (flag: "-setkernelbootdelay us", description: "设置内核启动延迟")
                    ],
                    tips: "比 pmset 更高层，get/set 配对，大部分设置需要 sudo"
                )
            ]
        ),

// MARK: - 自动化与脚本

        CommandCategory(
            name: "自动化与脚本",
            icon: "chevron.left.forwardslash.chevron.right",
            commands: [
                CommandItem(
                    name: "expect",
                    syntax: "expect [-c command] [-d] [-D exp_internal_level] [-f script_file [- args]] [-b] [-v] [--] [script_string]",
                    description: "自动化交互式程序的脚本语言。可模拟用户输入，自动回答密码提示、交互式命令等。",
                    examples: [
                        CommandExample(command: "expect -c 'spawn ssh user@host; expect password; send \"mypass\\r\"; expect eof'", explanation: "一行命令自动 SSH 登录"),
                        CommandExample(command: "expect spawn_and_interact.exp", explanation: "执行 expect 脚本文件"),
                        CommandExample(command: "expect -c 'spawn sudo ls; expect {password:} {send \"rootpass\\r\"}; expect eof'", explanation: "自动输入 sudo 密码")
                    ],
                    commonOptions: [
                        (flag: "-c cmd", description: "执行指定的 expect 命令字符串"),
                        (flag: "-f file", description: "从文件读取 expect 脚本"),
                        (flag: "-d", description: "启用调试输出（显示匹配过程）"),
                        (flag: "-D level", description: "设置调试级别 (0-3)"),
                        (flag: "-b", description: "禁用缓冲（立即输出）"),
                        (flag: "-v", description: "显示版本信息"),
                        (flag: "--", description: "停止选项解析")
                    ],
                    tips: "核心命令: spawn expect send interact timeout wait"
                ),
                CommandItem(
                    name: "expect 语法",
                    syntax: "spawn command              启动交互式进程\nexpect pattern             等待匹配输出\nsend \"string\\r\"          发送输入（\\r=回车）\ninteract                   交还用户交互控制\nexpect eof                 等待进程退出\nset var value              设置变量\nexpect_timeout             默认超时时间\nputs string                输出到 stdout\nexpect_user                从用户输入读取\nwait                       等待进程结束\nexp_internal 1             启用调试输出",
                    description: "expect 脚本的核心语法和命令详解。",
                    examples: [
                        CommandExample(command: "spawn ssh user@host", explanation: "启动 SSH 进程"),
                        CommandExample(command: "expect \"password:\"", explanation: "等待密码提示出现"),
                        CommandExample(command: "send \"mypass\\r\"", explanation: "发送密码并回车"),
                        CommandExample(command: "expect eof", explanation: "等待进程结束"),
                        CommandExample(command: "interact", explanation: "交还用户控制（可手动输入）"),
                        CommandExample(command: "expect -timeout 30 \"password:\"", explanation: "设置超时30秒"),
                        CommandExample(command: "send \"quit\\r\"", explanation: "发送退出命令")
                    ],
                    commonOptions: [
                        (flag: "spawn cmd", description: "启动一个交互式进程"),
                        (flag: "expect pattern", description: "等待匹配指定输出（支持通配符）"),
                        (flag: "expect {pat1} {cmd1} {pat2} {cmd2}", description: "多模式匹配：不同输出执行不同命令"),
                        (flag: "expect eof", description: "等待进程退出"),
                        (flag: "expect timeout", description: "超时处理"),
                        (flag: "send \"string\\r\"", description: "发送输入（\\r 为回车）"),
                        (flag: "send -- \"string\"", description: "发送字符串（避免 - 开头的特殊处理）"),
                        (flag: "interact", description: "交还用户交互控制"),
                        (flag: "interact {\", \" {send \"string\"}}", description: "交互模式下按特定键触发动作"),
                        (flag: "set var value", description: "设置变量"),
                        (flag: "set timeout seconds", description: "设置超时时间（默认 10 秒）"),
                        (flag: "lappend list value", description: "向列表追加元素"),
                        (flag: "puts string", description: "输出到 stdout"),
                        (flag: "puts stderr string", description: "输出到 stderr"),
                        (flag: "exp_internal 1", description: "启用调试输出"),
                        (flag: "log_user 0", description: "静默模式（不显示 spawn 输出）"),
                        (flag: "wait", description: "等待进程结束"),
                        (flag: "exec cmd", description: "执行 shell 命令并返回输出"),
                        (flag: "exit code", description: "退出 expect 脚本"),
                        (flag: "if condition {cmd}", description: "条件判断"),
                        (flag: "while condition {cmd}", description: "循环"),
                        (flag: "for {init} cond incr {body}", description: "for 循环"),
                        (flag: "foreach var list {body}", description: "遍历列表"),
                        (flag: "proc name args body", description: "定义过程（函数）"),
                        (flag: "return value", description: "从过程返回值"),
                        (flag: "open file mode", description: "打开文件"),
                        (flag: "close $fd", description: "关闭文件"),
                        (flag: "gets $fd var", description: "从文件读取一行"),
                        (flag: "read $fd ?num?", description: "从文件读取内容"),
                        (flag: "file exists path", description: "检查文件是否存在"),
                        (flag: "file dirname path", description: "获取目录部分"),
                        (flag: "file tail path", description: "获取文件名部分"),
                        (flag: "clock seconds", description: "获取 Unix 时间戳"),
                        (flag: "clock format seconds", description: "格式化时间"),
                        (flag: "string match pattern string", description: "字符串匹配"),
                        (flag: "regexp pattern string ?match?", description: "正则匹配"),
                        (flag: "regsub pattern string sub", description: "正则替换"),
                        (flag: "glob pattern", description: "文件名通配"),
                        (flag: "source file", description: "执行其他 expect/tcl 脚本")
                    ],
                    tips: "timeout 默认 10 秒，send 后加 \\r 模拟回车，interact 交还用户控制"
                ),
                CommandItem(
                    name: "expect 实用模板",
                    syntax: "#!/usr/bin/expect -f\nset timeout 30\nspawn command\nexpect {\n    \"password:\" { send \"pass\\r\"; exp_continue }\n    \"yes/no\" { send \"yes\\r\"; exp_continue }\n    \"$ \" { }\n    timeout { exit 1 }\n}\ninteract",
                    description: "expect 常用脚本模板，包括 SSH 自动登录、密码输入、批量执行等场景。",
                    examples: [
                        CommandExample(command: "#!/usr/bin/expect -f\nset timeout 30\nspawn ssh user@host\nexpect {\n    password: { send \"pass\\r\" }\n    yes/no { send \"yes\\r\"; exp_continue }\n}\nexpect \"$ \"\nsend \"ls -la\\r\"\nexpect \"$ \"\nsend \"exit\\r\"\nexpect eof", explanation: "SSH 自动登录并执行命令"),
                        CommandExample(command: "spawn sudo command\nexpect \"Password:\"\nsend \"password\\r\"\nexpect eof", explanation: "自动输入 sudo 密码"),
                        CommandExample(command: "foreach host {192.168.1.{1..10}} {\n    spawn ssh user@$host\n    expect password\n    send \"pass\\r\"\n    expect eof\n}", explanation: "批量 SSH 登录多台主机")
                    ],
                    commonOptions: [
                        (flag: "exp_continue", description: "继续匹配（不退出 expect 块）"),
                        (flag: "expect -timeout N", description: "设置当前 expect 的超时"),
                        (flag: "expect_buffer", description: "包含最近匹配的缓冲区内容"),
                        (flag: "expect_out(buffer)", description: "最近匹配的完整缓冲区"),
                        (flag: "expect_out(0,string)", description: "第一个子匹配"),
                        (flag: "expect_out(1,string)", description: "第二个子匹配"),
                        (flag: "expect_out(spawn_id)", description: "匹配的进程 ID"),
                        (flag: "expect_out(match_max)", description: "最大匹配缓冲区大小"),
                        (flag: "timeout", description: "超时事件（在 expect 块中处理）"),
                        (flag: "eof", description: "进程结束事件"),
                        (flag: "eob", description: "文件结束标记"),
                        (flag: "disconnect", description: "断开与子进程的连接"),
                        (flag: "stty rows N cols M", description: "设置终端大小")
                    ],
                    tips: "exp_continue 让 expect 继续匹配，expect_buffer 匹配内容"
                ),
                CommandItem(
                    name: "osascript / AppleScript",
                    syntax: "osascript [-e command] [-l language] [file]\n     osascript -e 'tell application \"Finder\" to activate'",
                    description: "macOS 自动化脚本工具，支持 AppleScript 和 JavaScript (JXA) 两种语言。",
                    examples: [
                        CommandExample(command: "osascript -e 'display dialog \"Hello!\"'", explanation: "显示对话框"),
                        CommandExample(command: "osascript -e 'tell application \"Safari\" to activate'", explanation: "打开 Safari"),
                        CommandExample(command: "osascript -e 'tell application \"Finder\" to get POSIX path of (path to desktop)'", explanation: "获取桌面路径"),
                        CommandExample(command: "osascript -e 'do shell script \"whoami\"'", explanation: "在脚本中执行 shell 命令"),
                        CommandExample(command: "osascript -e 'tell application \"System Events\" to keystroke \"Hello\"'", explanation: "模拟键盘输入"),
                        CommandExample(command: "osascript -e 'set vol to output volume of (get volume settings)'", explanation: "获取音量设置"),
                        CommandExample(command: "osascript -e 'set volume output volume 50'", explanation: "设置音量为 50%"),
                        CommandExample(command: "osascript -e 'tell application \"iTerm\" to create window with default profile'", explanation: "打开 iTerm 窗口")
                    ],
                    commonOptions: [
                        (flag: "-e command", description: "直接执行 AppleScript 命令"),
                        (flag: "-l language", description: "指定语言 (AppleScript/JavaScript)"),
                        (flag: "-s od | os | oa", description: "输出格式: oneline/short/alias"),
                        (flag: "-i", description: "交互模式（逐行输入）"),
                        (flag: "file", description: "执行脚本文件 (.scpt/.applescript)"),
                        (flag: "tell app", description: "向指定应用发送命令"),
                        (flag: "do shell script", description: "执行 shell 命令并返回结果"),
                        (flag: "display dialog", description: "显示对话框"),
                        (flag: "display notification", description: "显示通知"),
                        (flag: "keystroke", description: "模拟键盘按键"),
                        (flag: "key code", description: "模拟按键码"),
                        (flag: "click", description: "模拟鼠标点击"),
                        (flag: "set", description: "设置属性值"),
                        (flag: "get", description: "获取属性值"),
                        (flag: "delay seconds", description: "暂停指定秒数"),
                        (flag: "return", description: "脚本返回值"),
                        (flag: "if ... then ... else", description: "条件判断"),
                        (flag: "repeat ... end repeat", description: "循环"),
                        (flag: "try ... on error ... end try", description: "错误处理"),
                        (flag: "open location URL", description: "在默认浏览器中打开 URL"),
                        (flag: "path to desktop", description: "获取桌面路径"),
                        (flag: "path to home", description: "获取主目录路径"),
                        (flag: "path to applications", description: "获取应用程序目录路径"),
                        (flag: "path to library", description: "获取库目录路径"),
                        (flag: "current date", description: "获取当前日期时间"),
                        (flag: "do shell script \"cmd\"", description: "执行 shell 命令"),
                        (flag: "do shell script \"cmd\" with administrator privileges", description: "以管理员权限执行 shell 命令"),
                        (flag: "do shell script \"cmd\" with administrator privileges password \"pass\"", description: "指定密码执行管理员命令")
                    ],
                    tips: "display dialog 测试用，do shell script 执行命令，keystroke 模拟键盘"
                ),
                CommandItem(
                    name: "JXA (JavaScript for Automation)",
                    syntax: "osascript -l JavaScript -e 'JavaScript code'\n     osascript -l JavaScript file.js",
                    description: "JavaScript for Automation (JXA)，macOS 内置的 JavaScript 自动化引擎。语法比 AppleScript 更现代。",
                    examples: [
                        CommandExample(command: "osascript -l JavaScript -e 'Application(\"Finder\").desktop().name()'", explanation: "获取桌面名称"),
                        CommandExample(command: "osascript -l JavaScript -e 'Application(\"System Events\").keystroke(\"a\", {using: \"command down\"})'", explanation: "模拟 Cmd+A"),
                        CommandExample(command: "osascript -l JavaScript -e 'ObjC.import(\"Foundation\"); $.NSTask.launchPath = \"/usr/bin/whoami\"; $.NSTask.launch(); var out = $.NSTask.standardOutput.readDataToEndOfFile(); $.NSString.alloc.initWithEncoding(out, $.NSUTF8StringEncoding).js'", explanation: "调用 ObjC API"),
                        CommandExample(command: "osascript -l JavaScript -e 'Application(\"Safari\").documents[0].url()'", explanation: "获取 Safari 当前 URL"),
                        CommandExample(command: "osascript -l JavaScript -e 'var app = Application.currentApplication(); app.includeStandardAdditions = true; app.displayDialog(\"Hello!\")'", explanation: "显示对话框")
                    ],
                    commonOptions: [
                        (flag: "Application(name)", description: "获取指定应用的自动化对象"),
                        (flag: ".includeStandardAdditions", description: "启用标准附加命令（对话框等）"),
                        (flag: "ObjC.import(name)", description: "导入 Objective-C 框架"),
                        (flag: "ObjC.bridge", description: "访问 ObjC 类"),
                        (flag: "$.ClassName.method()", description: "调用 ObjC 类方法"),
                        (flag: "delay(seconds)", description: "暂停指定秒数"),
                        (flag: "Application.currentApplication()", description: "获取当前应用"),
                        (flag: "app.displayDialog(msg)", description: "显示对话框"),
                        (flag: "app.displayNotification(msg)", description: "显示通知"),
                        (flag: "app.doShellScript(cmd)", description: "执行 shell 命令"),
                        (flag: "app.doShellScript(cmd, {withAdministratorPrivileges: true})", description: "管理员权限执行"),
                        (flag: "app.openLocation(url)", description: "在浏览器中打开 URL"),
                        (flag: "app.keystroke(key, {using: modifiers})", description: "模拟键盘输入"),
                        (flag: "app.keyCode(code, {using: modifiers})", description: "模拟按键码"),
                        (flag: "app.click({at: [x, y]})", description: "模拟鼠标点击"),
                        (flag: "ObjC.NSObject.alloc.init()", description: "创建 ObjC 对象"),
                        (flag: "ObjC.NSString.stringWithString(str)", description: "创建 NSString"),
                        (flag: "ObjC.NSURL.URLWithString(url)", description: "创建 NSURL"),
                        (flag: "ObjC.NSData.dataWithContentsOfFile(path)", description: "读取文件数据"),
                        (flag: "ObjC.NSError.alloc.init()", description: "创建 NSError"),
                        (flag: "ObjC.NSTask.alloc.init()", description: "创建进程任务"),
                        (flag: "ObjC.NSProcessInfo.processInfo()", description: "获取进程信息"),
                        (flag: "ObjC.NSUserDefaults.standardUserDefaults()", description: "获取用户默认设置"),
                        (flag: "ObjC.NSFileManager.defaultManager()", description: "获取文件管理器"),
                        (flag: "ObjC.NSWorkspace.sharedWorkspace()", description: "获取工作空间"),
                        (flag: "ObjC.NSNotificationCenter.defaultCenter()", description: "获取通知中心"),
                        (flag: "ObjC.NSBundle.mainBundle()", description: "获取主 bundle"),
                        (flag: "ObjC.NSProcessInfo.processInfo().environment()", description: "获取环境变量"),
                        (flag: "ObjC.NSProcessInfo.processInfo().arguments()", description: "获取命令行参数"),
                        (flag: "ObjC.NSProcessInfo.processInfo().hostName()", description: "获取主机名"),
                        (flag: "ObjC.NSProcessInfo.processInfo().processName()", description: "获取进程名"),
                        (flag: "ObjC.NSProcessInfo.processInfo().processIdentifier()", description: "获取进程 ID"),
                        (flag: "ObjC.NSProcessInfo.processInfo().operatingSystemVersion()", description: "获取系统版本"),
                        (flag: "ObjC.NSProcessInfo.processInfo().thermalState()", description: "获取热状态"),
                        (flag: "ObjC.NSProcessInfo.processInfo().lowPowerModeEnabled()", description: "获取低电量模式状态"),
                        (flag: "ObjC.NSProcessInfo.processInfo().physicalMemory()", description: "获取物理内存"),
                        (flag: "ObjC.NSProcessInfo.processInfo().processorCount()", description: "获取处理器数"),
                        (flag: "ObjC.NSProcessInfo.processInfo().activeProcessorCount()", description: "获取活跃处理器数"),
                        (flag: "ObjC.NSProcessInfo.processInfo().systemUptime()", description: "获取系统运行时间"),
                        (flag: "ObjC.NSProcessInfo.processInfo().globallyUniqueString()", description: "获取全局唯一字符串"),
                        (flag: "ObjC.NSProcessInfo.processInfo().operatingSystemVersionString()", description: "获取系统版本字符串")
                    ],
                    tips: "ObjC 框架桥接能力强大，可调用几乎所有 macOS 系统 API"
                ),
                CommandItem(
                    name: "automator",
                    syntax: "automator [-j] [-D definition] [-i input] [-o output] [workflow]",
                    description: "macOS Automator 工作流命令行运行工具。可执行 .workflow 和 .automator 文件。",
                    examples: [
                        CommandExample(command: "automator ~/Desktop/MyWorkflow.workflow", explanation: "运行 Automator 工作流"),
                        CommandExample(command: "automator -i input.txt -o output.txt MyWorkflow.workflow", explanation: "带输入输出参数运行"),
                        CommandExample(command: "automator -D 'text \"hello\"' MyWorkflow.workflow", explanation: "以定义输入运行")
                    ],
                    commonOptions: [
                        (flag: "workflow", description: "要运行的 .workflow 或 .automator 文件路径"),
                        (flag: "-D definition", description: "指定输入定义（AppleScript 格式）"),
                        (flag: "-i input", description: "指定输入文件"),
                        (flag: "-o output", description: "指定输出文件"),
                        (flag: "-j", description: "以 JSON 格式输出结果")
                    ],
                    tips: "可在脚本中调用 Automator 工作流实现复杂自动化"
                ),
                CommandItem(
                    name: "shortcuts",
                    syntax: "shortcuts [run | list | view | create | import | export | delete] [shortcut-name]",
                    description: "macOS 快捷指令 (Shortcuts) 命令行工具，可管理和运行 iOS/macOS 快捷指令。",
                    examples: [
                        CommandExample(command: "shortcuts list", explanation: "列出所有快捷指令"),
                        CommandExample(command: "shortcuts run 'My Shortcut'", explanation: "运行指定快捷指令"),
                        CommandExample(command: "shortcuts run 'Get Weather' <<< '北京'", explanation: "带输入参数运行"),
                        CommandExample(command: "shortcuts view 'My Shortcut'", explanation: "在快捷指令应用中打开"),
                        CommandExample(command: "shortcuts export 'My Shortcut' -o ~/Desktop/", explanation: "导出快捷指令"),
                        CommandExample(command: "shortcuts import ~/Desktop/shortcut.shortcut", explanation: "导入快捷指令"),
                        CommandExample(command: "shortcuts delete 'Old Shortcut'", explanation: "删除快捷指令")
                    ],
                    commonOptions: [
                        (flag: "list", description: "列出所有快捷指令"),
                        (flag: "run name", description: "运行指定快捷指令"),
                        (flag: "view name", description: "在快捷指令应用中查看"),
                        (flag: "create name", description: "创建新快捷指令"),
                        (flag: "export name -o path", description: "导出快捷指令到文件"),
                        (flag: "import file", description: "从文件导入快捷指令"),
                        (flag: "delete name", description: "删除指定快捷指令")
                    ],
                    tips: "macOS Monterey+ 可用，run 可配合管道输入参数"
                )
            ]
        ),

// MARK: - 安全与加密

        CommandCategory(
            name: "安全与加密",
            icon: "lock.shield",
            commands: [
                CommandItem(
                    name: "openssl",
                    syntax: "openssl [options] [command] [args ...]",
                    description: "强大的加密工具包。SSL/TLS 证书管理、加密解密、哈希计算、格式转换等。",
                    examples: [
                        CommandExample(command: "openssl version", explanation: "查看版本"),
                        CommandExample(command: "openssl rand -hex 32", explanation: "生成 32 字节随机十六进制串"),
                        CommandExample(command: "openssl rand -base64 32", explanation: "生成 32 字节 Base64 随机串"),
                        CommandExample(command: "echo -n 'hello' | openssl dgst -sha256", explanation: "计算 SHA-256 哈希"),
                        CommandExample(command: "echo -n 'hello' | openssl md5", explanation: "计算 MD5"),
                        CommandExample(command: "openssl aes-256-cbc -salt -in file.txt -out file.enc", explanation: "AES-256 加密文件"),
                        CommandExample(command: "openssl aes-256-cbc -d -in file.enc -out file.txt", explanation: "AES-256 解密文件"),
                        CommandExample(command: "openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365", explanation: "生成自签名证书"),
                        CommandExample(command: "openssl x509 -in cert.pem -text -noout", explanation: "查看证书详情"),
                        CommandExample(command: "openssl s_client -connect example.com:443", explanation: "测试 SSL/TLS 连接"),
                        CommandExample(command: "openssl enc -base64 <<< 'hello'", explanation: "Base64 编码"),
                        CommandExample(command: "echo 'aGVsbG8=' | openssl enc -base64 -d", explanation: "Base64 解码"),
                        CommandExample(command: "openssl rsa -in old.pem -out new.pem", explanation: "RSA 私钥格式转换"),
                        CommandExample(command: "openssl pkcs12 -export -in cert.pem -inkey key.pem -out cert.p12", explanation: "导出为 PKCS12"),
                        CommandExample(command: "openssl verify -CAfile ca.pem cert.pem", explanation: "验证证书")
                    ],
                    commonOptions: [
                        (flag: "version", description: "显示版本信息"),
                        (flag: "rand -hex N", description: "生成 N 字节随机十六进制"),
                        (flag: "rand -base64 N", description: "生成 N 字节随机 Base64"),
                        (flag: "dgst / md5 / sha256", description: "计算哈希"),
                        (flag: "enc -aes-256-cbc", description: "AES-256-CBC 加密"),
                        (flag: "enc -d", description: "解密"),
                        (flag: "enc -base64", description: "Base64 编码/解码"),
                        (flag: "req -x509", description: "生成自签名证书"),
                        (flag: "req -new", description: "生成证书签名请求 (CSR)"),
                        (flag: "x509 -text", description: "查看证书信息"),
                        (flag: "s_client", description: "SSL/TLS 客户端测试"),
                        (flag: "rsa", description: "RSA 密钥操作"),
                        (flag: "ec", description: "EC 密钥操作"),
                        (flag: "pkcs12", description: "PKCS12 格式转换"),
                        (flag: "verify", description: "验证证书签名"),
                        (flag: "ca", description: "证书颁发机构操作"),
                        (flag: "passwd", description: "生成密码哈希"),
                        (flag: "pkey / pkeyparam", description: "公钥操作"),
                        (flag: "-salt", description: "加密时使用盐值（默认开启）"),
                        (flag: "-pbkdf2", description: "使用 PBKDF2 密钥派生"),
                        (flag: "-iter N", description: "PBKDF2 迭代次数"),
                        (flag: "-passout pass:xxx", description: "输出密码"),
                        (flag: "-passin pass:xxx", description: "输入密码"),
                        (flag: "-out file", description: "输出文件"),
                        (flag: "-in file", description: "输入文件")
                    ],
                    tips: "rand 生成随机数，dgst 算哈希，enc 加密解密，req 生成证书"
                ),
                CommandItem(
                    name: "gpg",
                    syntax: "gpg [options] command [args ...]",
                    description: "GNU Privacy Guard — 开源 GPG/PGP 加密工具。文件加密、签名、密钥管理。",
                    examples: [
                        CommandExample(command: "gpg --gen-key", explanation: "生成密钥对"),
                        CommandExample(command: "gpg --list-keys", explanation: "列出所有公钥"),
                        CommandExample(command: "gpg --list-secret-keys", explanation: "列出所有私钥"),
                        CommandExample(command: "gpg -e -r user@email.com file.txt", explanation: "用公钥加密文件"),
                        CommandExample(command: "gpg -d file.txt.gpg", explanation: "解密文件"),
                        CommandExample(command: "gpg -s file.txt", explanation: "创建签名"),
                        CommandExample(command: "gpg --verify file.txt.sig", explanation: "验证签名"),
                        CommandExample(command: "gpg --export -a 'User Name' > public.key", explanation: "导出公钥"),
                        CommandExample(command: "gpg --import public.key", explanation: "导入公钥"),
                        CommandExample(command: "gpg --export-secret-keys -a > private.key", explanation: "导出私钥（⚠️ 保密！）"),
                        CommandExample(command: "gpg --edit-key user@email.com", explanation: "编辑密钥"),
                        CommandExample(command: "gpg --sign --armor file.txt", explanation: "ASCII 装甲签名"),
                        CommandExample(command: "gpg --clearsign file.txt", explanation: "明文签名（可读）"),
                        CommandExample(command: "gpg --symmetric file.txt", explanation: "对称加密（密码加密）"),
                        CommandExample(command: "gpg --batch --passphrase 'pw' -c file.txt", explanation: "批处理模式加密")
                    ],
                    commonOptions: [
                        (flag: "--gen-key", description: "生成密钥对"),
                        (flag: "--list-keys / -k", description: "列出公钥"),
                        (flag: "--list-secret-keys / -K", description: "列出私钥"),
                        (flag: "--export", description: "导出公钥"),
                        (flag: "--export-secret-keys", description: "导出私钥（保密！）"),
                        (flag: "--import", description: "导入密钥"),
                        (flag: "--delete-key", description: "删除公钥"),
                        (flag: "--delete-secret-key", description: "删除私钥"),
                        (flag: "--recv-keys keyid", description: "从密钥服务器接收密钥"),
                        (flag: "--search-keys", description: "从密钥服务器搜索"),
                        (flag: "--keyserver", description: "指定密钥服务器"),
                        (flag: "-e / --encrypt", description: "加密"),
                        (flag: "-d / --decrypt", description: "解密"),
                        (flag: "-s / --sign", description: "创建签名"),
                        (flag: "--clearsign", description: "明文签名"),
                        (flag: "--detach-sign", description: "分离签名"),
                        (flag: "--verify", description: "验证签名"),
                        (flag: "-r recipient", description: "指定接收者（公钥 ID 或邮箱）"),
                        (flag: "-a / --armor", description: "ASCII 装甲输出"),
                        (flag: "--output file", description: "指定输出文件"),
                        (flag: "--batch", description: "批处理模式（非交互）"),
                        (flag: "--yes", description: "自动确认"),
                        (flag: "--passphrase phrase", description: "指定密码"),
                        (flag: "--symmetric / -c", description: "对称加密（密码加密）"),
                        (flag: "--edit-key", description: "编辑密钥（添加子密钥等）"),
                        (flag: "--quick-set-expire", description: "设置密钥过期时间"),
                        (flag: "--export-ownertrust", description: "导出信任数据库"),
                        (flag: "--import-ownertrust", description: "导入信任数据库")
                    ],
                    tips: "gen-key 生成密钥，-e 加密 -d 解密，--armor ASCII 装甲格式"
                )
            ]
        ),

// MARK: - macOS 独有工具

        CommandCategory(
            name: "macOS 独有工具",
            icon: "apple.logo",
            commands: [
                CommandItem(
                    name: "caffeinate",
                    syntax: "caffeinate [-di] [-t seconds] [-s] [-u] [command [args ...]]",
                    description: "防止 macOS 进入睡眠状态。阻止系统休眠、显示器关闭等。",
                    examples: [
                        CommandExample(command: "caffeinate", explanation: "阻止系统休眠（Ctrl+C 停止）"),
                        CommandExample(command: "caffeinate -d", explanation: "阻止显示器关闭"),
                        CommandExample(command: "caffeinate -i", explanation: "阻止系统空闲休眠"),
                        CommandExample(command: "caffeinate -s", explanation: "阻止系统休眠（接电源时）"),
                        CommandExample(command: "caffeinate -u", explanation: "声明用户活动"),
                        CommandExample(command: "caffeinate -t 3600", explanation: "阻止休眠 1 小时"),
                        CommandExample(command: "caffeinate -di -t 1800 long_task.sh", explanation: "执行脚本期间阻止休眠"),
                        CommandExample(command: "caffeinate -w 12345", explanation: "等待指定 PID 结束")
                    ],
                    commonOptions: [
                        (flag: "-d", description: "阻止显示器关闭"),
                        (flag: "-i", description: "阻止系统空闲休眠"),
                        (flag: "-s", description: "阻止系统休眠（接电源时）"),
                        (flag: "-u", description: "声明用户活动（短暂唤醒）"),
                        (flag: "-t seconds", description: "超时时间（秒）"),
                        (flag: "-w pid", description: "等待指定进程结束后才允许休眠"),
                        (flag: "-b", description: "仅在接电池时保持唤醒"),
                        (flag: "-c", description: "仅在接电源时保持唤醒"),
                        (flag: "-p", description: "仅在显示唤醒时保持唤醒"),
                        (flag: "command", description: "命令执行期间阻止休眠")
                    ],
                    tips: "无参数阻止休眠，-d 阻止显示器，-t 指定时间，-w 等待进程"
                ),
                CommandItem(
                    name: "afplay",
                    syntax: "afplay [-v volume] [-t time] [-q quality] [-d device] [--dsp *dsp] [--soundcheck-* *sc] [--concatenate] [--concatenate-rms] [--concatenate-threshold] file ...",
                    description: "macOS 音频文件播放器。支持 MP3/AAC/WAV/AIFF/ALAC 等格式。",
                    examples: [
                        CommandExample(command: "afplay notification.mp3", explanation: "播放音频文件"),
                        CommandExample(command: "afplay -v 0.5 sound.wav", explanation: "以 50% 音量播放"),
                        CommandExample(command: "afplay -t 5 sound.mp3", explanation: "播放 5 秒"),
                        CommandExample(command: "afplay -v 0.3 /System/Library/Sounds/Glass.aiff", explanation: "播放系统提示音"),
                        CommandExample(command: "afplay -v 0.2 alert.wav &", explanation: "后台播放提示音"),
                        CommandExample(command: "afplay *.mp3", explanation: "连续播放多个文件")
                    ],
                    commonOptions: [
                        (flag: "-v volume", description: "设置音量（0.0-1.0，1.0 最大）"),
                        (flag: "-t seconds", description: "播放指定秒数后停止"),
                        (flag: "-d device", description: "指定输出设备"),
                        (flag: "--dsp *dsp", description: "应用 DSP 处理器"),
                        (flag: "--soundcheck-*", description: "Sound Check 参数"),
                        (flag: "-q quality", description: "音频质量"),
                        (flag: "-T type", description: "指定音频文件类型"),
                        (flag: "file ...", description: "支持多个文件连续播放")
                    ],
                    tips: "-v 控制音量，-t 限时播放，可播放系统声音文件"
                ),
                CommandItem(
                    name: "afconvert",
                    syntax: "afconvert [-d data_format] [-f file_format] [-b bits_per_channel] [-c channels_per_frame] [-s sample_rate] [-p strategy] [-k vbr_quality] [-g target_bit_rate] [-D big_endian] [-L little_endian] [-@] input_file output_file",
                    description: "macOS 音频格式转换工具。在不同音频格式和编码之间转换。",
                    examples: [
                        CommandExample(command: "afconvert -d LEI16 -f WAVE input.aiff output.wav", explanation: "AIFF 转 WAV"),
                        CommandExample(command: "afconvert -d aac -f m4af input.wav output.m4a", explanation: "WAV 转 AAC"),
                        CommandExample(command: "afconvert -d LEI16@44100 -c 2 input.wav output.wav", explanation: "设置采样率和声道"),
                        CommandExample(command: "afconvert -d aac -g 128000 input.aiff output.m4a", explanation: "AAC 128kbps 转换"),
                        CommandExample(command: "afconvert -f mp4f -d aac -b 128000 input.wav output.mp4", explanation: "输出 MP4 容器 AAC")
                    ],
                    commonOptions: [
                        (flag: "-d format", description: "指定数据格式 (LEI16/F32LE/aac/LPCM/ima4)"),
                        (flag: "-f format", description: "指定文件格式 (WAVE/caff/m4af/mp4f/MP3)"),
                        (flag: "-c channels", description: "声道数 (1=单声道 2=立体声)"),
                        (flag: "-s rate", description: "采样率 (44100/48000/96000)"),
                        (flag: "-b bits", description: "位深度 (16/24/32)"),
                        (flag: "-g bitrate", description: "目标比特率 (bps)"),
                        (flag: "-k vbr_quality", description: "VBR 质量 (0-127)"),
                        (flag: "-@", description: "显示支持的格式列表")
                    ],
                    tips: "-@ 列出支持的格式，aac 最通用，WAV/CAF 无损"
                ),
                CommandItem(
                    name: "screencapture",
                    syntax: "screencapture [-x] [-m] [-M] [-i] [-o] [-t format] [-c] [-C] [-d seconds] [-p filename] [-I seconds] [-V seconds] [-l windowid] [-R x,y,w,h] [file]",
                    description: "macOS 屏幕截图和录屏工具。支持截屏、选区截图、窗口截图、录屏等。",
                    examples: [
                        CommandExample(command: "screencapture ~/Desktop/screenshot.png", explanation: "截取整个屏幕"),
                        CommandExample(command: "screencapture -i ~/Desktop/partial.png", explanation: "交互式选择区域截图"),
                        CommandExample(command: "screencapture -c", explanation: "截图到剪贴板"),
                        CommandExample(command: "screencapture -T 3 ~/Desktop/delayed.png", explanation: "3秒延迟截图"),
                        CommandExample(command: "screencapture -l $(osascript -e 'tell application \"Safari\" to id of window 1') safari.png", explanation: "截取指定窗口"),
                        CommandExample(command: "screencapture -R 100,100,400,300 crop.png", explanation: "截取指定区域"),
                        CommandExample(command: "screencapture -c -C", explanation: "截图到剪贴板（含光标）"),
                        CommandExample(command: "screencapture -m -x ~/Desktop/screen.png", explanation: "只截主显示器，无快门声"),
                        CommandExample(command: "screencapture -t pdf ~/Desktop/screen.pdf", explanation: "截图保存为 PDF"),
                        CommandExample(command: "screencapture -x -d 5 ~/Desktop/delay.png", explanation: "5秒延迟截图，无快门声"),
                        CommandExample(command: "screencapture -V 5 ~/Desktop/record.mov", explanation: "录屏 5 秒"),
                        CommandExample(command: "screencapture -i -c -C", explanation: "交互截图含光标到剪贴板")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "交互式选择区域截图"),
                        (flag: "-c", description: "截图到剪贴板（不保存文件）"),
                        (flag: "-C", description: "截图包含光标"),
                        (flag: "-T sec", description: "延迟截图（秒）"),
                        (flag: "-I sec", description: "交互模式后延迟秒数"),
                        (flag: "-V sec", description: "录屏时长（秒）"),
                        (flag: "-m", description: "只截取主显示器"),
                        (flag: "-M", description: "截取所有显示器"),
                        (flag: "-o", description: "不截取窗口阴影"),
                        (flag: "-x", description: "不播放快门声音"),
                        (flag: "-l windowid", description: "截取指定窗口 ID"),
                        (flag: "-R x,y,w,h", description: "截取指定矩形区域"),
                        (flag: "-p filename", description: "指定窗口名称"),
                        (flag: "-t format", description: "输出格式 (png/pdf/tiff)"),
                        (flag: "-d sec", description: "录屏延迟秒数"),
                        (flag: "-v", description: "详细输出")
                    ],
                    tips: "-i 交互截图，-c 到剪贴板，-V 录屏，-T 延迟，-x 无声"
                )
            ]
        ),

// MARK: - 包管理器

        CommandCategory(
            name: "包管理器",
            icon: "shippingbox",
            commands: [
                CommandItem(
                    name: "npm",
                    syntax: "npm <command>",
                    description: "Node.js 包管理器。管理 JavaScript/Node.js 项目的依赖。",
                    examples: [
                        CommandExample(command: "npm install", explanation: "安装 package.json 中的依赖"),
                        CommandExample(command: "npm install lodash", explanation: "安装 lodash 包"),
                        CommandExample(command: "npm install -g typescript", explanation: "全局安装 TypeScript"),
                        CommandExample(command: "npm uninstall lodash", explanation: "卸载包"),
                        CommandExample(command: "npm update", explanation: "更新所有依赖"),
                        CommandExample(command: "npm list", explanation: "列出已安装的包"),
                        CommandExample(command: "npm run dev", explanation: "运行 package.json 中的 dev 脚本"),
                        CommandExample(command: "npm init -y", explanation: "快速创建 package.json"),
                        CommandExample(command: "npm audit", explanation: "检查安全漏洞"),
                        CommandExample(command: "npm publish", explanation: "发布包到 npm registry"),
                        CommandExample(command: "npm outdated", explanation: "查看过时的包"),
                        CommandExample(command: "npm cache clean --force", explanation: "清理缓存")
                    ],
                    commonOptions: [
                        (flag: "install / i", description: "安装依赖（简写 i）"),
                        (flag: "install -g pkg", description: "全局安装"),
                        (flag: "install --save-dev pkg", description: "安装为开发依赖 (-D)"),
                        (flag: "install --save pkg", description: "安装并添加到 dependencies"),
                        (flag: "uninstall / rm pkg", description: "卸载包"),
                        (flag: "update", description: "更新所有依赖到 semver 范围内最新"),
                        (flag: "list / ls", description: "列出已安装的包"),
                        (flag: "list -g --depth=0", description: "列出全局安装的包"),
                        (flag: "run script", description: "运行 package.json 中的脚本"),
                        (flag: "run-script / run", description: "运行脚本的简写"),
                        (flag: "init", description: "创建 package.json"),
                        (flag: "init -y", description: "快速创建默认 package.json"),
                        (flag: "audit", description: "检查依赖安全漏洞"),
                        (flag: "outdated", description: "列出过时的包"),
                        (flag: "publish", description: "发布包到 npm"),
                        (flag: "cache clean --force", description: "清理 npm 缓存"),
                        (flag: "config set registry url", description: "设置镜像源"),
                        (flag: "npx cmd", description: "不安装直接执行包中的命令")
                    ],
                    tips: "-g 全局安装 CLI 工具，--save-dev 开发依赖，npx 临时执行"
                ),
                CommandItem(
                    name: "gem",
                    syntax: "gem <command> [options]",
                    description: "RubyGems — Ruby 包管理器。",
                    examples: [
                        CommandExample(command: "gem install rails", explanation: "安装 Rails"),
                        CommandExample(command: "gem uninstall rails", explanation: "卸载 Rails"),
                        CommandExample(command: "gem list", explanation: "列出已安装的 gem"),
                        CommandExample(command: "gem search rails", explanation: "搜索 gem"),
                        CommandExample(command: "gem update --system", explanation: "更新 RubyGems 自身"),
                        CommandExample(command: "gem install bundler", explanation: "安装 Bundler 依赖管理器")
                    ],
                    commonOptions: [
                        (flag: "install gem", description: "安装指定的 gem"),
                        (flag: "uninstall gem", description: "卸载 gem"),
                        (flag: "list", description: "列出已安装的 gem"),
                        (flag: "search term", description: "搜索 gem"),
                        (flag: "update gem", description: "更新指定 gem"),
                        (flag: "update --system", description: "更新 RubyGems 自身"),
                        (flag: "sources -a url", description: "添加镜像源"),
                        (flag: "sources -r url", description: "移除镜像源"),
                        (flag: "sources -l", description: "列出所有源"),
                        (flag: "environment", description: "显示 gem 环境信息"),
                        (flag: "which gem_name", description: "查找 gem 的安装路径"),
                        (flag: "info gem", description: "显示 gem 详细信息")
                    ],
                    tips: "bundler 管理项目依赖，Gemfile 定义依赖列表"
                ),
                CommandItem(
                    name: "cargo",
                    syntax: "cargo <command> [options]",
                    description: "Rust 包管理器和构建工具。",
                    examples: [
                        CommandExample(command: "cargo new myproject", explanation: "创建新项目"),
                        CommandExample(command: "cargo build", explanation: "构建项目"),
                        CommandExample(command: "cargo run", explanation: "构建并运行"),
                        CommandExample(command: "cargo test", explanation: "运行测试"),
                        CommandExample(command: "cargo add serde", explanation: "添加依赖 (cargo-edit)"),
                        CommandExample(command: "cargo install ripgrep", explanation: "安装 Rust 工具"),
                        CommandExample(command: "cargo update", explanation: "更新 Cargo.lock"),
                        CommandExample(command: "cargo doc --open", explanation: "生成并打开文档"),
                        CommandExample(command: "cargo publish", explanation: "发布到 crates.io"),
                        CommandExample(command: "cargo clippy", explanation: "运行 lint 检查"),
                        CommandExample(command: "cargo fmt", explanation: "格式化代码")
                    ],
                    commonOptions: [
                        (flag: "new name", description: "创建新项目"),
                        (flag: "init", description: "在当前目录初始化项目"),
                        (flag: "build / b", description: "编译项目"),
                        (flag: "run / r", description: "编译并运行"),
                        (flag: "test / t", description: "运行测试"),
                        (flag: "bench", description: "运行基准测试"),
                        (flag: "add crate", description: "添加依赖 (需 cargo-edit)"),
                        (flag: "remove crate", description: "移除依赖"),
                        (flag: "update", description: "更新 Cargo.lock"),
                        (flag: "install crate", description: "安装 Rust 工具"),
                        (flag: "uninstall crate", description: "卸载 Rust 工具"),
                        (flag: "doc --open", description: "生成并打开文档"),
                        (flag: "clippy", description: "运行 Rust lint 检查"),
                        (flag: "fmt", description: "格式化代码 (rustfmt)"),
                        (flag: "publish", description: "发布到 crates.io"),
                        (flag: "clean", description: "清理构建产物"),
                        (flag: "check", description: "快速类型检查（不生成二进制）"),
                        (flag: "-j N", description: "指定并行编译线程数"),
                        (flag: "--release", description: "以 release 模式编译（优化）"),
                        (flag: "--target triple", description: "交叉编译到指定目标")
                    ],
                    tips: "cargo run 编译运行，clippy lint，fmt 格式化，--release 优化编译"
                ),
                CommandItem(
                    name: "mas",
                    syntax: "mas <command> [options]",
                    description: "Mac App Store 命令行工具。通过终端安装、搜索 Mac App Store 应用。",
                    examples: [
                        CommandExample(command: "mas search Xcode", explanation: "搜索 App Store 中的 Xcode"),
                        CommandExample(command: "mas install 497799835", explanation: "通过 ID 安装应用"),
                        CommandExample(command: "mas install Xcode", explanation: "通过名称安装应用"),
                        CommandExample(command: "mas list", explanation: "列出已安装的 App Store 应用"),
                        CommandExample(command: "mas outdated", explanation: "查看可更新的应用"),
                        CommandExample(command: "mas upgrade", explanation: "更新所有可更新的应用"),
                        CommandExample(command: "mas account", explanation: "显示当前登录的 Apple ID")
                    ],
                    commonOptions: [
                        (flag: "search term", description: "搜索应用"),
                        (flag: "install id|name", description: "安装应用（ID 或名称）"),
                        (flag: "list", description: "列出已安装的应用"),
                        (flag: "outdated", description: "列出可更新的应用"),
                        (flag: "upgrade [id]", description: "更新应用（不指定则全部）"),
                        (flag: "account", description: "显示当前 Apple ID"),
                        (flag: "signin", description: "登录 Apple ID"),
                        (flag: "purchases", description: "列出已购买的应用")
                    ],
                    tips: "通过 mas search 获取应用 ID，再用 mas install ID 安装"
                ),
                CommandItem(
                    name: "yarn",
                    syntax: "yarn [command] [flags]",
                    description: "Facebook 出品的 Node.js 包管理器，兼容 npm，速度快，支持离线安装。",
                    examples: [
                        CommandExample(command: "yarn init", explanation: "初始化项目"),
                        CommandExample(command: "yarn add package", explanation: "安装依赖"),
                        CommandExample(command: "yarn add --dev package", explanation: "安装为开发依赖"),
                        CommandExample(command: "yarn remove package", explanation: "移除依赖"),
                        CommandExample(command: "yarn install", explanation: "安装所有依赖（从 yarn.lock）"),
                        CommandExample(command: "yarn upgrade", explanation: "升级所有依赖"),
                        CommandExample(command: "yarn run build", explanation: "运行 scripts 中的 build 命令"),
                        CommandExample(command: "yarn why package", explanation: "查看为什么安装了某个包"),
                        CommandExample(command: "yarn list", explanation: "列出所有依赖"),
                        CommandExample(command: "yarn cache clean", explanation: "清理缓存")
                    ],
                    commonOptions: [
                        (flag: "init", description: "初始化新项目（生成 package.json）"),
                        (flag: "add pkg", description: "安装包并添加到 dependencies"),
                        (flag: "add --dev / -D pkg", description: "安装为 devDependencies"),
                        (flag: "remove / rm pkg", description: "移除包"),
                        (flag: "install / i", description: "从 yarn.lock 安装依赖"),
                        (flag: "upgrade", description: "升级包版本"),
                        (flag: "run script", description: "运行 package.json 中的脚本"),
                        (flag: "list / ls", description: "列出依赖树"),
                        (flag: "why pkg", description: "查看包的依赖原因"),
                        (flag: "info pkg", description: "查看包信息"),
                        (flag: "outdated", description: "检查过期的依赖"),
                        (flag: "check", description: "验证依赖是否匹配"),
                        (flag: "cache clean", description: "清理全局缓存"),
                        (flag: "config list", description: "查看配置"),
                        (flag: "link [pkg]", description: "创建全局链接"),
                        (flag: "publish", description: "发布包到 registry")
                    ],
                    tips: "yarn.lock 确保团队依赖一致，yarn why 查看依赖链"
                )
            ]
        ),

// MARK: - 进程与系统监控

        CommandCategory(
            name: "进程与系统监控",
            icon: "gauge.with.dots.needle.33percent",
            commands: [
                CommandItem(
                    name: "vm_stat",
                    syntax: "vm_stat",
                    description: "显示虚拟内存统计信息（页大小、页面活动、页面错误等）。",
                    examples: [
                        CommandExample(command: "vm_stat", explanation: "显示虚拟内存统计"),
                        CommandExample(command: "vm_stat | head -10", explanation: "显示前10行统计信息"),
                        CommandExample(command: "sysctl hw.pagesize", explanation: "获取页面大小（字节）")
                    ],
                    commonOptions: [
                        (flag: "无选项", description: "显示所有虚拟内存统计信息"),
                        (flag: "页面大小", description: "通过 sysctl hw.pagesize 获取（默认 16384）")
                    ],
                    tips: "页面大小默认 16384 字节，乘以 free count 得到可用内存"
                ),
                CommandItem(
                    name: "iostat",
                    syntax: "iostat [-c count] [-d] [-I] [-n iter] [-w wait]",
                    description: "显示设备 I/O 统计信息。",
                    examples: [
                        CommandExample(command: "iostat", explanation: "显示 I/O 统计（快照）"),
                        CommandExample(command: "iostat -d 2 5", explanation: "每 2 秒刷新，共 5 次"),
                        CommandExample(command: "iostat -c 2", explanation: "显示 CPU 和 I/O 统计"),
                        CommandExample(command: "iostat -w 1", explanation: "每 1 秒刷新一次")
                    ],
                    commonOptions: [
                        (flag: "-d", description: "只显示设备统计（不含 CPU）"),
                        (flag: "-c count", description: "显示 CPU 和设备统计"),
                        (flag: "-w wait", description: "刷新间隔（秒）"),
                        (flag: "-n iter", description: "刷新次数"),
                        (flag: "-I", description: "显示增量统计（而非累计）"),
                        (flag: "-t", description: "显示时间戳")
                    ],
                    tips: "-d 只看磁盘，-w 1 每秒刷新，-I 看增量更直观"
                ),
                CommandItem(
                    name: "dmesg",
                    syntax: "dmesg [-a] [-w] [-s size] [-T]",
                    description: "显示内核环形缓冲区消息（系统启动日志、硬件错误等）。",
                    examples: [
                        CommandExample(command: "sudo dmesg", explanation: "显示内核消息"),
                        CommandExample(command: "sudo dmesg | tail -20", explanation: "显示最近 20 条内核消息"),
                        CommandExample(command: "sudo dmesg | grep -i error", explanation: "过滤错误消息"),
                        CommandExample(command: "sudo dmesg -w", explanation: "实时监控新消息"),
                        CommandExample(command: "sudo dmesg -T", explanation: "以人类可读时间显示")
                    ],
                    commonOptions: [
                        (flag: "-w", description: "持续监控新消息（类似 tail -f）"),
                        (flag: "-T", description: "以人类可读格式显示时间戳"),
                        (flag: "-a", description: "显示所有消息"),
                        (flag: "-s size", description: "设置缓冲区大小"),
                        (flag: "-n level", description: "只显示指定级别的消息")
                    ],
                    tips: "需要 root 权限，-w 实时监控，-T 可读时间，grep 过滤有用信息"
                ),
                CommandItem(
                    name: "fs_usage",
                    syntax: "fs_usage [-w] [-f filesys] [-d disk] [-s] [-t] [-T time] [-procname name] [-pid pid]",
                    description: "实时监控文件系统和磁盘 I/O 活动（需 root）。",
                    examples: [
                        CommandExample(command: "sudo fs_usage", explanation: "显示所有文件系统活动"),
                        CommandExample(command: "sudo fs_usage -w", explanation: "实时监控（等待模式）"),
                        CommandExample(command: "sudo fs_usage -f hfs", explanation: "只监控 HFS 文件系统"),
                        CommandExample(command: "sudo fs_usage -p Finder", explanation: "只监控 Finder 进程")
                    ],
                    commonOptions: [
                        (flag: "-w", description: "等待/实时模式（持续输出）"),
                        (flag: "-f filesys", description: "只监控指定文件系统类型"),
                        (flag: "-d disk", description: "只监控指定磁盘"),
                        (flag: "-s", description: "汇总模式"),
                        (flag: "-t", description: "显示时间戳"),
                        (flag: "-T time", description: "设置采样间隔"),
                        (flag: "-p pid", description: "只监控指定 PID"),
                        (flag: "-procname name", description: "只监控指定进程名")
                    ],
                    tips: "需要 root，用于排查磁盘 I/O 瓶颈和文件访问问题"
                ),
                CommandItem(
                    name: "sample",
                    syntax: "sample [-count] [-file file] [-may terminate] [-idle profiling_interval] [-wait wait_between_samples] [-deadline time] [-pause] [-compact] [-fullPaths] [-td tagData] [-output file] pid",
                    description: "对指定进程进行采样分析（生成性能报告）。",
                    examples: [
                        CommandExample(command: "sample $(pgrep Safari) 5", explanation: "对 Safari 采样 5 秒"),
                        CommandExample(command: "sample 1234 3 -f /tmp/report.txt", explanation: "采样 PID 1234，输出到文件"),
                        CommandExample(command: "sample 1234 1 -compact", explanation: "采样 1 秒，紧凑格式")
                    ],
                    commonOptions: [
                        (flag: "pid", description: "要采样的进程 ID（必填）"),
                        (flag: "count", description: "采样时长（秒，默认 10）"),
                        (flag: "-f file", description: "输出到文件"),
                        (flag: "-compact", description: "紧凑格式输出"),
                        (flag: "-fullPaths", description: "显示完整路径"),
                        (flag: "-pause", description: "暂停目标进程采样后恢复"),
                        (flag: "-deadline time", description: "采样截止时间"),
                        (flag: "-wait sec", description: "两次采样之间的等待时间")
                    ],
                    tips: "用于分析进程 CPU 热点，输出类似 Instruments 的采样报告"
                ),
                CommandItem(
                    name: "spindump",
                    syntax: "spindump [-reveal] [-noSymbolication] [-noDotFiles] [-archive] [-outputdirectory directory] [-timeout seconds] [-target pid | -process processname]",
                    description: "收集系统/进程的 spindump 报告（CPU 使用分析）。",
                    examples: [
                        CommandExample(command: "sudo spindump", explanation: "收集 10 秒系统 spindump"),
                        CommandExample(command: "sudo spindump 1234 -timeout 5", explanation: "收集指定进程 5 秒 spindump"),
                        CommandExample(command: "sudo spindump -process Safari -reveal", explanation: "收集 Safari spindump 并显示")
                    ],
                    commonOptions: [
                        (flag: "-timeout sec", description: "采样时长（秒，默认 10）"),
                        (flag: "-process name", description: "指定进程名"),
                        (flag: "-target pid", description: "指定进程 ID"),
                        (flag: "-reveal", description: "在 Finder 中显示生成的文件"),
                        (flag: "-archive", description: "归档为 .spindump 文件"),
                        (flag: "-outputdirectory dir", description: "指定输出目录"),
                        (flag: "-noSymbolication", description: "不进行符号化"),
                        (flag: "-noDotFiles", description: "不包含 .DS_Store 等文件")
                    ],
                    tips: "生成 .spindump 文件，可拖入 Instruments 或 Xcode 分析"
                ),
                CommandItem(
                    name: "watch",
                    syntax: "watch [-d] [-n seconds] command",
                    description: "周期性执行命令并显示输出变化。macOS 需要安装（brew install watch）。",
                    examples: [
                        CommandExample(command: "watch ls -la", explanation: "每 2 秒执行 ls -la"),
                        CommandExample(command: "watch -n 5 df -h", explanation: "每 5 秒查看磁盘空间"),
                        CommandExample(command: "watch -d ps aux", explanation: "高亮显示变化的部分"),
                        CommandExample(command: "watch 'date'", explanation: "查看时间变化")
                    ],
                    commonOptions: [
                        (flag: "-n seconds", description: "刷新间隔（秒，默认 2）"),
                        (flag: "-d", description: "高亮显示变化的部分"),
                        (flag: "-c", description: "清除屏幕再显示"),
                        (flag: "-t", description: "不显示标题"),
                        (flag: "-g", description: "启用 cursor 跳转（配合 grep）")
                    ],
                    tips: "macOS 未内置，brew install watch，-d 高亮变化最实用"
                )
            ]
        ),

// MARK: - 网络诊断

        CommandCategory(
            name: "网络诊断",
            icon: "antenna.radiowaves.left.and.right",
            commands: [
                CommandItem(
                    name: "airport",
                    syntax: "airport [-s] [-I] [-p network] [-x network] [-z] [-c channel]",
                    description: "macOS Wi-Fi 诊断工具（位于 /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport）。",
                    examples: [
                        CommandExample(command: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s", explanation: "扫描附近 Wi-Fi 网络"),
                        CommandExample(command: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I", explanation: "显示当前 Wi-Fi 信息"),
                        CommandExample(command: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z", explanation: "断开当前 Wi-Fi")
                    ],
                    commonOptions: [
                        (flag: "-s", description: "扫描附近的 Wi-Fi 网络"),
                        (flag: "-I", description: "显示当前连接的 Wi-Fi 详细信息"),
                        (flag: "-c channel", description: "切换到指定信道"),
                        (flag: "-z", description: "断开当前 Wi-Fi 连接"),
                        (flag: "-x", description: "忘记指定网络"),
                        (flag: "-p network", description: "连接到指定网络"),
                        (flag: "-a", description: "自动加入首选网络")
                    ],
                    tips: "完整路径很长，建议创建别名: alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'"
                ),
                CommandItem(
                    name: "mtr",
                    syntax: "mtr [-report-cycles count] [-no-dns] [-gtk] [-curses] [host]",
                    description: "结合 ping 和 traceroute 的网络诊断工具，实时显示每跳延迟和丢包率。",
                    examples: [
                        CommandExample(command: "mtr google.com", explanation: "交互式追踪路由"),
                        CommandExample(command: "mtr -report-cycles 10 google.com", explanation: "发送 10 个探测后生成报告"),
                        CommandExample(command: "mtr -no-dns google.com", explanation: "不解析主机名（加速）"),
                        CommandExample(command: "sudo mtr google.com", explanation: "使用 ICMP 模式（需 root）")
                    ],
                    commonOptions: [
                        (flag: "-report-cycles N", description: "发送 N 个探测后输出报告"),
                        (flag: "-no-dns / -n", description: "不解析主机名"),
                        (flag: "-gtk", description: "使用 GTK 图形界面"),
                        (flag: "-curses", description: "使用 curses 文本界面（默认）"),
                        (flag: "-json", description: "输出 JSON 格式"),
                        (flag: "-csv", description: "输出 CSV 格式"),
                        (flag: "-ip", description: "只使用 IP 地址"),
                        (flag: "-bw", description: "黑白模式"),
                        (flag: "-c count", description: "同 -report-cycles"),
                        (flag: "-i sec", description: "探测间隔（秒）"),
                        (flag: "-s size", description: "数据包大小")
                    ],
                    tips: "比 traceroute 更直观，实时显示延迟和丢包，-report-cycles 生成报告"
                ),
                CommandItem(
                    name: "nmap",
                    syntax: "nmap [options] [target]",
                    description: "网络扫描和主机发现工具。用于端口扫描、OS 检测、服务识别。",
                    examples: [
                        CommandExample(command: "nmap 192.168.1.1", explanation: "扫描目标主机常用端口"),
                        CommandExample(command: "nmap -p 80,443 192.168.1.1", explanation: "扫描指定端口"),
                        CommandExample(command: "nmap -p- 192.168.1.1", explanation: "扫描所有 65535 端口"),
                        CommandExample(command: "nmap -sV 192.168.1.1", explanation: "检测服务版本"),
                        CommandExample(command: "nmap -O 192.168.1.1", explanation: "检测操作系统"),
                        CommandExample(command: "nmap -sn 192.168.1.0/24", explanation: "主机发现（不扫描端口）"),
                        CommandExample(command: "nmap -A 192.168.1.1", explanation: "全面扫描（OS+版本+脚本+traceroute）")
                    ],
                    commonOptions: [
                        (flag: "-p ports", description: "指定端口范围 (80,443 或 1-1024 或 -)"),
                        (flag: "-sS", description: "TCP SYN 扫描（默认，需 root）"),
                        (flag: "-sT", description: "TCP 连接扫描"),
                        (flag: "-sU", description: "UDP 扫描"),
                        (flag: "-sV", description: "检测服务版本"),
                        (flag: "-O", description: "操作系统检测"),
                        (flag: "-A", description: "全面扫描（-sV -O -sC --traceroute）"),
                        (flag: "-sn", description: "主机发现（Ping 扫描，不扫端口）"),
                        (flag: "-Pn", description: "跳过主机发现，直接扫描端口"),
                        (flag: "-T0-5", description: "时序模板（0=最慢隐蔽 5=最快）"),
                        (flag: "-oN file", description: "输出到普通文件"),
                        (flag: "-oX file", description: "输出 XML 格式"),
                        (flag: "--script name", description: "运行 NSE 脚本"),
                        (flag: "-v / -vv", description: "详细输出"),
                        (flag: "-n", description: "不解析 DNS"),
                        (flag: "--top-ports N", description: "只扫描最常见的 N 个端口")
                    ],
                    tips: "安装: brew install nmap，-sV 检测版本，-A 全面扫描，-p- 全端口"
                ),
                CommandItem(
                    name: "tcpdump",
                    syntax: "tcpdump [-adeflnNOpqRStuvxX] [-c count] [-C file_size] [-F file] [-G time] [-i interface] [-m module] [-M secret] [-r file] [-s snaplen] [-T type] [-w file] [-W filecount] [expression]",
                    description: "网络数据包捕获工具。抓取和分析网络流量。",
                    examples: [
                        CommandExample(command: "sudo tcpdump -i en0", explanation: "捕获 en0 接口的所有流量"),
                        CommandExample(command: "sudo tcpdump -i en0 -c 100", explanation: "只捕获 100 个包"),
                        CommandExample(command: "sudo tcpdump -i en0 port 80", explanation: "只捕获 80 端口流量"),
                        CommandExample(command: "sudo tcpdump -i en0 host 192.168.1.1", explanation: "只捕获指定主机流量"),
                        CommandExample(command: "sudo tcpdump -i en0 -w capture.pcap", explanation: "保存到文件（可用 Wireshark 打开）"),
                        CommandExample(command: "sudo tcpdump -r capture.pcap", explanation: "读取抓包文件"),
                        CommandExample(command: "sudo tcpdump -i en0 'tcp[tcpflags] & tcp-syn != 0'", explanation: "只捕获 SYN 包"),
                        CommandExample(command: "sudo tcpdump -i en0 -A port 80", explanation: "以 ASCII 显示 HTTP 流量")
                    ],
                    commonOptions: [
                        (flag: "-i interface", description: "指定网络接口 (en0/en1/any)"),
                        (flag: "-c count", description: "捕获指定数量的包后停止"),
                        (flag: "-w file", description: "将原始包写入文件（pcap 格式）"),
                        (flag: "-r file", description: "从文件读取包"),
                        (flag: "-n", description: "不解析主机名和端口名"),
                        (flag: "-nn", description: "不解析主机名、端口名和协议名"),
                        (flag: "-v / -vv / -vvv", description: "详细程度递增"),
                        (flag: "-A", description: "以 ASCII 显示包内容"),
                        (flag: "-X", description: "以十六进制和 ASCII 显示"),
                        (flag: "-s snaplen", description: "每个包捕获的字节数（0=完整）"),
                        (flag: "port N", description: "按端口过滤"),
                        (flag: "host IP", description: "按主机过滤"),
                        (flag: "src host IP", description: "按源主机过滤"),
                        (flag: "dst port N", description: "按目标端口过滤"),
                        (flag: "tcp / udp / icmp", description: "按协议过滤"),
                        (flag: "expression", description: "BPF 过滤表达式"),
                        (flag: "-C size", description: "按文件大小自动轮转"),
                        (flag: "-G time", description: "按时间自动轮转"),
                        (flag: "-W count", description: "限制轮转文件数量")
                    ],
                    tips: "-i en0 指定接口，port 80 过滤端口，-w 保存到文件，-A 看 ASCII"
                ),
                CommandItem(
                    name: "iftop",
                    syntax: "iftop [-options] [hostname | IP]",
                    description: "实时显示网络带宽使用情况（按连接排序）。需安装: brew install iftop。",
                    examples: [
                        CommandExample(command: "sudo iftop", explanation: "显示所有网络连接的带宽"),
                        CommandExample(command: "sudo iftop -i en0", explanation: "指定网络接口"),
                        CommandExample(command: "sudo iftop -n", explanation: "不解析主机名（加速）"),
                        CommandExample(command: "sudo iftop -P", explanation: "显示端口号")
                    ],
                    commonOptions: [
                        (flag: "-i interface", description: "指定网络接口"),
                        (flag: "-n", description: "不解析主机名"),
                        (flag: "-N", description: "不解析端口名"),
                        (flag: "-P", description: "显示端口号"),
                        (flag: "-B", description: "以 bytes 显示（而非 bits）"),
                        (flag: "-s seconds", description: "刷新间隔（秒）"),
                        (flag: "-t", description: "文本模式（无 ncurses）"),
                        (flag: "-f filter", description: "BPF 过滤表达式"),
                        (flag: "-G net/mask", description: "指定网络/掩码")
                    ],
                    tips: "brew install iftop，-n 不解析加速，-B 按 bytes 显示更直观"
                ),
                CommandItem(
                    name: "speedtest",
                    syntax: "speedtest-cli [options]",
                    description: "互联网速度测试工具。需安装: pip3 install speedtest-cli。",
                    examples: [
                        CommandExample(command: "speedtest-cli", explanation: "运行速度测试"),
                        CommandExample(command: "speedtest-cli --simple", explanation: "简洁输出（只显示结果）"),
                        CommandExample(command: "speedtest-cli --list", explanation: "列出所有可用服务器"),
                        CommandExample(command: "speedtest-cli --server 1234", explanation: "使用指定服务器"),
                        CommandExample(command: "speedtest-cli --share", explanation: "生成分享链接")
                    ],
                    commonOptions: [
                        (flag: "--simple", description: "简洁输出：下载/上传/延迟"),
                        (flag: "--share", description: "生成结果分享图片链接"),
                        (flag: "--list", description: "列出所有可用测试服务器"),
                        (flag: "--server id", description: "使用指定的服务器 ID"),
                        (flag: "--mini", description: "使用最小输出格式"),
                        (flag: "--csv", description: "CSV 格式输出"),
                        (flag: "--json", description: "JSON 格式输出"),
                        (flag: "--secure", description: "使用 HTTPS"),
                        (flag: "--no-upload", description: "只测试下载"),
                        (flag: "--no-download", description: "只测试上传")
                    ],
                    tips: "pip3 install speedtest-cli 安装，--simple 最实用"
                )
            ]
        ),

// MARK: - 文件搜索与定位

        CommandCategory(
            name: "文件搜索与定位",
            icon: "magnifyingglass.circle",
            commands: [
                CommandItem(
                    name: "mdfind",
                    syntax: "mdfind [-name inKind | -onlyin dir | -literal query | -count | -live | -attribute name value] query",
                    description: "macOS Spotlight 命令行搜索。快速搜索文件内容、文件名、元数据。",
                    examples: [
                        CommandExample(command: "mdfind 'kMDItemDisplayName == \"*.txt\"'", explanation: "搜索所有 .txt 文件"),
                        CommandExample(command: "mdfind 'hello world'", explanation: "全文搜索包含 hello world 的文件"),
                        CommandExample(command: "mdfind -name readme", explanation: "按文件名搜索"),
                        CommandExample(command: "mdfind -onlyin ~/Documents 'report'", explanation: "在指定目录搜索"),
                        CommandExample(command: "mdfind -count 'kind:pdf'", explanation: "统计 PDF 文件数量"),
                        CommandExample(command: "mdfind 'kMDItemFSName == \"config*\"'", explanation: "按文件名模式搜索"),
                        CommandExample(command: "mdfind -name 'image' -onlyin ~/Pictures", explanation: "在 Pictures 中按名称搜索"),
                        CommandExample(command: "mdfind 'kMDItemContentType == \"public.image\"'", explanation: "搜索所有图片文件"),
                        CommandExample(command: "mdfind -live 'kMDItemDisplayName == \"*.swift\"'", explanation: "实时监控匹配的文件变化")
                    ],
                    commonOptions: [
                        (flag: "query", description: "Spotlight 搜索查询字符串"),
                        (flag: "-name term", description: "只按文件名搜索（等同 -onlyin）"),
                        (flag: "-onlyin dir", description: "限制搜索目录"),
                        (flag: "-literal query", description: "字面量搜索（不解析查询语言）"),
                        (flag: "-count", description: "只输出匹配数量"),
                        (flag: "-live", description: "实时模式（持续监控变化）"),
                        (flag: "-attribute name value", description: "按元数据属性搜索"),
                        (flag: "kMDItemDisplayName", description: "文件显示名"),
                        (flag: "kMDItemFSName", description: "文件系统名"),
                        (flag: "kMDItemContentType", description: "UTI 类型"),
                        (flag: "kMDItemTextContent", description: "文件文本内容"),
                        (flag: "kMDItemKind", description: "文件类型描述"),
                        (flag: "kMDItemDateAdded", description: "添加日期"),
                        (flag: "kMDItemContentModificationDate", description: "修改日期"),
                        (flag: "kind:pdf/image/movie", description: "按文件类型过滤"),
                        (flag: "date:today/yesterday/thisWeek", description: "按日期过滤")
                    ],
                    tips: "比 find 快得多（基于 Spotlight 索引），-name 按文件名，支持元数据查询"
                ),
                CommandItem(
                    name: "locate",
                    syntax: "locate [-d database] [-i ignore] [-m] [-s] [-c] [-0] pattern",
                    description: "基于预建数据库的快速文件搜索。比 find 快，但数据库可能不是最新的。",
                    examples: [
                        CommandExample(command: "locate hosts", explanation: "搜索包含 hosts 的文件路径"),
                        CommandExample(command: "locate -i readme", explanation: "忽略大小写搜索"),
                        CommandExample(command: "locate -c '.txt'", explanation: "统计匹配的文件数量"),
                        CommandExample(command: "sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist", explanation: "启用 locate 数据库更新"),
                        CommandExample(command: "sudo /usr/libexec/locate.updatedb", explanation: "手动更新 locate 数据库")
                    ],
                    commonOptions: [
                        (flag: "pattern", description: "搜索模式（支持通配符）"),
                        (flag: "-i", description: "忽略大小写"),
                        (flag: "-c", description: "只输出匹配数量"),
                        (flag: "-m", description: "限制输出行数到 MAX"),
                        (flag: "-s", description: "静默模式（不输出错误）"),
                        (flag: "-0", description: "以 null 字符分隔输出"),
                        (flag: "-d db", description: "使用指定的数据库文件"),
                        (flag: "-limit N", description: "限制输出结果数量")
                    ],
                    tips: "数据库默认每天更新，sudo /usr/libexec/locate.updatedb 手动更新"
                ),
                CommandItem(
                    name: "fd",
                    syntax: "fd [options] pattern [path]",
                    description: "find 的现代替代品，语法更友好，速度快。需安装: brew install fd。",
                    examples: [
                        CommandExample(command: "fd pattern", explanation: "搜索包含 pattern 的文件名"),
                        CommandExample(command: "fd -e swift", explanation: "搜索 .swift 扩展名的文件"),
                        CommandExample(command: "fd -H .gitignore", explanation: "包含隐藏文件搜索"),
                        CommandExample(command: "fd -t f -e log", explanation: "只搜索文件（排除目录）"),
                        CommandExample(command: "fd -d 3 pattern", explanation: "限制搜索深度为 3"),
                        CommandExample(command: "fd -x rm {}", explanation: "对每个结果执行 rm"),
                        CommandExample(command: "fd -e pdf . ~/Documents", explanation: "在 Documents 中搜索 PDF")
                    ],
                    commonOptions: [
                        (flag: "pattern", description: "搜索模式（正则表达式）"),
                        (flag: "path", description: "搜索起始目录（默认当前）"),
                        (flag: "-e ext", description: "按扩展名过滤"),
                        (flag: "-t type", description: "按类型过滤 (f=文件 d=目录 l=链接 x=可执行)"),
                        (flag: "-d depth", description: "限制搜索深度"),
                        (flag: "-H", description: "包含隐藏文件和目录"),
                        (flag: "-I", description: "不忽略 .gitignore 中的文件"),
                        (flag: "-E pattern", description: "排除匹配的模式"),
                        (flag: "-x cmd", description: "对每个结果执行命令（{} 代替文件名）"),
                        (flag: "-X cmd", description: "批量执行命令（+ 代替文件名列表）"),
                        (flag: "--changed-within duration", description: "只搜索最近修改的文件"),
                        (flag: "--changed-before duration", description: "只搜索更早修改的文件"),
                        (flag: "-0", description: "以 null 字符分隔输出"),
                        (flag: "--full-path", description: "匹配完整路径而非仅文件名"),
                        (flag: "-i", description: "忽略大小写"),
                        (flag: "--absolute-path", description: "输出绝对路径")
                    ],
                    tips: "比 find 更直观，-e 扩展名，-t 类型，-x 批量操作，正则默认"
                ),
                CommandItem(
                    name: "rg (ripgrep)",
                    syntax: "rg [options] pattern [path]",
                    description: "超快的文本搜索工具，grep 的现代替代品。需安装: brew install ripgrep。",
                    examples: [
                        CommandExample(command: "rg 'pattern'", explanation: "在当前目录搜索"),
                        CommandExample(command: "rg -i 'pattern'", explanation: "忽略大小写"),
                        CommandExample(command: "rg -w 'word'", explanation: "全词匹配"),
                        CommandExample(command: "rg -l 'pattern'", explanation: "只显示文件名"),
                        CommandExample(command: "rg -c 'pattern'", explanation: "统计每个文件的匹配数"),
                        CommandExample(command: "rg --type py 'import'", explanation: "只搜索 Python 文件"),
                        CommandExample(command: "rg -g '*.md' 'search'", explanation: "只搜索 .md 文件"),
                        CommandExample(command: "rg -A 3 -B 3 'pattern'", explanation: "显示前后各 3 行上下文")
                    ],
                    commonOptions: [
                        (flag: "-i", description: "忽略大小写"),
                        (flag: "-w", description: "全词匹配"),
                        (flag: "-x", description: "整行匹配"),
                        (flag: "-l", description: "只显示包含匹配的文件名"),
                        (flag: "-L", description: "只显示不包含匹配的文件名"),
                        (flag: "-c", description: "统计每个文件的匹配数"),
                        (flag: "-n", description: "显示行号（默认）"),
                        (flag: "--no-line-number", description: "不显示行号"),
                        (flag: "-A num", description: "匹配后显示 N 行"),
                        (flag: "-B num", description: "匹配前显示 N 行"),
                        (flag: "-C num", description: "匹配前后各显示 N 行"),
                        (flag: "--type type", description: "按文件类型过滤 (py/js/swift/...)"),
                        (flag: "-g glob", description: "按文件名 glob 过滤"),
                        (flag: "-E / -P", description: "ERE / PCRE 正则"),
                        (flag: "-o", description: "只输出匹配的部分"),
                        (flag: "--json", description: "JSON 格式输出"),
                        (flag: "--stats", description: "显示搜索统计信息"),
                        (flag: "-r replacement", description: "替换匹配内容（-p 模式）"),
                        (flag: "--files", description: "只列出文件（不搜索）")
                    ],
                    tips: "比 grep 快 10 倍+，自动忽略 .git，-g glob 过滤文件类型"
                ),
                CommandItem(
                    name: "fzf",
                    syntax: "fzf [options]",
                    description: "模糊查找器（Fuzzy Finder），交互式命令行过滤工具。需安装: brew install fzf。",
                    examples: [
                        CommandExample(command: "fzf", explanation: "交互式文件搜索"),
                        CommandExample(command: "find . -name '*.swift' | fzf", explanation: "管道输入过滤"),
                        CommandExample(command: "cat file.txt | fzf", explanation: "交互式行选择"),
                        CommandExample(command: "fzf --preview 'cat {}'", explanation: "预览文件内容"),
                        CommandExample(command: "kill -9 $(ps aux | fzf | awk '{print $2}')", explanation: "交互式选择进程并终止"),
                        CommandExample(command: "git log --oneline | fzf --preview 'git show {1}'", explanation: "交互式选择 git commit")
                    ],
                    commonOptions: [
                        (flag: "--preview cmd", description: "预览命令（{} 代表选中项）"),
                        (flag: "--preview-window position", description: "预览窗口位置 (right/left/up/down)"),
                        (flag: "-m / --multi", description: "允许多选（Tab 选择）"),
                        (flag: "-e / --exact", description: "精确匹配（非模糊）"),
                        (flag: "-q query", description: "初始搜索查询"),
                        (flag: "-1 / --select-1", description: "只有一个结果时自动选择"),
                        (flag: "-0 / --exit-0", description: "没有结果时直接退出"),
                        (flag: "--bind key:action", description: "自定义按键绑定"),
                        (flag: "--height N%", description: "窗口高度百分比"),
                        (flag: "--reverse", description: "倒序排列（从下到上）"),
                        (flag: "--tac", description: "反转输入顺序"),
                        (flag: "--no-sort", description: "不排序结果"),
                        (flag: "--cycle", description: "允许循环滚动"),
                        (flag: "--info separator", description: "信息行分隔符"),
                        (flag: "--color scheme", description: "颜色方案"),
                        (flag: "--ansi", description: "启用 ANSI 颜色"),
                        (flag: "-x", description: "扩展搜索模式")
                    ],
                    tips: "Ctrl+R 搜索历史命令，管道输入做交互式过滤，--preview 预览"
                )
            ]
        ),

// MARK: - 日志与调试

        CommandCategory(
            name: "日志与调试",
            icon: "ant.fill",
            commands: [
                CommandItem(
                    name: "log",
                    syntax: "log <command> [options]",
                    description: "macOS 统一日志系统命令行工具。查询系统日志、进程日志、诊断信息。",
                    examples: [
                        CommandExample(command: "log show --last 1h", explanation: "显示过去 1 小时的日志"),
                        CommandExample(command: "log show --predicate 'process == \"Safari\"' --last 30m", explanation: "Safari 过去 30 分钟日志"),
                        CommandExample(command: "log show --predicate 'eventMessage CONTAINS \"error\"' --last 10m", explanation: "包含 error 的日志"),
                        CommandExample(command: "log show --predicate 'subsystem == \"com.apple.safari\"' --last 1h", explanation: "按子系统筛选"),
                        CommandExample(command: "log stream --predicate 'process == \"kernel\"", explanation: "实时流式监控内核日志"),
                        CommandExample(command: "log show --style compact --last 5m", explanation: "紧凑格式显示最近 5 分钟"),
                        CommandExample(command: "log show --predicate 'senderImagePath CONTAINS \"Safari\"' --last 2h --info", explanation: "显示 Safari 的 info 级别日志")
                    ],
                    commonOptions: [
                        (flag: "--last duration", description: "显示过去一段时间的日志 (1h/30m/1d)"),
                        (flag: "--start time", description: "指定开始时间 (yyyy-MM-dd HH:mm:ss)"),
                        (flag: "--end time", description: "指定结束时间"),
                        (flag: "--predicate expr", description: "日志过滤谓词表达式"),
                        (flag: "--process name", description: "按进程名筛选"),
                        (flag: "--subsystem name", description: "按子系统筛选 (com.apple.xxx)"),
                        (flag: "--category name", description: "按类别筛选"),
                        (flag: "--level debug|info|default|error|fault", description: "按日志级别筛选"),
                        (flag: "--style compact|syslog|json", description: "输出格式"),
                        (flag: "--source", description: "显示日志来源信息"),
                        (flag: "--info", description: "包含 info 级别日志"),
                        (flag: "--debug", description: "包含 debug 级别日志"),
                        (flag: "--backtrace", description: "显示回溯信息"),
                        (flag: "stream", description: "实时流式输出（类似 tail -f）"),
                        (flag: "show", description: "显示历史日志"),
                        (flag: "collect", description: "收集诊断信息"),
                        (flag: "erase", description: "清除日志存档"),
                        (flag: "predicate 常用语法", description: "process == \"name\" / eventMessage CONTAINS \"text\" / subsystem == \"id\"")
                    ],
                    tips: "log show --last 1h 查历史，log stream 实时监控，predicate 语法强大"
                ),
                CommandItem(
                    name: "lldb",
                    syntax: "lldb [options] [program [core-file or PID]]",
                    description: "LLVM 调试器。调试程序、分析 core dump、附加到运行中的进程。",
                    examples: [
                        CommandExample(command: "lldb ./myprogram", explanation: "调试指定程序"),
                        CommandExample(command: "lldb -p 1234", explanation: "附加到运行中的进程"),
                        CommandExample(command: "lldb --core core.dump", explanation: "分析 core dump 文件"),
                        CommandExample(command: "(lldb) run", explanation: "运行程序"),
                        CommandExample(command: "(lldb) breakpoint set --name main", explanation: "在 main 函数设置断点"),
                        CommandExample(command: "(lldb) breakpoint set --file main.swift --line 42", explanation: "在指定行设置断点"),
                        CommandExample(command: "(lldb) thread backtrace", explanation: "显示当前线程的调用栈"),
                        CommandExample(command: "(lldb) frame variable", explanation: "显示当前帧的所有变量"),
                        CommandExample(command: "(lldb) process continue", explanation: "继续执行"),
                        CommandExample(command: "(lldb) thread step-over", explanation: "单步执行（不进入函数）"),
                        CommandExample(command: "(lldb) thread step-in", explanation: "单步进入函数"),
                        CommandExample(command: "(lldb) expression var_name", explanation: "打印变量值"),
                        CommandExample(command: "(lldb) image list", explanation: "列出加载的所有模块")
                    ],
                    commonOptions: [
                        (flag: "run / r", description: "运行程序"),
                        (flag: "process launch", description: "启动进程（同 run）"),
                        (flag: "process attach --pid N", description: "附加到运行中的进程"),
                        (flag: "breakpoint set --name func", description: "在函数名处设置断点"),
                        (flag: "breakpoint set --file f --line N", description: "在指定文件行设置断点"),
                        (flag: "breakpoint list", description: "列出所有断点"),
                        (flag: "breakpoint delete N", description: "删除断点"),
                        (flag: "continue / c", description: "继续执行"),
                        (flag: "step / s", description: "单步进入"),
                        (flag: "next / n", description: "单步跳过"),
                        (flag: "finish / finish", description: "执行到当前函数返回"),
                        (flag: "thread backtrace / bt", description: "显示调用栈"),
                        (flag: "frame variable / v", description: "显示当前帧变量"),
                        (flag: "expression / expr", description: "执行表达式（修改变量等）"),
                        (flag: "thread list", description: "列出所有线程"),
                        (flag: "thread select N", description: "切换到线程 N"),
                        (flag: "image list", description: "列出加载的模块"),
                        (flag: "quit / q", description: "退出调试器"),
                        (flag: "help", description: "显示帮助")
                    ],
                    tips: "Xcode 内置 lldb，bt 查看调用栈，expr 动态执行表达式"
                ),
                CommandItem(
                    name: "atos",
                    syntax: "atos [-o arch -l loadAddress] [-p pid] [-printInlineInfo] [-fullDemangle] addresses",
                    description: "将内存地址转换为符号（函数名/行号）。用于解析崩溃日志中的地址。",
                    examples: [
                        CommandExample(command: "atos -o MyApp.app/Contents/MacOS/MyApp 0x12345678", explanation: "将地址转换为符号"),
                        CommandExample(command: "atos -o MyApp.app/Contents/MacOS/MyApp -l 0x100000000 0x100123456", explanation: "指定加载地址"),
                        CommandExample(command: "atos -p 1234 0x12345678", explanation: "附加到进程转换地址"),
                        CommandExample(command: "atos -o MyApp.app/Contents/MacOS/MyApp -printInlineInfo 0x12345678", explanation: "显示内联函数信息")
                    ],
                    commonOptions: [
                        (flag: "-o file", description: "指定二进制文件（Mach-O）"),
                        (flag: "-l loadAddress", description: "指定模块的加载地址"),
                        (flag: "-p pid", description: "指定运行中的进程"),
                        (flag: "-printInlineInfo", description: "显示内联函数信息"),
                        (flag: "-fullDemangle", description: "完整 C++/Swift 符号名"),
                        (flag: "addresses", description: "要转换的地址（多个用空格分隔）")
                    ],
                    tips: "崩溃日志中的地址通过 atos 转换为可读的函数名和行号"
                ),
                CommandItem(
                    name: "Instruments",
                    syntax: "instruments [-w] [-t template] [-D outputDir] [-l timeLimit] [-p pid | -n processName] [-allocations | -leaks | -timeprofiler] process",
                    description: "Xcode 性能分析工具命令行版。分析 CPU、内存、泄漏等。",
                    examples: [
                        CommandExample(command: "instruments -t 'Time Profiler' ./MyApp", explanation: "使用 Time Profiler 分析"),
                        CommandExample(command: "instruments -t 'Allocations' -p 1234", explanation: "分析指定进程的内存分配"),
                        CommandExample(command: "instruments -t 'Leaks' ./MyApp", explanation: "检测内存泄漏"),
                        CommandExample(command: "instruments -t 'Zombies' ./MyApp", explanation: "检测已释放对象的访问"),
                        CommandExample(command: "instruments -t 'Network' ./MyApp", explanation: "分析网络活动"),
                        CommandExample(command: "instruments -w -t 'Time Profiler' ./MyApp", explanation: "打开 Instruments GUI")
                    ],
                    commonOptions: [
                        (flag: "-t template", description: "指定分析模板 (Time Profiler/Allocations/Leaks/Zombies/Network)"),
                        (flag: "-p pid", description: "分析指定 PID 的进程"),
                        (flag: "-n name", description: "分析指定进程名"),
                        (flag: "-D outputDir", description: "指定 trace 文件输出目录"),
                        (flag: "-l seconds", description: "分析时间限制（秒）"),
                        (flag: "-w", description: "打开 Instruments GUI（而非命令行模式）"),
                        (flag: "-o output", description: "指定 .trace 输出文件"),
                        (flag: "-templatePath path", description: "自定义模板路径")
                    ],
                    tips: "Time Profiler 分析 CPU，Leaks 检测泄漏，Zombies 检测野指针"
                )
            ]
        ),

// MARK: - 开发辅助

        CommandCategory(
            name: "开发辅助",
            icon: "hammer.fill",
            commands: [
                CommandItem(
                    name: "xcodebuild",
                    syntax: "xcodebuild [-project name.xcodeproj] [-scheme name] [-destination destinations] [-configuration name] [-arch arch] [action ...]",
                    description: "Xcode 项目构建工具。从命令行编译、测试、归档 iOS/macOS 项目。",
                    examples: [
                        CommandExample(command: "xcodebuild -scheme MyApp build", explanation: "构建默认 scheme"),
                        CommandExample(command: "xcodebuild -project MyApp.xcodeproj -scheme MyApp build", explanation: "指定项目和 scheme 构建"),
                        CommandExample(command: "xcodebuild -scheme MyApp test", explanation: "运行单元测试"),
                        CommandExample(command: "xcodebuild -scheme MyApp archive -archivePath build/MyApp.xcarchive", explanation: "归档"),
                        CommandExample(command: "xcodebuild -scheme MyApp -showBuildSettings", explanation: "显示构建设置"),
                        CommandExample(command: "xcodebuild -scheme MyApp clean", explanation: "清理构建产物"),
                        CommandExample(command: "xcodebuild -scheme MyApp -list", explanation: "列出可用 scheme 和 action"),
                        CommandExample(command: "xcodebuild -scheme MyApp build CODE_SIGNING_ALLOWED=NO", explanation: "禁用代码签名构建"),
                        CommandExample(command: "xcodebuild -scheme MyApp test -destination 'platform=iOS Simulator,name=iPhone 15'", explanation: "在模拟器上测试")
                    ],
                    commonOptions: [
                        (flag: "-project name.xcodeproj", description: "指定项目文件"),
                        (flag: "-workspace name.xcworkspace", description: "指定工作空间"),
                        (flag: "-scheme name", description: "指定 scheme"),
                        (flag: "-destination dest", description: "指定目标设备"),
                        (flag: "-configuration name", description: "指定构建配置 (Debug/Release)"),
                        (flag: "-arch arch", description: "指定架构 (arm64/x86_64)"),
                        (flag: "build", description: "构建项目"),
                        (flag: "test", description: "运行测试"),
                        (flag: "archive", description: "归档"),
                        (flag: "clean", description: "清理构建产物"),
                        (flag: "clean build", description: "清理后重新构建"),
                        (flag: "-showBuildSettings", description: "显示所有构建设置"),
                        (flag: "-list", description: "列出 scheme 和 action"),
                        (flag: "-json", description: "JSON 格式输出"),
                        (flag: "CODE_SIGNING_ALLOWED=NO", description: "禁用代码签名"),
                        (flag: "ONLY_ACTIVE_ARCH=YES", description: "只构建当前活跃架构"),
                        (flag: "-j N", description: "指定并行构建线程数"),
                        (flag: "-derivedDataPath path", description: "指定衍生数据目录"),
                        (flag: "resultBundlePath path", description: "指定结果包路径")
                    ],
                    tips: "-scheme 必须指定，build 最常用，test 跑测试，CODE_SIGNING_ALLOWED=NO 跳过签名"
                ),
                CommandItem(
                    name: "swift",
                    syntax: "swift [options] [subcommand]",
                    description: "Swift 编译器和 REPL。运行 Swift 代码、构建包、编译文件。",
                    examples: [
                        CommandExample(command: "swift", explanation: "启动 Swift REPL"),
                        CommandExample(command: "swift -e 'print(\"Hello\")'", explanation: "一行执行 Swift 代码"),
                        CommandExample(command: "swift script.swift", explanation: "运行 Swift 脚本"),
                        CommandExample(command: "swift -c file.swift", explanation: "编译 Swift 文件"),
                        CommandExample(command: "swift build", explanation: "构建 Swift Package"),
                        CommandExample(command: "swift package init --type executable", explanation: "创建新的可执行 Package"),
                        CommandExample(command: "swift package resolve", explanation: "解析依赖"),
                        CommandExample(command: "swift package update", explanation: "更新依赖"),
                        CommandExample(command: "swift package generate-xcodeproj", explanation: "生成 Xcode 项目"),
                        CommandExample(command: "swift --version", explanation: "显示 Swift 版本")
                    ],
                    commonOptions: [
                        (flag: "REPL（无参数）", description: "启动交互式 Swift REPL"),
                        (flag: "-e code", description: "执行一行 Swift 代码"),
                        (flag: "-interpret file", description: "解释执行文件"),
                        (flag: "-c file", description: "编译文件"),
                        (flag: "-o output", description: "指定输出文件"),
                        (flag: "-module-name name", description: "指定模块名"),
                        (flag: "build", description: "Swift Package Manager 构建"),
                        (flag: "test", description: "Swift Package Manager 测试"),
                        (flag: "run", description: "Swift Package Manager 运行"),
                        (flag: "package init --type executable/library", description: "创建新 Package"),
                        (flag: "package resolve", description: "解析依赖"),
                        (flag: "package update", description: "更新依赖"),
                        (flag: "package describe", description: "描述 Package"),
                        (flag: "package dump-package", description: "输出 Package.swift 内容"),
                        (flag: "--version", description: "显示 Swift 版本")
                    ],
                    tips: "swift 直接进入 REPL，swift build 构建 Package，swift script.swift 运行脚本"
                ),
                CommandItem(
                    name: "pod (CocoaPods)",
                    syntax: "pod <command> [options]",
                    description: "CocoaPods — iOS/macOS 依赖管理器。管理第三方库和框架。",
                    examples: [
                        CommandExample(command: "pod init", explanation: "在项目中创建 Podfile"),
                        CommandExample(command: "pod install", explanation: "安装 Podfile 中的依赖"),
                        CommandExample(command: "pod update", explanation: "更新所有依赖到最新版本"),
                        CommandExample(command: "pod search AFNetworking", explanation: "搜索库"),
                        CommandExample(command: "pod list", explanation: "列出已安装的 Pod"),
                        CommandExample(command: "pod outdated", explanation: "查看可更新的 Pod"),
                        CommandExample(command: "pod deintegrate", explanation: "从项目中移除 CocoaPods"),
                        CommandExample(command: "pod repo update", explanation: "更新本地 spec 仓库")
                    ],
                    commonOptions: [
                        (flag: "install", description: "安装 Podfile 中的依赖"),
                        (flag: "update [pod]", description: "更新依赖（不指定则全部）"),
                        (flag: "init", description: "创建 Podfile"),
                        (flag: "search term", description: "搜索 Pod"),
                        (flag: "list", description: "列出已安装的 Pod"),
                        (flag: "outdated", description: "列出可更新的 Pod"),
                        (flag: "remove pod", description: "移除指定 Pod"),
                        (flag: "deintegrate", description: "完全移除 CocoaPods 集成"),
                        (flag: "repo update", description: "更新本地 spec 仓库"),
                        (flag: "lib create name", description: "创建新的 Pod 模板"),
                        (flag: "spec lint pod.podspec", description: "验证 podspec"),
                        (flag: "--no-repo-update", description: "跳过 repo 更新"),
                        (flag: "--verbose", description: "详细输出"),
                        (flag: "--silent", description: "静默模式")
                    ],
                    tips: "pod install 安装，pod update 更新，--no-repo-update 跳过慢速 repo 更新"
                ),
                CommandItem(
                    name: "bundle (Bundler)",
                    syntax: "bundle <command> [options]",
                    description: "Ruby 依赖管理器。管理 Ruby 项目的 gem 依赖。",
                    examples: [
                        CommandExample(command: "bundle init", explanation: "创建 Gemfile"),
                        CommandExample(command: "bundle install", explanation: "安装 Gemfile 中的 gem"),
                        CommandExample(command: "bundle update", explanation: "更新所有 gem"),
                        CommandExample(command: "bundle exec rails server", explanation: "在 bundle 环境中运行命令"),
                        CommandExample(command: "bundle add gem_name", explanation: "添加 gem 到 Gemfile"),
                        CommandExample(command: "bundle outdated", explanation: "查看过时的 gem"),
                        CommandExample(command: "bundle exec rspec", explanation: "运行 RSpec 测试"),
                        CommandExample(command: "bundle clean", explanation: "移除未使用的 gem")
                    ],
                    commonOptions: [
                        (flag: "install", description: "安装 Gemfile 中的 gem"),
                        (flag: "update [gem]", description: "更新 gem（不指定则全部）"),
                        (flag: "init", description: "创建 Gemfile"),
                        (flag: "exec cmd", description: "在 bundle 环境中执行命令"),
                        (flag: "add gem", description: "添加 gem 到 Gemfile"),
                        (flag: "remove gem", description: "从 Gemfile 移除 gem"),
                        (flag: "list", description: "列出已安装的 gem"),
                        (flag: "outdated", description: "列出过时的 gem"),
                        (flag: "clean", description: "移除未使用的 gem"),
                        (flag: "check", description: "检查依赖是否满足"),
                        (flag: "show gem", description: "显示 gem 的位置"),
                        (flag: "info gem", description: "显示 gem 信息"),
                        (flag: "--jobs N", description: "并行安装（N 个线程）"),
                        (flag: "--path path", description: "指定 gem 安装路径"),
                        (flag: "--without group", description: "排除指定组的 gem")
                    ],
                    tips: "bundle exec 在 bundle 环境中运行，--jobs 4 并行安装加速"
                ),
                CommandItem(
                    name: "flutter",
                    syntax: "flutter <command> [options]",
                    description: "Flutter 跨平台 UI 框架 CLI 工具。创建、构建、测试 Flutter 应用。",
                    examples: [
                        CommandExample(command: "flutter create myapp", explanation: "创建新的 Flutter 项目"),
                        CommandExample(command: "flutter run", explanation: "在连接设备上运行"),
                        CommandExample(command: "flutter build ios", explanation: "构建 iOS 应用"),
                        CommandExample(command: "flutter build macos", explanation: "构建 macOS 应用"),
                        CommandExample(command: "flutter test", explanation: "运行测试"),
                        CommandExample(command: "flutter doctor", explanation: "检查环境配置"),
                        CommandExample(command: "flutter pub get", explanation: "获取依赖"),
                        CommandExample(command: "flutter upgrade", explanation: "升级 Flutter SDK"),
                        CommandExample(command: "flutter devices", explanation: "列出可用设备"),
                        CommandExample(command: "flutter analyze", explanation: "分析代码"),
                        CommandExample(command: "flutter clean", explanation: "清理构建产物")
                    ],
                    commonOptions: [
                        (flag: "create project", description: "创建新项目"),
                        (flag: "run", description: "在连接设备上运行"),
                        (flag: "build ios|macos|apk|web", description: "构建指定平台"),
                        (flag: "test", description: "运行测试"),
                        (flag: "doctor", description: "检查环境配置"),
                        (flag: "pub get", description: "获取依赖"),
                        (flag: "pub upgrade", description: "升级依赖"),
                        (flag: "upgrade", description: "升级 Flutter SDK"),
                        (flag: "devices", description: "列出可用设备"),
                        (flag: "emulators", description: "列出可用模拟器"),
                        (flag: "analyze", description: "静态分析代码"),
                        (flag: "clean", description: "清理构建产物"),
                        (flag: "format file", description: "格式化代码"),
                        (flag: "gen-l10n", description: "生成本地化文件"),
                        (flag: "pub cache repair", description: "修复 pub 缓存"),
                        (flag: "-v / --verbose", description: "详细输出")
                    ],
                    tips: "flutter doctor 检查环境，flutter run 开发调试，flutter build 打包发布"
                )
            ]
        ),

// MARK: - 视频与多媒体

        CommandCategory(
            name: "视频与多媒体",
            icon: "film",
            commands: [
                CommandItem(
                    name: "ffmpeg",
                    syntax: "ffmpeg [options] [input_file ...] output_file",
                    description: "音视频处理瑞士军刀。格式转换、剪辑、合并、提取音频等。",
                    examples: [
                        CommandExample(command: "ffmpeg -i input.mp4 output.avi", explanation: "转换视频格式"),
                        CommandExample(command: "ffmpeg -i input.mp4 -vn output.mp3", explanation: "提取音频"),
                        CommandExample(command: "ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy output.mp4", explanation: "裁剪视频（1-2分钟）"),
                        CommandExample(command: "ffmpeg -i input.mp4 -vf scale=640:480 output.mp4", explanation: "缩放视频"),
                        CommandExample(command: "ffmpeg -i input.mp4 -r 30 output.mp4", explanation: "修改帧率"),
                        CommandExample(command: "ffmpeg -i input.mp4 -metadata title='My Video' output.mp4", explanation: "添加元数据"),
                        CommandExample(command: "ffmpeg -i input.mp4 -ss 00:00:10 -vframes 1 screenshot.png", explanation: "截图"),
                        CommandExample(command: "ffmpeg -i input.mp4 -c:v libx264 -crf 23 output.mp4", explanation: "H.264 编码（质量23）"),
                        CommandExample(command: "ffmpeg -i input.mp4 -vf 'negate' output.mp4", explanation: "视频反色"),
                        CommandExample(command: "ffmpeg -i input.mp4 -filter_complex '[0:a][1:a]amix=inputs=2' output.mp4", explanation: "合并两个音频流")
                    ],
                    commonOptions: [
                        (flag: "-i input", description: "指定输入文件"),
                        (flag: "-ss time", description: "跳转到指定时间 (hh:mm:ss)"),
                        (flag: "-to time", description: "到指定时间停止"),
                        (flag: "-t duration", description: "持续时间"),
                        (flag: "-vn", description: "禁用视频（只处理音频）"),
                        (flag: "-an", description: "禁用音频（只处理视频）"),
                        (flag: "-vf filter", description: "视频滤镜"),
                        (flag: "-af filter", description: "音频滤镜"),
                        (flag: "-c:v codec", description: "视频编码器 (libx264/libx265/copy)"),
                        (flag: "-c:a codec", description: "音频编码器 (aac/libmp3lame/copy)"),
                        (flag: "-b:v bitrate", description: "视频比特率"),
                        (flag: "-b:a bitrate", description: "音频比特率"),
                        (flag: "-r fps", description: "帧率"),
                        (flag: "-s WxH", description: "分辨率"),
                        (flag: "-crf N", description: "质量 (0=无损 51=最差，推荐 18-28)"),
                        (flag: "-preset name", description: "编码速度 (ultrafast/fast/medium/slow)"),
                        (flag: "-metadata key=value", description: "添加元数据"),
                        (flag: "-vframes N", description: "输出 N 帧（截图用）"),
                        (flag: "-y", description: "覆盖输出文件不提示")
                    ],
                    tips: "ffmpeg 最强大的音视频工具，-i 输入 -ss 截取 -vf 滤镜 -c copy 无损剪辑"
                ),
                CommandItem(
                    name: "ffprobe",
                    syntax: "ffprobe [options] input_file",
                    description: "FFmpeg 媒体信息探测工具。查看音视频文件的详细编码信息。",
                    examples: [
                        CommandExample(command: "ffprobe input.mp4", explanation: "显示文件基本信息"),
                        CommandExample(command: "ffprobe -v quiet -print_format json -show_format input.mp4", explanation: "JSON 格式输出"),
                        CommandExample(command: "ffprobe -v quiet -show_streams input.mp4", explanation: "显示所有流信息"),
                        CommandExample(command: "ffprobe -v quiet -show_entries stream=codec_name,width,height input.mp4", explanation: "只显示指定字段"),
                        CommandExample(command: "ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height input.mp4", explanation: "只看视频流的尺寸")
                    ],
                    commonOptions: [
                        (flag: "-v quiet", description: "静默模式（只输出查询结果）"),
                        (flag: "-print_format json", description: "JSON 格式输出"),
                        (flag: "-show_format", description: "显示容器格式信息"),
                        (flag: "-show_streams", description: "显示所有流信息"),
                        (flag: "-show_entries stream", description: "只显示流的指定字段"),
                        (flag: "-select_streams v:0", description: "只选择第一个视频流"),
                        (flag: "-select_streams a:0", description: "只选择第一个音频流"),
                        (flag: "-of default", description: "输出格式 (default/csv/json)"),
                        (flag: "-show_entries format=duration,size,bit_rate", description: "只显示时长、大小、比特率")
                    ],
                    tips: "ffprobe 配合 ffmpeg 使用，先用 ffprobe 查看信息再处理"
                ),
                CommandItem(
                    name: "sox",
                    syntax: "sox [options] [input-file] [effect1 [effect-options ...]] output-file",
                    description: "Sound eXchange — 命令行音频处理工具。格式转换、混音、效果处理。",
                    examples: [
                        CommandExample(command: "sox input.wav output.mp3", explanation: "转换音频格式"),
                        CommandExample(command: "sox input.wav output.wav rate 44100", explanation: "修改采样率"),
                        CommandExample(command: "sox input.wav output.wav vol 0.5", explanation: "降低音量 50%"),
                        CommandExample(command: "sox input.wav output.wav fade t 0 10 3", explanation: "添加淡入淡出效果"),
                        CommandExample(command: "sox input.wav output.wav highpass 100", explanation: "高通滤波（去除低频）"),
                        CommandExample(command: "sox input.wav output.wav lowpass 3000", explanation: "低通滤波（去除高频）"),
                        CommandExample(command: "sox input.wav output.wav norm", explanation: "标准化音量"),
                        CommandExample(command: "sox -n output.wav synth 5 sine 440", explanation: "生成 440Hz 正弦波 5 秒"),
                        CommandExample(command: "sox input.wav -n stat", explanation: "显示音频统计信息"),
                        CommandExample(command: "sox -m input1.wav input2.wav output.wav", explanation: "混合两个音频")
                    ],
                    commonOptions: [
                        (flag: "-n", description: "无输入（用于生成音频）"),
                        (flag: "-m", description: "混合输入文件"),
                        (flag: "-c N", description: "设置声道数"),
                        (flag: "-r rate", description: "设置采样率"),
                        (flag: "-b bits", description: "设置位深度"),
                        (flag: "vol gain", description: "调整音量 (gaindB 或 multiplier)"),
                        (flag: "rate Hz", description: "重采样"),
                        (flag: "fade type length", description: "淡入淡出 (t/q/l/h)"),
                        (flag: "highpass freq", description: "高通滤波"),
                        (flag: "lowpass freq", description: "低通滤波"),
                        (flag: "norm", description: "标准化音量"),
                        (flag: "trim start end", description: "裁剪音频"),
                        (flag: "stat", description: "显示统计信息"),
                        (flag: "synth duration freq", description: "合成音频"),
                        (flag: "reverse", description: "倒放"),
                        (flag: "speed factor", description: "变速 (1.5=加速50%)"),
                        (flag: "pitch shift", description: "变调（半音为单位）")
                    ],
                    tips: "brew install sox，vol 调音量，norm 标准化，fade 淡入淡出"
                )
            ]
        ),

// MARK: - Git 进阶

        CommandCategory(
            name: "Git 进阶",
            icon: "arrow.triangle.branch",
            commands: [
                CommandItem(
                    name: "git reflog",
                    syntax: "git reflog [show] [options]",
                    description: "显示 Git 引用日志。记录 HEAD 的所有移动，是恢复丢失提交的最后手段。",
                    examples: [
                        CommandExample(command: "git reflog", explanation: "显示 HEAD 的移动历史"),
                        CommandExample(command: "git reflog show main", explanation: "显示 main 分支的 reflog"),
                        CommandExample(command: "git reflog -5", explanation: "只显示最近 5 条"),
                        CommandExample(command: "git reset --hard HEAD@{2}", explanation: "重置到 reflog 中的第 3 个位置"),
                        CommandExample(command: "git checkout HEAD@{1}", explanation: "切换到 reflog 中的上一个位置")
                    ],
                    commonOptions: [
                        (flag: "show [branch]", description: "显示指定分支的 reflog"),
                        (flag: "-n / --date", description: "显示的条数"),
                        (flag: "--relative-date", description: "相对时间显示"),
                        (flag: "--all", description: "显示所有 ref 的 reflog"),
                        (flag: "HEAD@{N}", description: "引用 reflog 中的第 N 个位置"),
                        (flag: "HEAD@{1}", description: "上一次 HEAD 的位置"),
                        (flag: "HEAD@{yesterday}", description: "昨天的 HEAD 位置"),
                        (flag: "HEAD@{2.hours.ago}", description: "2 小时前的 HEAD 位置")
                    ],
                    tips: "git reset --hard 误操作后用 reflog 恢复，HEAD@{N} 引用历史位置"
                ),
                CommandItem(
                    name: "git bisect",
                    syntax: "git bisect <subcommand> [options]",
                    description: "二分查找引入 bug 的提交。自动化搜索哪个提交导致了问题。",
                    examples: [
                        CommandExample(command: "git bisect start", explanation: "开始二分查找"),
                        CommandExample(command: "git bisect bad", explanation: "标记当前提交为坏的"),
                        CommandExample(command: "git bisect good v1.0", explanation: "标记 v1.0 为好的"),
                        CommandExample(command: "git bisect run make test", explanation: "自动化：运行测试判断好坏"),
                        CommandExample(command: "git bisect reset", explanation: "结束二分查找"),
                        CommandExample(command: "git bisect log", explanation: "显示二分查找日志"),
                        CommandExample(command: "git bisect visualize", explanation: "图形化显示二分状态")
                    ],
                    commonOptions: [
                        (flag: "start", description: "开始二分查找"),
                        (flag: "bad [commit]", description: "标记为坏的（有 bug）"),
                        (flag: "good [commit]", description: "标记为好的（无 bug）"),
                        (flag: "skip [commit]", description: "跳过当前提交"),
                        (flag: "run cmd", description: "自动化：运行命令判断好坏"),
                        (flag: "reset", description: "结束并恢复到开始前的状态"),
                        (flag: "visualize / viz", description: "图形化显示状态"),
                        (flag: "log", description: "显示二分日志"),
                        (flag: "replay logfile", description: "重放二分日志"),
                        (flag: "terms", description: "自定义好/坏标记词")
                    ],
                    tips: "git bisect start → 标记 bad/good → Git 自动二分 → run 自动化测试"
                ),
                CommandItem(
                    name: "git worktree",
                    syntax: "git worktree <command> [options]",
                    description: "Git 工作树管理。在一个仓库中同时检出多个分支到不同目录。",
                    examples: [
                        CommandExample(command: "git worktree add ../hotfix hotfix-branch", explanation: "添加工作树（检出分支）"),
                        CommandExample(command: "git worktree add -b new-feature ../feature", explanation: "创建新分支并添加工作树"),
                        CommandExample(command: "git worktree list", explanation: "列出所有工作树"),
                        CommandExample(command: "git worktree remove ../hotfix", explanation: "移除工作树"),
                        CommandExample(command: "git worktree move ../hotfix ../new-location", explanation: "移动工作树"),
                        CommandExample(command: "git worktree prune", explanation: "清理无效的工作树引用")
                    ],
                    commonOptions: [
                        (flag: "add path [branch]", description: "添加工作树"),
                        (flag: "add -b name path", description: "创建新分支并添加工作树"),
                        (flag: "list", description: "列出所有工作树"),
                        (flag: "remove path", description: "移除工作树"),
                        (flag: "move path new-path", description: "移动工作树"),
                        (flag: "prune", description: "清理无效的工作树引用"),
                        (flag: "lock [path]", description: "锁定工作树（防止自动删除）"),
                        (flag: "unlock [path]", description: "解锁工作树")
                    ],
                    tips: "比 git stash 更好的多分支并行开发方案，每个工作树独立目录"
                ),
                CommandItem(
                    name: "git stash",
                    syntax: "git stash [<options>]",
                    description: "暂存当前工作区的修改。快速保存和恢复未提交的更改。",
                    examples: [
                        CommandExample(command: "git stash", explanation: "暂存当前修改"),
                        CommandExample(command: "git stash push -m 'WIP feature'", explanation: "带消息暂存"),
                        CommandExample(command: "git stash list", explanation: "列出所有暂存"),
                        CommandExample(command: "git stash pop", explanation: "恢复最近的暂存并删除"),
                        CommandExample(command: "git stash apply", explanation: "恢复但不删除暂存"),
                        CommandExample(command: "git stash drop", explanation: "删除最近的暂存"),
                        CommandExample(command: "git stash clear", explanation: "删除所有暂存"),
                        CommandExample(command: "git stash show -p", explanation: "显示暂存的详细差异"),
                        CommandExample(command: "git stash branch new-branch", explanation: "从暂存创建新分支"),
                        CommandExample(command: "git stash pop stash@{2}", explanation: "恢复指定的暂存")
                    ],
                    commonOptions: [
                        (flag: "push [-m msg]", description: "暂存修改（可带消息）"),
                        (flag: "pop", description: "恢复最近暂存并删除"),
                        (flag: "apply", description: "恢复但不删除暂存"),
                        (flag: "drop", description: "删除最近的暂存"),
                        (flag: "clear", description: "删除所有暂存"),
                        (flag: "list", description: "列出所有暂存"),
                        (flag: "show [-p]", description: "显示暂存的差异"),
                        (flag: "branch name", description: "从暂存创建新分支"),
                        (flag: "stash@{N}", description: "引用第 N 个暂存"),
                        (flag: "-u / --include-untracked", description: "包含未跟踪的文件"),
                        (flag: "-a / --all", description: "包含所有文件（含 .gitignore）"),
                        (flag: "--keep-index", description: "保留已暂存的文件"),
                        (flag: "-p / --patch", description: "交互式选择要暂存的部分")
                    ],
                    tips: "stash push -m 保存，pop 恢复，list 查看，apply 恢复不删除"
                ),
                CommandItem(
                    name: "git cherry-pick",
                    syntax: "git cherry-pick [<options>] <commit>...",
                    description: "将指定提交的更改应用到当前分支。选择性地合并单个提交。",
                    examples: [
                        CommandExample(command: "git cherry-pick abc123", explanation: "应用指定提交到当前分支"),
                        CommandExample(command: "git cherry-pick abc123..def456", explanation: "应用范围内的提交"),
                        CommandExample(command: "git cherry-pick --no-commit abc123", explanation: "应用更改但不自动提交"),
                        CommandExample(command: "git cherry-pick -n abc123", explanation: "同 --no-commit"),
                        CommandExample(command: "git cherry-pick --continue", explanation: "解决冲突后继续"),
                        CommandExample(command: "git cherry-pick --abort", explanation: "取消 cherry-pick 操作")
                    ],
                    commonOptions: [
                        (flag: "commit", description: "要应用的提交 SHA"),
                        (flag: "--no-commit / -n", description: "只应用更改不自动提交"),
                        (flag: "--continue", description: "解决冲突后继续"),
                        (flag: "--abort", description: "取消操作并恢复原状"),
                        (flag: "--quit", description: "静默退出"),
                        (flag: "-x", description: "在提交消息中添加 (cherry picked from...)"),
                        (flag: "-e", description: "编辑提交消息"),
                        (flag: "--strategy-option", description: "传递合并策略选项"),
                        (flag: "commit1..commit2", description: "应用范围（不含 commit1）"),
                        (flag: "^commit", description: "排除该提交")
                    ],
                    tips: "适合将特定 bug 修复应用到其他分支，--no-commit 先预览再决定"
                ),
                CommandItem(
                    name: "git tag",
                    syntax: "git tag [-a | -s | -u <key-id>] [-f] [-m <msg> | -F <file>] <tagname> [<commit>]",
                    description: "创建、列出、删除、验证 Git 标签。标记发布版本。",
                    examples: [
                        CommandExample(command: "git tag v1.0", explanation: "创建轻量标签"),
                        CommandExample(command: "git tag -a v1.0 -m 'Release 1.0'", explanation: "创建附注标签"),
                        CommandExample(command: "git tag -s v1.0 -m 'Signed release'", explanation: "创建签名标签"),
                        CommandExample(command: "git tag -l", explanation: "列出所有标签"),
                        CommandExample(command: "git tag -l 'v1.*'", explanation: "列出匹配的标签"),
                        CommandExample(command: "git push origin v1.0", explanation: "推送标签到远程"),
                        CommandExample(command: "git push origin --tags", explanation: "推送所有标签"),
                        CommandExample(command: "git tag -d v1.0", explanation: "删除本地标签"),
                        CommandExample(command: "git push origin --delete v1.0", explanation: "删除远程标签"),
                        CommandExample(command: "git checkout v1.0", explanation: "切换到标签"),
                        CommandExample(command: "git tag -v v1.0", explanation: "验证签名标签")
                    ],
                    commonOptions: [
                        (flag: "-a", description: "创建附注标签（推荐）"),
                        (flag: "-m msg", description: "标签消息"),
                        (flag: "-F file", description: "从文件读取消息"),
                        (flag: "-s", description: "创建 GPG 签名标签"),
                        (flag: "-u key-id", description: "用指定密钥签名"),
                        (flag: "-l / --list", description: "列出标签"),
                        (flag: "-d tag", description: "删除标签"),
                        (flag: "-f tag", description: "强制覆盖已有标签"),
                        (flag: "-v tag", description: "验证 GPG 签名"),
                        (flag: "-n N", description: "显示标签消息的前 N 行"),
                        (flag: "--sort", description: "排序方式 (version:refname)"),
                        (flag: "--contains commit", description: "显示包含指定提交的标签"),
                        (flag: "--merged branch", description: "显示已合并到分支的标签")
                    ],
                    tips: "推荐用 -a 创建附注标签，push --tags 推送所有，tag -d 删除本地"
                )
            ]
        ),

// MARK: - Docker 与容器

        CommandCategory(
            name: "Docker 与容器",
            icon: "shippingbox.fill",
            commands: [
                CommandItem(
                    name: "docker",
                    syntax: "docker [command] [options]",
                    description: "Docker 容器引擎。构建、运行、管理容器化应用。",
                    examples: [
                        CommandExample(command: "docker run -d -p 8080:80 nginx", explanation: "后台运行 nginx 并映射端口"),
                        CommandExample(command: "docker ps", explanation: "列出运行中的容器"),
                        CommandExample(command: "docker ps -a", explanation: "列出所有容器"),
                        CommandExample(command: "docker images", explanation: "列出本地镜像"),
                        CommandExample(command: "docker build -t myapp:1.0 .", explanation: "构建镜像"),
                        CommandExample(command: "docker exec -it container bash", explanation: "进入运行中的容器"),
                        CommandExample(command: "docker logs container", explanation: "查看容器日志"),
                        CommandExample(command: "docker stop container", explanation: "停止容器"),
                        CommandExample(command: "docker rm container", explanation: "删除容器"),
                        CommandExample(command: "docker rmi image", explanation: "删除镜像"),
                        CommandExample(command: "docker pull ubuntu", explanation: "拉取镜像"),
                        CommandExample(command: "docker compose up -d", explanation: "启动 docker-compose 服务"),
                        CommandExample(command: "docker system prune -a", explanation: "清理所有未使用的资源")
                    ],
                    commonOptions: [
                        (flag: "run -d -p host:container image", description: "后台运行并映射端口"),
                        (flag: "run -it image bash", description: "交互式运行（进入终端）"),
                        (flag: "run --name name", description: "指定容器名称"),
                        (flag: "run -v host:container", description: "挂载卷"),
                        (flag: "run -e KEY=VAL", description: "设置环境变量"),
                        (flag: "run --rm", description: "退出后自动删除容器"),
                        (flag: "ps / ps -a", description: "列出运行中/所有容器"),
                        (flag: "images", description: "列出本地镜像"),
                        (flag: "build -t name:tag .", description: "构建镜像"),
                        (flag: "exec -it name bash", description: "进入容器终端"),
                        (flag: "logs name", description: "查看容器日志"),
                        (flag: "logs -f name", description: "实时追踪日志"),
                        (flag: "stop / start / restart name", description: "停止/启动/重启容器"),
                        (flag: "rm name", description: "删除容器"),
                        (flag: "rmi image", description: "删除镜像"),
                        (flag: "pull image", description: "拉取镜像"),
                        (flag: "push image", description: "推送镜像"),
                        (flag: "system prune -a", description: "清理所有未使用的资源"),
                        (flag: "compose up -d", description: "启动 compose 服务"),
                        (flag: "compose down", description: "停止并删除 compose 服务"),
                        (flag: "compose ps", description: "列出 compose 服务状态"),
                        (flag: "inspect name", description: "查看容器详细信息"),
                        (flag: "cp src dest", description: "复制文件到容器/从容器复制"),
                        (flag: "stats", description: "实时显示容器资源使用"),
                        (flag: "top name", description: "查看容器中的进程")
                    ],
                    tips: "run -d 后台 -p 端口映射 -it 交互，exec -it 进入容器，logs -f 追踪日志"
                ),
                CommandItem(
                    name: "docker-compose",
                    syntax: "docker-compose [command] [options]",
                    description: "Docker Compose — 定义和运行多容器应用。通过 YAML 文件管理多个服务。",
                    examples: [
                        CommandExample(command: "docker-compose up -d", explanation: "启动所有服务（后台）"),
                        CommandExample(command: "docker-compose down", explanation: "停止并删除所有服务"),
                        CommandExample(command: "docker-compose ps", explanation: "查看服务状态"),
                        CommandExample(command: "docker-compose logs -f", explanation: "追踪所有服务日志"),
                        CommandExample(command: "docker-compose build", explanation: "构建/重建服务镜像"),
                        CommandExample(command: "docker-compose exec web bash", explanation: "进入 web 服务容器"),
                        CommandExample(command: "docker-compose pull", explanation: "拉取最新镜像"),
                        CommandExample(command: "docker-compose restart", explanation: "重启所有服务"),
                        CommandExample(command: "docker-compose config", explanation: "验证并查看 compose 配置")
                    ],
                    commonOptions: [
                        (flag: "up -d", description: "启动服务（后台模式）"),
                        (flag: "down", description: "停止并删除服务和网络"),
                        (flag: "ps", description: "列出服务状态"),
                        (flag: "logs [-f] [service]", description: "查看服务日志"),
                        (flag: "build [service]", description: "构建/重建镜像"),
                        (flag: "exec service cmd", description: "在服务容器中执行命令"),
                        (flag: "pull [service]", description: "拉取最新镜像"),
                        (flag: "restart [service]", description: "重启服务"),
                        (flag: "stop [service]", description: "停止服务"),
                        (flag: "start [service]", description: "启动服务"),
                        (flag: "config", description: "验证并查看配置"),
                        (flag: "images", description: "列出服务使用的镜像"),
                        (flag: "top", description: "显示服务容器中的进程"),
                        (flag: "cp src dest", description: "复制文件"),
                        (flag: "-f file", description: "指定 compose 文件"),
                        (flag: "-p project", description: "指定项目名称")
                    ],
                    tips: "up -d 启动，down 停止，logs -f 追踪日志，exec 进入容器调试"
                )
            ]
        )
    ]

    static func searchCommands(query: String) -> [(category: String, command: CommandItem)] {
        let lowercased = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !lowercased.isEmpty else { return [] }
        let tokens = lowercased.split(separator: " ").map(String.init)
        var results: [(category: String, command: CommandItem, score: Int)] = []
        for category in categories {
            for command in category.commands {
                let name = command.name.lowercased()
                let desc = command.description.lowercased()
                let syntax = command.syntax.lowercased()
                var score = 0
                if name == lowercased {
                    score = 1000
                } else if name.hasPrefix(lowercased) {
                    score = 900
                } else if name.contains(lowercased) {
                    score = 800
                } else if tokens.allSatisfy({ name.contains($0) }) {
                    score = 700
                } else if desc.contains(lowercased) || syntax.contains(lowercased) {
                    score = 500
                } else if tokens.allSatisfy({ desc.contains($0) || syntax.contains($0) }) {
                    score = 400
                } else {
                    var matchCount = 0
                    for token in tokens {
                        if name.contains(token) || desc.contains(token) || syntax.contains(token) {
                            matchCount += 1
                        }
                    }
                    if matchCount > 0 {
                        score = matchCount * 100
                    }
                }
                if score > 0 {
                    results.append((category: category.name, command: command, score: score))
                }
            }
        }
        results.sort { $0.score > $1.score }
        return results.map { (category: $0.category, command: $0.command) }
    }

    static func bestMatch(for query: String) -> (category: String, command: CommandItem)? {
        let results = searchCommands(query: query)
        return results.first
    }
}
