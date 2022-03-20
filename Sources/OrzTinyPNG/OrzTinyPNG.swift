import ConsoleKit
import Foundation

@main
struct OrzTinyPNG {
    static func main() async throws {
        let console: Console = Terminal()
        let input = CommandInput(arguments: CommandLine.arguments)
        let commandContext = CommandContext(console: console, input: input)
        do {
            let command: AnyCommand = CompressImageCommand()
            try console.run(command, with: commandContext)
        } catch let error {
            console.error("\(error)")
            exit(1)
        }
    }
}
