import Foundation

enum AgentPlatform: String, CaseIterable {
    case claude = ".claude"
    case codex = ".codex"

    var baseDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(rawValue)
    }

    var projectsDirectory: URL {
        baseDirectory.appendingPathComponent("projects")
    }
}

enum SessionFileLocator {
    static func projectDirectoryName(for cwd: String) -> String {
        cwd.replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ".", with: "-")
    }

    static func sessionFilePath(sessionId: String, cwd: String) -> String {
        let projectDir = projectDirectoryName(for: cwd)
        return existingPlatforms
            .map { NSHomeDirectory() + "/\($0.rawValue)/projects/\(projectDir)/\(sessionId).jsonl" }
            .first(where: { FileManager.default.fileExists(atPath: $0) })
        ?? NSHomeDirectory() + "/.claude/projects/\(projectDir)/\(sessionId).jsonl"
    }

    static func agentFilePath(agentId: String, cwd: String) -> String {
        let projectDir = projectDirectoryName(for: cwd)
        return existingPlatforms
            .map { NSHomeDirectory() + "/\($0.rawValue)/projects/\(projectDir)/agent-\(agentId).jsonl" }
            .first(where: { FileManager.default.fileExists(atPath: $0) })
        ?? NSHomeDirectory() + "/.claude/projects/\(projectDir)/agent-\(agentId).jsonl"
    }

    static var existingPlatforms: [AgentPlatform] {
        AgentPlatform.allCases.filter { FileManager.default.fileExists(atPath: $0.baseDirectory.path) }
    }
}

