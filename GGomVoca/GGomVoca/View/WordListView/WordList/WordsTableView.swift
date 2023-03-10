//
//  WordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordsTableView: View {
    // MARK: SuperView Properties
    @ObservedObject var viewModel: WordListViewModel
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
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                if isSelectionMode {
                    Image(systemName: "circle")
                        .foregroundColor(.clear)
                        .font(.title2)
                        .padding(.vertical, -10)
                }
                
                switch viewModel.nationality {
                case "KO", "JA":
                    Text("단어")
                        .headerText()
                    Text("발음")
                        .headerText()
                    Text("뜻")
                        .headerText()
                case "EN", "FR":
                    Text("단어")
                        .headerText()
                    Text("뜻")
                        .headerText()
                default:
                    EmptyView()
                }
            }
            .animation(.default, value: isSelectionMode)
            .padding(.horizontal, 20)
            .background {
                Rectangle()
                    .fill(Color("fourseason"))
                    .frame(height: 30)
            }
            
            // MARK: - Content
            List($viewModel.words, id: \.self, selection: $multiSelection) { $word in
                HStack {
                    switch viewModel.nationality {
                    case "KO", "JA":
                        HStack {
                            Text(word.word ?? "")
                                .horizontalAlignSetting(.center)
                                .multilineTextAlignment(.center)
                                .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                                .animation(.none, value: isSelectionMode)
                            VLine()
                            Text(word.option ?? "")
                                .horizontalAlignSetting(.center)
                                .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                                .animation(.none, value: isSelectionMode)
                            VLine()
                            Text(word.meaning!.joined(separator: ","))
                                .horizontalAlignSetting(.center)
                                .opacity((selectedSegment == .meaningTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                                .animation(.none, value: isSelectionMode)
                        }
                    case "FR", "EN":
                        Text(word.word ?? "")
                            .horizontalAlignSetting(.center)
                            .multilineTextAlignment(.center)
                            .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                            .animation(.none, value: isSelectionMode)
                        VLine()
                        HStack(spacing: 0) {
                            // MARK: 단어의 성별에 따라 표시하는 이미지 변경
                            switch word.option {
                            case "f":
                                Image(systemName: "f.square")
                                    .font(.subheadline)
                                    .opacity(0.5)
                                    .padding(.trailing, 5)
                            case "m":
                                Image(systemName: "m.square")
                                    .font(.subheadline)
                                    .opacity(0.5)
                                    .padding(.trailing, 5)
                            default:
                                EmptyView()
                            }
                            
                            Text(word.meaning!.joined(separator: ", "))
                        }
                        .horizontalAlignSetting(.center)
                        .opacity((selectedSegment == .meaningTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                        .animation(.none, value: isSelectionMode)
                        
                    default:
                        Text("default")
                    }
                }
                .frame(minHeight: 40)
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                .overlay {
                    if !isSelectionMode {
                        Color.clear
                            .frame(width: UIScreen.main.bounds.width)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedSegment != .normal {
                                    /// - 편집모드가 아닐때는 단어를 가렸다가 보였다가 할 수 있도록
                                    if unmaskedWords.contains(word.id) {
                                        if let tmpIndex = unmaskedWords.firstIndex(of: word.id) {
                                            unmaskedWords.remove(at: tmpIndex)
                                        }
                                    } else {
                                        unmaskedWords.append(word.id)
                                    }
                                }
                            }
                    }
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
            .environment(\.editMode, .constant(self.isSelectionMode ? EditMode.active : EditMode.inactive))
            .animation(.default, value: isSelectionMode)
            // MARK: 단어 편집 시트
            .sheet(isPresented: $editWord) {
                EditWordView(viewModel: viewModel, editWord: $editWord, editingWord: $editingWord)
                    .presentationDetents([.medium])
            }
            .onDisappear {
                SpeechSynthesizer.shared.stopSpeaking()
            }
        }
    }
}

//struct WordsTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(FRWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR)
//    }
//}
