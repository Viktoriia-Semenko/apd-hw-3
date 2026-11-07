import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let store = StudentStore()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let listViewController = StudentListViewController(store: store)
        window.rootViewController = UINavigationController(rootViewController: listViewController)
        window.makeKeyAndVisible()
        self.window = window
    }
}
