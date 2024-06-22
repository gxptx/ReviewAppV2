import SwiftUI

struct ReviewCard: View {
    var review: Review
    var placeImageURL: URL?

    var body: some View {
        ZStack {
            if let url = placeImageURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                         .cornerRadius(15)
                         .shadow(radius: 5)
                } placeholder: {
                    Color.gray
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            } else {
                Color.gray
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }

            VStack {
                Text(review.authorName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text(review.text)
                    .font(.body)
                    .padding()
                    .lineLimit(1) // Only show one line initially

                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.orange)
                    }
                }
                .padding()

                Text("Total Reviews: \(review.userRatingsTotal ?? 0)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .onTapGesture {
            // Handle showing the full review text here
        }
    }
}
