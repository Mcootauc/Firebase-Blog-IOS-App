/**
 * ArticleList displays a list of articles, toggling between the list and a chosen article.
 */
import SwiftUI
import Foundation
import UIKit

struct ArticleList: View {
    @EnvironmentObject var auth: BareBonesBlogAuth
    @EnvironmentObject var articleService: BareBonesBlogArticle

    @Binding var requestLogin: Bool

    @State var articles: [Article]
    @State var error: Error?
    @State var fetching = false
    @State var writing = false
    @State private var showWebView = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if fetching {
                        ProgressView()
                    } else if error != nil {
                        Text("Something went wrong…we wish we can say more 🤷🏽")
                    } else if articles.count == 0 {
                        VStack {
                            Spacer()
                            Text("There are no articles.")
                            Spacer()
                        }
                    } else {
                        List(searchResults) { article in
                            NavigationLink {
                                ArticleDetail(articles: $articles, article: article)
                                
                            } label: {
                                ArticleMetadata(article: article)
                            }
                        }
                        .colorMultiply(Color.brown)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Song Blog 🎶")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("New Article") {
                            writing = true
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigation) {
                    if auth.user != nil {
                        Button {
                            showWebView.toggle()
                        } label: {
                            Text("Top Songs")
                        }
                        .sheet(isPresented: $showWebView) {
                            WebView(url: URL(string: "https://www.billboard.com/charts/hot-100/")!)
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if auth.user != nil {
                        Button("Sign Out") {
                            do {
                                try auth.signOut()
                            } catch {
                                // No error handling in the sample, but of course there should be
                                // in a production app.
                            }
                        }
                    } else {
                        Button("Sign In") {
                            requestLogin = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $writing) {
            ArticleEntry(articles: $articles, writing: $writing)
        
        }
        .task {
            fetching = true

            do {
                articles = try await articleService.fetchArticles()
                fetching = false
            } catch {
                self.error = error
                fetching = false
            }
        }
    }
    var searchResults: [Article] {
            if searchText.isEmpty {
                return articles
            } else {
                return articles.filter { a in a.title.contains(searchText) || a.body.contains(searchText) }
            }
        }
}

struct ArticleList_Previews: PreviewProvider {
    @State static var requestLogin = false

    static var previews: some View {
        ArticleList(requestLogin: $requestLogin, articles: [])
            .environmentObject(BareBonesBlogAuth())

        ArticleList(requestLogin: $requestLogin, articles: [
            Article(
                id: "12345",
                title: "Preview",
                date: Date(),
                body: "Lorem ipsum dolor sit something something amet",
                delete: false
            ),

            Article(
                id: "67890",
                title: "Some time ago",
                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
                body: "Duis diam ipsum, efficitur sit amet something somesit amet",
                delete: false
            )
        ])
        .environmentObject(BareBonesBlogAuth())
        .environmentObject(BareBonesBlogArticle())
    }
}
