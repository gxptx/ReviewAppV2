import SwiftUI

// Data Model
struct Review: Identifiable {
    var id: UUID
    var image: String
    var title: String
    var reviewText: String
    var rating: Int
    var reviewCount: Int
}

// Sample Reviews Array
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

// ContentView
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
                                    self.moveCard(offset: value.translation.width > 0 ? 1 : -1)
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
                        .blur(radius: 10)
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
        VStack {
            Image(review.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                .cornerRadius(15)
                .shadow(radius: 5)

            VStack {
                Text(review.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text(review.reviewText)
                    .font(.body)
                    .padding()

                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.orange)
                    }
                }
                .padding()

                Text("Reviews: \(review.reviewCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .offset(x: index == currentIndex ? 0 : UIScreen.main.bounds.width, y: 0)
        .animation(.interpolatingSpring(stiffness: 100, damping: 10)) // Optional: Specify default animation here
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
