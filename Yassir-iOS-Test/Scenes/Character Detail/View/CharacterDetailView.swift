import SwiftUI
import Kingfisher

struct CharacterDetailViewModel {
    let imageURL: URL?
    let name: String
    let subtitleAttributedString: AttributedString
    let locationAttributedString: AttributedString
    let characterStatusViewModel: CharacterStatusViewModel
}

extension CharacterDetailViewModel {
    init(from character: Character) {
        self.imageURL = character.imageURL
        self.name = character.name
        
        let subtitleBoldString = "\(character.species) •"
        var subtitleAttributedString = AttributedString("\(subtitleBoldString) \(character.gender)")
        subtitleAttributedString.swiftUI.foregroundColor = .primaryText
        subtitleAttributedString.swiftUI.font = .system(size: 16, weight: .regular)
        
        if let range = subtitleAttributedString.range(of: subtitleBoldString) {
            subtitleAttributedString[range].swiftUI.font = .system(size: 16, weight: .bold)
        }
        
        let locationString = "Location :"
        let locationName = character.location.name
        
        var locationAttributedString = AttributedString("\(locationString) \(locationName)")
        
        
        if let range = locationAttributedString.range(of: locationString) {
            locationAttributedString[range].swiftUI.font = .system(size: 16, weight: .bold)
            locationAttributedString[range].swiftUI.foregroundColor = .primaryText
        }
        
        if let range = locationAttributedString.range(of: locationName) {
            locationAttributedString[range].swiftUI.font = .system(size: 16, weight: .regular)
            locationAttributedString[range].swiftUI.foregroundColor = .secondaryText
        }
        
        self.subtitleAttributedString = subtitleAttributedString
        self.locationAttributedString = locationAttributedString
        self.characterStatusViewModel = CharacterStatusViewModel(status: character.status)
    }
}

struct CharacterDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 20) {
            makeImage()
            
            HStack(alignment: .top) {
                makeCharacterDetails()
                
                makeCharacterStatus()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading) {
            makeBackButton()
        }
    }
    
    private func makeImage() -> some View {
        GeometryReader { proxy in
            KFImage(viewModel.imageURL)
                .resizable()
                .scaledToFill()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .clipShape(.rect(cornerRadius: 25))
        }
        .frame(height: 400)
    }
    
    private func makeCharacterDetails() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 4) {
                Text(viewModel.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.subtitleAttributedString)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        
            Text(viewModel.locationAttributedString)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func makeCharacterStatus() -> some View {
        Text(viewModel.characterStatusViewModel.title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.primaryText)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                Color(red: 0.11, green: 0.8, blue: 0.97)
                    .clipShape(.capsule)
            }
    }
    
    private func makeBackButton() -> some View {
        Button(
            action: { dismiss() },
            label: {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 28, height: 28)

                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white)
                }
            }
        )
        .buttonStyle(.plain)
        .padding(.top, 32)
        .padding(.horizontal, 16)
    }
}
