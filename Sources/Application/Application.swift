import Foundation
import Kitura
import KituraStencil
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    var rootDirectoryPath: String {
        let fileManager = FileManager()
        let currentPath = fileManager.currentDirectoryPath
        return currentPath
    }
    
    var rootDirectory: URL {
        return URL(fileURLWithPath: rootDirectoryPath)
    }
    
    var publicDirectory: URL {
        return rootDirectory.appendingPathComponent("public")
    }
    
    var uploadsDirectory: URL {
        return publicDirectory.appendingPathComponent("uploads")
    }
    
    var originalsDirectory: URL {
        return uploadsDirectory.appendingPathComponent("originals")
    }
    
    var thumbsDirectory: URL {
        return uploadsDirectory.appendingPathComponent("thumbs")
    }

    public init() throws {
        // Configure logging
        initializeLogging()
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Set Stencil as template engine
        router.setDefault(templateEngine: StencilTemplateEngine())
        
        // Endpoints
        initializeHealthRoutes(app: self)
        
        
        /*for directory in [rootDirectory, publicDirectory, uploadsDirectory, originalsDirectory, thumbsDirectory] {
            //let path = directory.path
            let fileManager = FileManager()
            if let allFiles = try? fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles) {
                let files = allFiles.filter { !$0.path.hasSuffix("/") }
                //allFiles.forEach { print($0.path.last ?? "nil") }
                print(#line, #function, "Contents of directory \(directory.path):")
                //files.forEach { print($0.lastPathComponent) }
                files.forEach { print($0) }
                print()
            }
        }*/
        
        //router.all("/public", middleware: StaticFileServer())
        router.all("/pikachu", middleware: StaticFileServer(path: "\(rootDirectoryPath)/public/Pikachu"))
        
        router.all("/originals", middleware: StaticFileServer(path: originalsDirectory.path))
        
        router.get("/public*") { request, response, next in
            defer { next() }
            
            let fileManager = FileManager()
            
            guard let files = try? fileManager.contentsOfDirectory(
                at: self.originalsDirectory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            ) else { return }
            
            try response.render("list", context: ["files": files.map { $0.lastPathComponent }])
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
