import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let requester = URLSession.shared
        let networkManager = NetworkService(requester: requester)
        let viewModel = MainViewModel(networkService: networkManager)
        window?.rootViewController = MainViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }
}
