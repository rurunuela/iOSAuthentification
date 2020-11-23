//
//  ContentView.swift
//  AppleAuthentification
//
//  Created by Richard Urunuela on 20/11/2020.
//
//https://medium.com/better-programming/swiftui-sign-in-with-apple-c1e70ccb2a71
import SwiftUI
import AuthenticationServices
class AuthorizationController:NSObject,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print(" ANCHOR")
        let vc = UIApplication.shared.windows.last?.rootViewController
              return (vc?.view.window!)!
    }
    
    @objc func didTapButton() {
        print(" tap button")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
               let request = appleIDProvider.createRequest()
               request.requestedScopes = [.fullName, .email]
               
               let authorizationController = ASAuthorizationController(authorizationRequests: [request])
               authorizationController.presentationContextProvider = self
               authorizationController.delegate = self
               authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print( " OK " )
        let credential = authorization.credential as! ASAuthorizationAppleIDCredential
        print( "\(credential.user)" )
        print( "\(credential.email)" )
        print( "\(credential.fullName)" )
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print( " NOK " )
        print( "\(error)" )
    }
}

struct SignInWithAppleView: UIViewRepresentable {
    var  auth = AuthorizationController()

func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(auth, action:  #selector(auth.didTapButton), for: .touchUpInside)
        return (button)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
struct ContentView: View {
    var body: some View {
        VStack(){
            SignInWithAppleView()
                        .frame(width: 200, height: 50)
        }.onAppear(){
            print(" appear ")
            if let userID = UserDefaults.standard.object(forKey: "userId") as? String {
                        let appleIDProvider = ASAuthorizationAppleIDProvider()
                        appleIDProvider.getCredentialState(forUserID: userID) { (state, error) in
                                print(" STATE \(state)")
                        }
            }else {
                print(" NO CREDENTIAL")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
