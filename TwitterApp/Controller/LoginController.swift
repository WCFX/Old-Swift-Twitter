import UIKit

class LoginController: UIViewController {
  
  // MARK - Properties
  
  private let logoImageView: UIImageView = {
    let logo = UIImageView()
    logo.contentMode = .scaleAspectFit
    logo.clipsToBounds = true
    logo.image = #imageLiteral(resourceName: "TwitterLogo")
    
    return logo
  }()
  
  private lazy var emailContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
    
    let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
    
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
    
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)

    return view
  }()

  
  private let emailTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Email")
    return tf
  }()
  
  private let passwordTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log in", for: .normal)
    button.setTitleColor(.twitterBlue, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 8
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    
    return button
  }()
  
  private let dontHaveAccountButton: UIButton = {
    let button = Utilities().atttributedButton("Don't have an account? ", "Sign Up")
    button.addTarget(self, action: #selector(handleNavigateToSignUp), for: .touchUpInside)
    return button
  }()
  
  
  // MARK - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  
  // MARK - Selectors
  
  @objc func handleLogin(){
  
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        print("DEBUG: Error loggin in \(error.localizedDescription)")
        return
      }
      let scenes = UIApplication.shared.connectedScenes
      let windowScene = scenes.first as? UIWindowScene
      guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else {
        return }
      
      guard let tab = window.rootViewController as? MainTabController else { return }
      
      tab.authenticateUserAndConfigureUI()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func handleNavigateToSignUp(){
    let controller = RegistrationController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  
  //MARK - Helpers
  func configureUI(){
    view.backgroundColor = .twitterBlue
    navigationController?.navigationBar.tintColor = .white
    
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 150, height: 150)
    
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
   
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    
  }
  
  
}
