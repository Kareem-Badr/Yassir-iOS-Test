import SwiftUI
import Kingfisher

struct CharacterTableViewCell: View {
    private let viewModel: CharacterTableViewCellViewModel
    
    init(viewModel: CharacterTableViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        HStack(alignment: .top, spacing: 16) {
            makeImage()
            
            makeTitleAndSubtitle()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            makeBackground()
        }
        .overlay {
            makeOverlay()
        }
        .padding(.horizontal, 16)
        .contentShape(.rect)
        .onTapGesture(perform: viewModel.onTap)
    }
    
    private func makeImage() -> some View {
        KFImage(viewModel.imageURL)
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipShape(.rect(cornerRadius: 12))
    }
    
    private func makeTitleAndSubtitle() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.primaryText)
            
            Text(viewModel.species)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.secondaryText)
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func makeBackground() -> some View {
        viewModel
            .characterStatusViewModel
            .color
            .clipShape(.rect(cornerRadius: 12))
    }
    
    @ViewBuilder private func makeOverlay() -> some View {
        if !viewModel.shouldHideBorder {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.border, lineWidth: 1)
        }
    }
}
