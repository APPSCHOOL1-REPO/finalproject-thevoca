//
//  JPWordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct JPWordsTableView: View {
    // MARK: SuperView Properties
    @ObservedObject var viewModel: JPWordListViewModel
    var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    
    // MARK: View Properties
    /// - 단어 수정 관련 State
    @State var editWord: Bool = false
    @State var editingWord: Word = Word()
    
    /// - 단어 리스트 편집 관련 State
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<Word>
    
    var body: some View {
        // MARK: - Header
        HStack {
            if isSelectionMode {
                Image(systemName: "circle")
                    .foregroundColor(.clear)
            }
            Text("단어")
                .headerText()
            Text("발음")
                .headerText()
            Text("뜻")
                .headerText()
        }
        .padding(.horizontal, 20)
        .background {
            Rectangle()
                .fill(Color("fourseason"))
                .frame(height: 30)
        }
        .animation(Animation.spring(), value: isSelectionMode)
        
        // MARK: - Content
        List($viewModel.words, id: \.self, selection: $multiSelection) { $word in
            HStack {
                // 단어
                Text(word.word ?? "")
                    .horizontalAlignSetting(.center)
                    .multilineTextAlignment(.center)
                    .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                // 발음
                Text(word.option ?? "")
                    .horizontalAlignSetting(.center)
                    .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                // 뜻
                Text(word.meaning!.joined(separator: ", "))
                    .horizontalAlignSetting(.center)
                    .opacity((selectedSegment == .meaningTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
            }
            .frame(minHeight: 40)
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive){
                    viewModel.deleteWord(word: word)
                }label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
            .contextMenu {
                if selectedSegment == .normal {
                    Button {
                        editingWord = word
                        editWord.toggle()
                    } label: {
                        Label("수정하기", systemImage: "gearshape.fill")
                    }
                    Button {
                        SpeechSynthesizer.shared.speakWordAndMeaning(word, to: "ja-JP", .single)
                    } label: {
                        Label("발음 듣기", systemImage: "mic.fill")
                    }
                }
            }
        } // List
        .listStyle(.plain)
        .padding(.top, -10)
        .environment(\.editMode, .constant(self.isSelectionMode ? EditMode.active : EditMode.inactive)).animation(Animation.spring(), value: isSelectionMode)
        // MARK: 단어 편집 시트
        .sheet(isPresented: $editWord) {
            JPEditWordView(viewModel: viewModel, editWord: $editWord, editingWord: $editingWord)
                .presentationDetents([.medium])
        }
        .onDisappear {
            SpeechSynthesizer.shared.stopSpeaking()
        }
    }
}

//struct JPWordsTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        JPWordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(FRWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR)
//    }
//}
