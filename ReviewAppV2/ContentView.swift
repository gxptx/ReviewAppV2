import SwiftUI

struct Review: Identifiable {
    var id: UUID
    var image: String
    var title: String
    var reviewText: String
    var rating: Int
    var reviewCount: Int
}

let sampleReviews = [
    Review(id: UUID(), image: "bg1", title: "My time at Bali", reviewText: "It left me speechless...", rating: 8, reviewCount: 592),
    Review(id: UUID(), image: "bg2", title: "Exploring Paris", reviewText: "A wonderful experience!", rating: 9, reviewCount: 480),
    Review(id: UUID(), image: "bg3", title: "Skiing in Switzerland", reviewText: "Breathtaking views and slopes!", rating: 7, reviewCount: 340),
    Review(id: UUID(), image: "bg4", title: "Beach days in Maldives", reviewText: "Paradise on Earth!", rating: 5, reviewCount: 890),
    Review(id: UUID(), image: "bg5", title: "Cultural immersion in Kyoto", reviewText: "Rich history and traditions.", rating: 5, reviewCount: 720),
    Review(id: UUID(), image: "bg6", title: "Road trip across Australia", reviewText: "Unforgettable landscapes.", rating: 9, reviewCount: 410),
    Review(id: UUID(), image: "bg7", title: "New York City adventures", reviewText: "City that never sleeps!", rating: 10, reviewCount: 600),
    Review(id: UUID(), image: "bg8", title: "Hiking in the Rockies", reviewText: "Majestic mountains and wildlife.", rating: 8, reviewCount: 550),
    Review(id: UUID(), image: "bg9", title: "Exploring Tokyo", reviewText: "Fascinating blend of modern and tradition.", rating: 7, reviewCount: 490),
    Review(id: UUID(), image: "bg10", title: "Cruise in the Caribbean", reviewText: "Relaxing and luxurious experience.", rating: 10, reviewCount: 380),
]

struct ContentView: View {
    @State private var reviews = sampleReviews.shuffled()
    @State private var currentIndex = 0
    @State private var cardOffset: CGSize = .zero

    var body: some View {
        ZStack {
            ForEach(reviews.indices.reversed(), id: \.self) { index in
                ReviewCard(review: self.reviews[index], currentIndex: self.currentIndex, index: index)
                    .offset(x: index == self.currentIndex ? self.cardOffset.width : 0, y: index == self.currentIndex ? self.cardOffset.height : 0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.cardOffset = value.translation
                            }
                            .onEnded { value in
                                let cardWidth = UIScreen.main.bounds.width * 0.8
                                if abs(value.translation.width) > cardWidth * 0.5 {
                                    withAnimation {
                                        self.moveCard(offset: value.translation.width > 0 ? 1 : -1)
                                    }
                                } else {
                                    withAnimation {
                                        self.cardOffset = .zero
                                    }
                                }
                            }
                    )
            }
        }
        .background(
            ZStack {
                if let imageName = UIImage(named: reviews[currentIndex].image) {
                    Image(uiImage: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .clipped()
                        .blur(radius: 5, opaque: true)
                        .overlay(Color.black.opacity(0.2))
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
    }

    private func moveCard(offset: Int) {
        withAnimation {
            currentIndex = (currentIndex + offset + reviews.count) % reviews.count
            cardOffset = .zero
        }
    }
}

struct ReviewCard: View {
    var review: Review
    var currentIndex: Int
    var index: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(review.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.65)
                .cornerRadius(15)
                .clipped()
                .shadow(radius: 5)

            VStack(spacing: 10) {
                Text(review.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)

                Text(review.reviewText)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)

                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: Double(index) <= Double(review.rating) / 2.0 ? "star.fill" : (Double(index) - 0.5 <= Double(review.rating) / 2.0 ? "star.leadinghalf.fill" : "star"))
                            .foregroundColor(.orange)
                    }
                }

                Text("Reviews: \(review.reviewCount)")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)            }
            .padding()
            .background(Color.black.opacity(0.5)) // Semi-opaque background
            .cornerRadius(15) // Rounded corners for the container
            .frame(width: UIScreen.main.bounds.width * 0.75) // Adjusted frame width
            .padding(.bottom, 10) // Add bottom padding
        }
        .offset(x: index == currentIndex ? 0 : UIScreen.main.bounds.width, y: 0)
        .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: index == currentIndex)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
