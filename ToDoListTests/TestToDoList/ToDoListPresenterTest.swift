//
//  ToDoListPresenterTest.swift
//  ToDoListTests
//
//  Created by Ahmed Ahmedov on 16.10.2021.
//

import XCTest
@testable import ToDoList



/*
Впервые юзал тесты, наверное получилось не очень, покрывать тестовый проект полностью тестами мне кажется сомнительным делом, думаю как я понял работу с ними можно понять и по этому классу (P.s. если возьмете меня на работу, готов покрывать тестами все что угодно xD)
 */




//не тестируемое shit начинается туть
struct TableCellConfigurator3<CellType: Configurable, Model>: TableCellConfiguratorProtocol
where CellType.Model == Model, CellType: UITableViewCell {

    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: Model?
    var cellHeight: CGFloat
    var headerHeight: CGFloat
    
    
    // MARK: - Init

    init(item: Model?,
         cellHeight: CGFloat = UITableView.automaticDimension,
         headerHeight: CGFloat = UITableView.automaticDimension) {
    
        self.item = item
        self.cellHeight = cellHeight
        self.headerHeight = headerHeight
    }
    
    
    // MARK: - Public methods
    
    func configure(cell: UIView) {
        guard let item = item else { return }
        (cell as? CellType)?.configure(with: item)
    }
    
    func associatedValue<T>() -> T? {
        return item as? T
    }
}
//кончается туть

class MockDataConverter: ToDoListDataConverterInput {

    private typealias TaskConfigurator = TableCellConfigurator3<TaskCell, TaskCell.Model>
    
    func convert(tasks: [TaskModel], delegate: TaskCellDelegate, imageInteractionService: ImageInteractionService, newTaskList: @escaping ([TaskModel]) -> Void) -> ToDoListViewModel {

        return ToDoListViewModel(sections: [ToDoListViewModel.Section(headerTitle: "", rows: [ToDoListViewModel.Section.Row(configurator: TaskConfigurator(item: nil) as TableCellConfiguratorProtocol)])])
    }
}

class MockImageInteractionService: ImageInteractionService {
    
    func saveImage(imageName: String, image: UIImage) {
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        return nil
    }
}

class MockToDoListRouter: ToDoListRouterInput {
    
    var isOpenDetailTaskWasCall = false
    
    func openDetailTask(task: TaskModel, delegate: ToDoListDelegate) {
        isOpenDetailTaskWasCall = true
    }
    
    func openNewTask(delegate: ToDoListDelegate) {
        
    }
}

class MockToDoListInteractor: ToDoListInteractorInput {
    
    var taskList = [TaskModel(), TaskModel()]
    var taskCompleted = true
    
    func obtainTasks() {}
    
    func removeTask(task: TaskModel) {
        taskList.removeLast()
    }
    
    func changeTaskCompleted(task: TaskModel, complitedDate: Date?) {
        taskCompleted = task.isCompleted
    }
}

class MockToDoListView: ToDoListViewInput {
    
    var viewModel: ToDoListViewModel?
    
    func updateView(with viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    func reloadScreen() {}
    
    func showError() {}
}

class ToDoListPresenterTest: XCTestCase {
    
    var presenter: ToDoListPresenter!
    var mockDataConverter = MockDataConverter()
    var mockimageInteractionService = MockImageInteractionService()
    var router = MockToDoListRouter()
    var interactor = MockToDoListInteractor()
    var view = MockToDoListView()
    
    override func setUpWithError() throws {
        
        presenter = ToDoListPresenter(dataConverter: mockDataConverter, imageInteractionService: mockimageInteractionService)
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = view
    }
    
    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testModuleIsNotNil() {
        XCTAssertNotNil(presenter, "presenter is not nil")
    }
    
    
    func testSuccessCallToRouterForOpenTaskDetail() {
        //Given
        let tasks = [TaskModel()]
        
        //When
        presenter.didSuccessToObtainTasks(with: tasks)
        presenter.didSelect(section: 0, index: 0)
        
        //Then
        
        XCTAssertEqual(router.isOpenDetailTaskWasCall, true)
    }
    
    func testFailureCallToRouterForOpenTaskDetail() {
        //Given
        let tasks: [TaskModel] = []

        //When
        presenter.didSuccessToObtainTasks(with: tasks)
        presenter.didSelect(section: 1, index: 3)
        
        //Then
        XCTAssertEqual(router.isOpenDetailTaskWasCall, false)
    }
    
    func testSuccessCallToInteractorForDeleteTask() {
        //Given
        let taskCountBeforeRemoveOne = interactor.taskList.count

        //When
        presenter.didSuccessToObtainTasks(with: [TaskModel()])
        presenter.didRemove(section: 0, index: 0)
        
        //Then
        XCTAssertNotEqual(taskCountBeforeRemoveOne, interactor.taskList.count)
    }
    
    func testFailureCallToInteractorForDeleteTask() {
        //Given
        let taskCountBeforeRemoveOne = interactor.taskList.count
        
        //When
        presenter.didSuccessToObtainTasks(with: [])
        presenter.didRemove(section: 0, index: 0)
        
        //Then
        XCTAssertEqual(taskCountBeforeRemoveOne, interactor.taskList.count)
    }
    
    func testObtainTasks() {
        //Given
        let tasks = [TaskModel()]

        //When
        presenter.didSuccessToObtainTasks(with: tasks)
        
        //Then
        XCTAssert(view.viewModel != nil)
    }
    
    func testChangeTaskNotCompleted() {
        //Given
        let task = TaskModel()
        
        //When
        presenter.taskWasChecked(task: task)
        
        //Then
        XCTAssertEqual(interactor.taskCompleted, task.isCompleted)
    }
}
