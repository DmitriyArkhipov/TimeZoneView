import SwiftUI
import UIKit

// MARK: - Custom Fade Transition Delegate
class FadeNavigationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        // Only apply fade for push (forward) navigation
        if operation == .push {
            return FadeTransitionAnimator()
        }
        return nil // Use default animation for pop (keeps swipe gesture)
    }
}

// MARK: - Fade Transition Animator
class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(toView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.alpha = 1
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

// MARK: - SwiftUI View Modifier
struct FadeNavigationTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NavigationControllerConfigurator())
    }
}

// MARK: - UIViewControllerRepresentable to configure navigation controller
struct NavigationControllerConfigurator: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ConfiguratorViewController {
        ConfiguratorViewController(delegate: context.coordinator)
    }

    func updateUIViewController(_ uiViewController: ConfiguratorViewController, context: Context) {}

    func makeCoordinator() -> FadeNavigationTransitionDelegate {
        FadeNavigationTransitionDelegate()
    }

    class ConfiguratorViewController: UIViewController {
        let delegate: FadeNavigationTransitionDelegate

        init(delegate: FadeNavigationTransitionDelegate) {
            self.delegate = delegate
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.delegate = delegate
        }
    }
}

// MARK: - View Extension
extension View {
    func fadeNavigationTransition() -> some View {
        modifier(FadeNavigationTransition())
    }
}
