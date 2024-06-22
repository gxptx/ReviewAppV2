import SwiftUI

struct ContentView: View {
    @State private var reviews: [Review] = []
    @State private var placeImageURL: URL?
    @State private var currentIndex = 0
    @State private var cardOffset: CGSize = .zero
    private let networkManager = NetworkManager()

    var body: some View {
        ZStack {
            ForEach(reviews.indices.reversed(), id: \.self) { index in
                ReviewCard(review: self.reviews[index], placeImageURL: self.placeImageURL)
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
                if let url = placeImageURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                             .clipped()
                             .blur(radius: 5, opaque: true)
                             .overlay(Color.black.opacity(0.2))
                    } placeholder: {
                        Color.black.opacity(0.2)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            fetchRandomReview()
        }
    }

    private func fetchRandomReview() {
        networkManager.fetchRandomPlace { place in
            guard let place = place, let reviews = place.reviews, let photo = place.photos?.first else {
                return
            }
            DispatchQueue.main.async {
                self.reviews = reviews
                self.placeImageURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photo.photoReference)&key=\(networkManager.apiKey)")
            }
        }
    }

    private func moveCard(offset: Int) {
        currentIndex = (currentIndex + offset + reviews.count) % reviews.count
        cardOffset = .zero
    }
}
