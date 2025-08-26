import SwiftUI

@main
struct TodoListApp: App {
    @StateObject private var viewModel = TaskViewModel(todoService: TodoService.shared)
    
    var body: some Scene {
        WindowGroup {
            TaskListView(viewModel: viewModel)
        }
    }
}
