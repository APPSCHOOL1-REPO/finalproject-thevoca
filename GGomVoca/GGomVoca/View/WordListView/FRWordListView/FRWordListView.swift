//
//  FRWordListView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/19.
//

import SwiftUI
import CoreData

struct FRWordListView: View {
    // MARK: Data Properties
    var vocabularyID: UUID
    @StateObject var viewModel: FRWordListViewModel = FRWordListViewModel()
    
    // MARK: View Properties
    @State var navigationTitle: String = ""
    @State private var showOption: Bool = false
    @State private var selectedSegment: ProfileSection = .normal
    @State private var selectedWord: [UUID] = []
    
    // MARK: 단어 추가 버튼 관련 State
    @State var isShowingAddWordView: Bool = false
    @State var isShowingEditWordView: Bool = false
    @State var bindingWord: Word = Word()
    
    var body: some View {
        VStack {
            SegmentView(selectedSegment: $selectedSegment, selectedWord: $selectedWord)
            if viewModel.filteredWords.count <= 0 {
                VStack(alignment: .center){
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("단어를 추가해주세요")
                        .font(.title3)
                    Spacer()
                }
                .foregroundColor(.gray)
            } else {
                FRWordsTableView(selectedSegment: selectedSegment,
                                 selectedWord: $selectedWord,
                                 filteredWords: $viewModel.filteredWords,
                                 isShowingEditView: $isShowingEditWordView,
                                 bindingWord: $bindingWord)
                    .padding()
            }
            
        }
        // 단어 편집
        .sheet(isPresented: $isShowingEditWordView) {
            EditWordView(vocabularyNationality: viewModel.selectedVocabulary.nationality ?? "",
                         bindingWord: $bindingWord)
                .presentationDetents([.medium])
                .onDisappear(perform: {
                    words = vocabulary.words?.allObjects as! [Word]
                })
//                .onDisappear(perform: {
//                    words = viewModel.selectedVocabulary.words?.allObjects as! [Word]
//                })
        }
        // 새 단어 추가 시트
        .sheet(isPresented: $isShowingAddWordView) {
            FRAddNewWordView(vocabulary: vocabulary, isShowingAddWordView: $isShowingAddWordView, words: $words, filteredWords: $filteredWords)
                .presentationDetents([.height(CGFloat(500))])
        }
        .sheet(isPresented: $showOption) {
            OptionSheetView(words: $filteredWords, vocabulary: vocabulary)
                .presentationDetents([.height(CGFloat(350))])
            //                    .presentationDetents([.medium, .large, .height(CGFloat(100))])
        }
        .onAppear {
            viewModel.getVocabulary(vocabularyID: vocabularyID)
//            words = viewModel.selectedVocabulary.words?.allObjects as! [Word]
            navigationTitle = viewModel.selectedVocabulary.name ?? ""
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                VStack(alignment: .center) {
                    Text("\($viewModel.filteredWords.count)")
                        .foregroundColor(.gray)
                }
            }
            // + 버튼
            ToolbarItem {
                Button {
                    isShowingAddWordView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem {
                // 햄버거 버튼일 때
                Menu {
                    Button {
                        viewModel.words.shuffle()
                    } label: {
                        HStack {
                            Text("단어 순서 섞기")
                            Image(systemName: "shuffle")
                        }
                    }
                    
                    Button {
                        print("전체 단어 재생하기")
                    } label: {
                        HStack {
                            Text("전체 단어 재생하기")
                            Image(systemName: "play.fill")
                        }
                    }
                    .disabled(true)
                    
                    NavigationLink {
                        ImportCSVFileView(vocabulary: viewModel.selectedVocabulary)
                    } label: {
                        HStack {
                            Text("단어 가져오기")
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    
                    Button {
                        print("export")
                    } label: {
                        HStack {
                            Text("단어 리스트 내보내기")
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .disabled(true)
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
    }
}
