import SwiftUI

struct FilterView: View {
    @State private var selectedStatus: CharacterStatusViewModel?
    private let viewModel: CharactersListViewModel
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(viewModel.output.characterStatuses) { status in
                makeButton(for: status)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func makeButton(for status: CharacterStatusViewModel) -> some View {
        Button(
            action: {
                if selectedStatus == status {
                    selectedStatus = nil
                } else {
                    selectedStatus = status
                }
                
                viewModel.input.filterTrigger.send(selectedStatus?.status)
            },
            label: {
                Text(status.title)
                    .font(.headline)
                    .foregroundStyle(selectedStatus == status ? .white : .primaryText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background {
                        if selectedStatus == status {
                            Color
                                .secondaryText
                        } else {
                            Color
                                .clear
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.selectionButtonBorder, lineWidth: 1)
                    }
                    .clipShape(.rect(cornerRadius: 25))
            }
        )
    }
}
