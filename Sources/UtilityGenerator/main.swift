import UtilityGeneratorCore

let gen = UtilityGenerator()

do {
    try gen.run()
} catch {
    print("whoops, error: \(error)")
}
