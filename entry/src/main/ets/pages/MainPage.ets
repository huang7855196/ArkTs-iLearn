import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { HomePage } from '../../../../../HomeModule/src/main/ets/components/HomePage'
import { ToolBarItem } from '../../../../../commonModule/src/main/ets/models/ToolBarItem'
import { InterviewPage } from '../../../../../knowledgeModule/src/main/ets/components/InterviewPage'
import { MinePage } from '../../../../../mineModule/src/main/ets/components/MinePage'
import { ProjectComp } from '../../../../../projectModule/src/main/ets/components/ProjectComp'
import { AuthorUtils } from '../../../../../commonModule/src/main/ets/utils/AuthorUtils'
import { toolBars } from '../constant/Constants'

AuthorUtils.initLocalUser()
/*
 * @desc:首页
 * @author:hxy
 * @date:2024/2/17
 */
@Entry
@Component
struct MainPage {
  @State
  currentPosition: number = 0

  @Builder
  tabBarItem(item: ToolBarItem, index: number) {
    Column() {
      Image(this.currentPosition == index ? item.activeIcon : item.defaultIcon)
        .width(dp(24))
      Text(item.label)
        .fontSize(dp(12))
        .fontColor(this.currentPosition == index ? '#000' : '#aaa')
        .padding({ top: dp(4) })
    }
    .height(dp(50))
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      index: this.currentPosition
    }) {
      ForEach(toolBars, (item: ToolBarItem, index: number) => {
        TabContent() {
          if (index == 0) {
            HomePage()
          } else if (index == 1) {
            ProjectComp()
          } else if (index == 2) {
            InterviewPage()
          } else {
            MinePage()
          }
        }.tabBar(this.tabBarItem(item, index))
      })
    }
    .width('100%')
    .barPosition(BarPosition.End)
    .onChange((index) => {
      this.currentPosition = index
    })
  }
}