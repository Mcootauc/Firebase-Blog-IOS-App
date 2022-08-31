/**
 * ArticleDetail displays a single article model object.
 */
import SwiftUI

struct ArticleDetail: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var articleService: BareBonesBlogArticle
    @Binding var articles: [Article]
    
    var article: Article
    
    func deleteArticle(){
        let id = article.id
        articleService.deleteArticle(articleID: id)
        articles.removeAll {a in a.id == id}
        dismiss()
    }

    var body: some View {
        VStack {
            ArticleMetadata(article: article)
                .padding()
            Text(article.body).padding()
            Spacer()
            Button("Delete"){
                deleteArticle()
                
            }.padding()
        }
    }
}

struct ArticleDetail_Previews: PreviewProvider {
    @State static var articles: [Article] = []
    static var previews: some View {
        ArticleDetail(articles: $articles, article: Article(
            id: "12345",
            title: "Preview",
            date: Date(),
            body: "Lorem ipsum dolor sit something something amet",
            delete: false
            
        ))
            }
}
