//
//  CustomMenu.swift
//  GGomVoca
//
//  Created by tae on 2023/02/10.
//

import SwiftUI
import UIKit


struct CustomMenu: UIViewRepresentable {
    @Binding var currentMode: ProfileSection
    @Binding var orderMode: String
    @Binding var speakOn: Bool
    @Binding var testOn: Bool
    @Binding var editOn: Bool
    @Binding var isImportVoca: Bool
    @Binding var isExportVoca: Bool
    @Binding var isCheckResult: Bool

    func makeUIView(context: Context) -> MenuButton {
        return MenuButton(frame: .zero, currentMode: $currentMode, orderMode: $orderMode, speakOn: $speakOn, testOn: $testOn, editOn: $editOn, isImportVoca: $isImportVoca, isExportVoca: $isExportVoca, isCheckResult: $isCheckResult)
    }

    func updateUIView(_ uiView: MenuButton, context: Context) {
    }
}

class MenuButton: UIButton {
    @Binding var currentMode: ProfileSection
    @Binding var orderMode: String
    @Binding var speakOn: Bool
    @Binding var testOn: Bool
    @Binding var editOn: Bool
    @Binding var isImportVoca: Bool
    @Binding var isExportVoca: Bool
    @Binding var isCheckResult: Bool


    init(frame: CGRect, currentMode: Binding<ProfileSection>, orderMode: Binding<String>, speakOn: Binding<Bool>, testOn: Binding<Bool>, editOn: Binding<Bool>, isImportVoca: Binding<Bool>, isExportVoca: Binding<Bool>, isCheckResult: Binding<Bool>) {
        self._currentMode = currentMode
        self._orderMode = orderMode
        self._speakOn = speakOn
        self._testOn = testOn
        self._editOn = editOn
        self._isImportVoca = isImportVoca
        self._isExportVoca = isExportVoca
        self._isCheckResult = isCheckResult
        super.init(frame: frame)

        renderingMenu()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateMode(mode: ProfileSection) {
        self.currentMode = mode
        renderingMenu()
    }

    func updateOrder(order: String) {
        self.orderMode = order
        renderingMenu()
    }

    func testMenu() -> UIMenu {

        let seeAll = UIAction(title: "?????? ??????",
                              state: currentMode == .normal ? .on : .off) { action in
          self.updateMode(mode: .normal)
        }
        let seeWord = UIAction(title: "????????? ??????",
                               state: currentMode == .meaningTest ? .on : .off) { action in
          self.updateMode(mode: .meaningTest)
        }
        let seeMeaning = UIAction(title: "?????? ??????",
                                  state: currentMode == .wordTest ? .on : .off) { action in
          self.updateMode(mode: .wordTest)
        }
      return UIMenu(title: "?????? ??????", subtitle: "\(currentMode.rawValue)", image: UIImage(systemName: "eye.fill"), children: [seeAll, seeWord, seeMeaning])
    }

    func orderMenu() -> UIMenu {
        let orderByRandom = self.orderByRandom()
        let orderByDict = self.orderByDict()
        let orderByDate = self.orderByDate()
      return UIMenu(title: "??????", subtitle: "\(orderMode)", image: UIImage(systemName: "arrow.up.arrow.down"), children: [orderByRandom, orderByDict, orderByDate])
    }

    func orderByRandom() -> UIAction {
        UIAction(title: "?????? ??????") { action in
          self.updateOrder(order: "?????? ??????")
        }
    }

    func orderByDict() -> UIAction {
        UIAction(title: "????????? ??????") { action in
          self.updateOrder(order: "????????? ??????")
        }
    }

    func orderByDate() -> UIAction {
        UIAction(title: "????????? ??????") { action in
          self.updateOrder(order: "????????? ??????")
        }
    }

    func takeTest() -> UIAction {
        UIAction(title: "?????? ??????",
                 image: UIImage(systemName: "square.and.pencil")) { action in
          self.testOn.toggle()
        }
    }

    func listenAll() -> UIAction {
        UIAction(title: "?????? ??????",
                 image: UIImage(systemName: "speaker.wave.3")) { action in
          self.speakOn.toggle()
        }
    }

    func editVoca() -> UIAction {
        UIAction(title: "????????? ??????",
                 image: UIImage(systemName: "checkmark.circle")) { action in
          self.editOn.toggle()
        }
    }

    func importVoca() -> UIAction {
        UIAction(title: "????????? ????????????",
                 image: UIImage(systemName: "square.and.arrow.down")) { action in
          self.isImportVoca.toggle()
        }
    }

    func exportVoca() -> UIAction {
        UIAction(title: "????????? ????????????",
                 image: UIImage(systemName: "square.and.arrow.up")) { action in
          self.isExportVoca.toggle()
        }
    }

    func checkResult() -> UIAction {
        UIAction(title: "?????? ?????? ??????",
                 image: UIImage(systemName: "chart.line.uptrend.xyaxis")) { action in
          self.isCheckResult.toggle()
        }
    }

    func renderingMenu() {
        let testMenu = self.testMenu()
        // ?????? ??????
        let takeTest = self.takeTest()
        // ?????? ?????? ??????
        let listenAll = self.listenAll()
        // ??????
        let orderMenu = self.orderMenu()
        // ????????? ??????
        let editVoca = self.editVoca()
        // ????????? ????????????
        let importVoca = self.importVoca()
        // ????????? ????????????
        let exportVoca = self.exportVoca()
        // ?????? ?????? ??????
        let checkResult = self.checkResult()

        let modeTestMenu = UIMenu(title: "", options: .displayInline, children: [testMenu, takeTest, checkResult])
        let orderVocaMenu = UIMenu(title: "", options: .displayInline, children: [orderMenu, editVoca, importVoca, exportVoca])

        setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        menu = UIMenu(title: "", children: [modeTestMenu, orderVocaMenu, listenAll])
        showsMenuAsPrimaryAction = true
    }




}

